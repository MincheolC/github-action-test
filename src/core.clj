(ns core
  (:gen-class :methods [^:static [handler [Object] Object]]))

(defn greeting []
  "hello world")

(defn -handler[_]
  (prn (greeting)))