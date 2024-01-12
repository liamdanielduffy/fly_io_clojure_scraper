(ns acme.app
  (:require [org.httpkit.server :as server]
            [etaoin.api :as e])
  (:gen-class))

(def driver (e/chrome {:args ["--no-sandbox" "--disable-dev-shm-usage" "--disable-gpu" "--headless" "--disable-software-rasterizer" "--disable-setuid-sandbox"]}))

(def port (or (some-> (System/getenv "PORT")
                      parse-long)
              8080))

(defn -main [& _args]
  (server/run-server
   (fn [_req]
     {:body
      (do
        (driver (e/go driver "https://en.wikipedia.org/"))
        (e/get-url driver))})
   {:port port})
  (println "Site running on" (str "http://localhost:" port)))

