(ns core
  (:gen-class :methods [^:static [handler [Object] Object]]))

(defn greeting []
  "hello world Github action Integration")

(defn -handler[_]
  (prn (greeting)))