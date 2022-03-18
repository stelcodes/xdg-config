(require '[clojure.java.io :as io])
(require '[clojure.string :as str])
(require '[clojure.pprint :refer [pprint]])

;; Example filename: 'SpongeBob SquarePants S01E01A Help Wanted.mkv'
;;                   'SpongeBob SquarePants S02E01 Something Smells.mkv'

(defn create-new-filename [filename]
  (let [title (-> (subs filename 35 (- (count filename) 29))
                  str/lower-case
                  (str/replace #" " "-")
                  (str/replace #"(!|'|,|\)|\(|\.)" ""))
        season (subs filename 27 29)
        episode (str/lower-case (subs filename 30 32))]
    (str "king-of-the-hill-s" season "-ep" episode "-" title ".mkv")))

(defn file-to-filedata [file]
  (let [filename (.getName file)]
    {:new-file (try
                 (io/file (str "./" (create-new-filename filename)))
                 (catch Exception e nil))
     :old-file file}))

(def file-data
  (->> (io/file ".")
       .listFiles
       (filter #(re-find #"\.mkv" (.getName %)))
       (map file-to-filedata)
       (sort-by :old-file)))

(defn print-filenames [{:keys [old-file new-file]}]
  (println "OLD:" (pr-str (.getName old-file)))
  (println "NEW:" (when new-file (pr-str (.getName new-file)))))

(doseq [file-datum file-data]
  (println)
  (print-filenames file-datum))

(println "============================================================")

(doseq [{:keys [old-file new-file] :as file-datum} file-data]
  (let [rename? (do (print-filenames file-datum)
                  (println "Rename this file? (y/n): ")
                  (= (first (line-seq (clojure.java.io/reader *in*))) "y"))]
    (if (and rename? new-file)
      (do
        (.renameTo old-file new-file)
        (println "File renamed!"))
      (println "File skipped."))))

