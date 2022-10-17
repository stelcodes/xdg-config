#!/usr/bin/env bb

(require '[babashka.process :as p])
(require '[cheshire.core :as json])
(require '[clojure.pprint :as pp])

(defmacro debug [sym] `(do (println ~(keyword sym)) (pp/pprint ~sym) (println)))

(defn set-output-scale [output scale]
  (p/sh ["swaymsg" "output" (:name output) "scale" scale]))

(def outputs
  (-> (p/sh ["swaymsg" "-t" "get_outputs"])
      :out
      (json/parse-string true)))

(debug outputs)

(def laptop (some #(when (= "eDP-1" (:name %)) %) outputs))

(debug laptop)

(if (not= 1.5 (:scale laptop))
  (set-output-scale laptop 1.5)
  (set-output-scale laptop 1))

