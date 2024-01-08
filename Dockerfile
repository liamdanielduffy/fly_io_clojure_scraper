# based on https://gist.github.com/theronic/084a1c24fef7eb2a89a711239116e54b

FROM clojure:tools-deps-bookworm-slim AS builder

WORKDIR /opt

COPY . .

RUN clj -Sdeps '{:mvn/local-repo "./.m2/repository"}' -T:build uber

FROM eclipse-temurin:21-alpine AS runtime
COPY --from=builder /opt/target/app-0.0.1-standalone.jar /app.jar

EXPOSE 8090

ENTRYPOINT ["java", "-cp", "app.jar", "clojure.main", "-m", "acme.app"]
