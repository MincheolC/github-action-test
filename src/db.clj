(ns db
  (:require [honey.sql :as sql]
            [next.jdbc :as jdbc]))

(defn execute-one! [db q]
  (let [qs (sql/format q {:dialect :mysql})]
    (jdbc/execute-one! db qs jdbc/unqualified-snake-kebab-opts)))

(defn execute! [db q]
  (let [qs (sql/format q {:dialect :mysql})]
    (jdbc/execute! db qs jdbc/unqualified-snake-kebab-opts)))

(defn get-user-by-id [db id]
  (execute-one! db {:select [:*]
                    :from   :users
                    :where  [:= :id id]}))
