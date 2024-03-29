#!/usr/bin/env bb

(require '[babashka.process :as p])
(require '[cheshire.core :as json])
(require '[clojure.pprint :as pp])

(defmacro debug [sym] `(do (println ~(keyword sym)) (pp/pprint ~sym) (println)))

(defn get-editor-node []
  (letfn [(get-sway-tree []
            (-> (p/sh ["swaymsg" "-t" "get_tree"])
                :out
                (json/parse-string true)))
          (find-node [{:keys [nodes floating_nodes] :as node}]
            (if (= "config-editor" (:name node))
              node
              (some find-node (into nodes floating_nodes))))]
    (find-node (get-sway-tree))))

(defn set-editor-defaults []
  (p/sh ["swaymsg" "for_window [title=config-editor] floating enable; for_window [title=config-editor] resize set width 80 ppt height 90 ppt; for_window [title=config-editor] move position center"]))

(defn start-editor []
  (p/process ["swaymsg" "exec ~/.config/scripts/start-config-editor.sh"]))

(defn focus-editor []
  (p/sh ["swaymsg" "[title=config-editor] focus, move window to workspace current, floating enable, resize set width 80 ppt height 90 ppt, move position center"]))

(defn hide-editor []
  (p/sh ["swaymsg" "[title=config-editor] move scratchpad"]))

(set-editor-defaults)

(if-let [editor-node (get-editor-node)]
  (if (:focused editor-node)
    (hide-editor)
    (focus-editor))
  (start-editor))

