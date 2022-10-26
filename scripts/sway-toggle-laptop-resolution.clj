#!/usr/bin/env bb

(require '[babashka.process :as p])
(require '[cheshire.core :as json])
(require '[clojure.pprint :as pp])

(defmacro debug [sym] `(do (println ~(keyword sym)) (pp/pprint ~sym) (println)))

(defn set-output-scale [output scale pos-x]
  (p/sh ["swaymsg" "output" (:name output) "scale" scale "pos" (int pos-x) "0"]))

(def outputs
  (-> (p/sh ["swaymsg" "-t" "get_outputs"])
      :out
      (json/parse-string true)))

(debug outputs)

(def laptop (some #(when (= "eDP-1" (:name %)) %) outputs))
(def laptop-width (-> laptop :current_mode :width))

(debug laptop)

(if (not= 1.5 (:scale laptop))
  (set-output-scale laptop 1.5 (- laptop-width (/ laptop-width 1.5)))
  (set-output-scale laptop 1 0))

