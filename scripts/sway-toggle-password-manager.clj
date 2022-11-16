#!/usr/bin/env bb

(require '[babashka.process :as p])
(require '[cheshire.core :as json])
(require '[clojure.pprint :as pp])

(defmacro debug [sym] `(do (println ~(keyword sym)) (pp/pprint ~sym) (println)))

(def sway-tree
  (-> (p/sh ["swaymsg" "-t" "get_tree"])
      :out
      (json/parse-string true)))

(debug sway-tree)

;; (System/exit 0)

(defn get-focused-node [{:keys [nodes floating_nodes] :as node}]
  (if (:focused node)
    node
     (some get-focused-node (into nodes floating_nodes))))

(defn get-password-manager-node [{:keys [nodes floating_nodes] :as node}]
  (if (= (:app_id node) "org.keepassxc.KeePassXC")
    node
    (some get-password-manager-node (into nodes floating_nodes))))

(def focused-node (get-focused-node sway-tree))

(debug focused-node)

(def config-editor-node (get-password-manager-node sway-tree))

(debug config-editor-node)

(defn set-window-rules []
  (p/sh ["swaymsg" "for_window [app_id=\"org.keepassxc.KeePassXC\"] floating enable"])
  (p/sh ["swaymsg" "for_window [app_id=\"org.keepassxc.KeePassXC\"] resize set width 70 ppt height 90 ppt"])
  (p/sh ["swaymsg" "for_window [app_id=\"org.keepassxc.KeePassXC\"] move position center"]))

(defn focus-config-editor []
  (p/sh ["swaymsg" "[app_id=\"org.keepassxc.KeePassXC\"] move window to workspace current"])
  (p/sh ["swaymsg" "[app_id=\"org.keepassxc.KeePassXC\"] focus"]))

(defn hide-config-editor []
  (p/sh ["swaymsg" "[app_id=\"org.keepassxc.KeePassXC\"] move scratchpad"]))

(defn start-config-editor []
  (p/sh ["swaymsg" "exec keepassxc"]))

(set-window-rules)

(when-not config-editor-node
  (start-config-editor))

(if (:focused config-editor-node)
  (hide-config-editor)
  (focus-config-editor))
