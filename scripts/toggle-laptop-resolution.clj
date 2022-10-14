#!/usr/bin/env bb

(ns cycle-sink
  (:require [babashka.process :as p]
            [cheshire.core :as json]
            [clojure.pprint :as pp]
            [clojure.string :as str]))

(defmacro debug [sym] `(do (println ~(keyword sym)) (pp/pprint ~sym) (println)))

(defn set-output-scale [output-name scale]
  (p/sh ["swaymsg" "output" output-name "scale" scale]))

(def outputs
  (-> (p/sh ["swaymsg" "-t" "get_outputs"])
      :out
      (json/parse-string true)))

(debug outputs)

(def laptop (some #(when (= "eDP-1" (:name %)) %) outputs))

(debug laptop)

(if (not= 1.5 (:scale laptop))
  (set-output-scale (:name laptop) 1.5)
  (set-output-scale (:name laptop) 1))

