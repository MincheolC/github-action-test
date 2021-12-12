# https://medium.com/@diogok/efficient-clojure-multistage-docker-images-with-java-and-native-image-c7c80b93c8
FROM clojure:openjdk-11-tools-deps-slim-buster as builder

WORKDIR /usr/src/app

# install cambada builder, as it will not change
RUN clojure -Sdeps '{:deps {luchiniatwork/cambada {:mvn/version "1.0.2"}}}' -e :ok

# install main deps, sometimes change
COPY deps.edn /usr/src/app/deps.edn
RUN clojure -e :ok

# add files and build, change often
COPY src/ /usr/src/app/src
COPY resources/ /usr/src/app/resources
RUN clojure -A:uberjar

# use clean base image
FROM openjdk:11-slim-buster

# set static config
ENV PORT 8080
EXPOSE 8080

# set the command, with proper container support
CMD ["bash", "-c", "java -XX:+UseContainerSupport -XX:MaxRAMPercentage=85 -javaagent:/usr/src/app/datadog/dd-java-agent.jar -Ddd.service=sinsun-market -Ddd.logs.injection=true -Ddd.agent.host=${DD_AGENT_HOST} -jar /usr/src/app/app.jar"]

# copy the ever changing artifact
COPY --from=builder /usr/src/app/target/app-1.0.0-SNAPSHOT-standalone.jar /usr/src/app/app.jar
