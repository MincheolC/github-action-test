(ns core
  (:gen-class :methods [^:static [handler [Object] Object]]))

(defn greeting []
  "hello world Github action")

(defn -handler[_]
  (prn (greeting)))