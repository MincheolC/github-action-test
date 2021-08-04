(ns core-test
  (:require [clojure.test :refer [deftest testing run-tests is]]
            [core :as c]))

(deftest core
  (testing "greeting"
    (is (= "hello world" (c/greeting)))))

(run-tests)