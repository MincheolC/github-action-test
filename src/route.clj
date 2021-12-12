(ns route
  (:require [ring.adapter.jetty :refer [run-jetty]]
            [ring.middleware.reload :refer [wrap-reload]]
            [ring.util.response :refer [response]]
            [reitit.ring :refer [router ring-handler]]
            [reitit.ring.middleware.muuntaja :as muuntaja]
            [reitit.ring.middleware.parameters :as params]
            [muuntaja.core :as m]
            [db]))

(defn pong [_]
  (response "poong"))

(defn get-user [req]
  (let [id (get-in req [:path-params :id])
        #_#_user (db/get-user-by-id (get-db-conn) id)]
    {:status 200
     :body id}))

(defn app
  [config]
  (ring-handler
    (router
      ["/api"
       ["/ping" {:get pong}]
       ["/users/:id" {:get get-user}]]
      {:data {:config config
              :muuntaja m/instance
              :middleware [;; query-params & form-params
                           params/parameters-middleware
                           ;; content-negotiation & encoding, decoding req body
                           muuntaja/format-middleware]}})
    nil
    {:middleware [wrap-reload]}))
