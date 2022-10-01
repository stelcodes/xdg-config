#!/usr/bin/env bb
(ns backup-directory-dangerously
  (:require [babashka.cli :as cli]
            [babashka.fs :as fs]
            [babashka.process :as p]
            [clojure.java.io :as io]
            [clojure.string :as str]))

(defn abort []
  (println "Aborting backup")
  (System/exit 1))

(defn confirm [prompt]
  (print prompt "[y/N]: ")
  (flush)
  (when (not= "y" (-> (io/reader *in*) line-seq first))
    (abort)))

(defn print-help [spec]
  (println "backup-directory-dangerously <src> <dest>")
  (println (cli/format-opts {:spec spec :order [:source :dest]})))

(def spec {:source {:desc "An existing directory to backup."
                    :ref "<path>"}
           :dest {:desc "An existing directory or nonexistent path to backup to. If already existing, contents will be overwritten and lost forever."
                  :ref "<path>"}})

(when (= '("--help") *command-line-args*)
  (print-help spec)
  (System/exit 0))

(def cli-opts {:spec spec
               :args->opts [:source :dest]
               :require [:source :dest]
               :restrict [:source :dest]
               :validate {:source {:pred fs/directory?
                                   :ex-msg #(str "Must be existing directory: "
                                                 (-> % :value fs/canonicalize))}
                          :dest {:pred #(or (fs/directory? %) (not (fs/exists? %)))
                                 :ex-msg #(str "Must be existing directory or nonexistent path: "
                                               (-> % :value fs/canonicalize))}}
               :error-fn (fn [{:keys [_spec _type _cause msg _option]}]
                           (println "ERROR:" msg)
                           (println)
                           (print-help spec)
                           (System/exit 1))})

(def parsed-args (cli/parse-args *command-line-args* cli-opts))

(def source (-> parsed-args :opts :source fs/canonicalize str))
(def dest (-> parsed-args :opts :dest fs/canonicalize str))

(println "Source directory:" source)
(println "Destination directory:" dest)
(println)

(if (fs/directory? dest)
  (do (println "Destination directory exists and has these contents:")
    (-> (p/process ["ls" "-lahA" dest])
        (p/process ["head"])
        p/check
        :out
        slurp
        println)
    (confirm (str "Do you really want to overwrite " dest "?")))
  (println "Destination directory does not exist and will be created"))

(def rsync-command ["rsync" "--archive" "--verbose" "--human-readable" "--progress" "--one-file-system" "--delete" (str source "/") dest])

(println)
(println (str/join " " rsync-command))
(println)
(confirm "Does this command look good?")

(p/check (p/process rsync-command {:out :inherit :err :inherit}))
(println)
(println "Backup completed sucessfully")