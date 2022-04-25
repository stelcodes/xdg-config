#! /usr/bin/env bb
(ns main
  (:require [clojure.string :as str]
            [clojure.java.shell :as shell]))

(defn filenames []
  (let [n (-> (shell/sh "find" "." "-type" "d")
              :out
              (str/split #"\n"))]
    (->> n
     rest
     (map #(subs % 2)))))

(comment (filenames)
         )

(defn maybe-str-int [s]
  (try
    (Integer/parseInt s)
    (catch Exception _ nil)))

(defn get-movies []
  (for [filename (filenames)
        :let [tokens (str/split filename #"-")]]
    (if-let [year (maybe-str-int (last tokens))]
      {:title (->> (butlast tokens) (map str/capitalize) (str/join " "))
       :year (when (and (> year 1800) (< year 2100)) year)}
      {:title (->> tokens (map str/capitalize) (str/join " "))})))

(defn movie-str [{:keys [title year]}]
  (str title (when year (str " (" year ")"))))

(defn movies-by-decade []
  (let [a (->> (get-movies)
               (filter :year)
               (group-by #(Math/floor (/ (:year %) 10))))
        b (-> a
              (update-keys #(-> % int (str "0's")))
              (update-vals #(->> % (sort-by :year) (map movie-str))))]
    (->> (vec b)
         (sort-by first))))

(doseq [[decade movies] (movies-by-decade)]
  (println)
  (println decade)
  (println "====================================")
  (println (str/join "\n" movies)))
