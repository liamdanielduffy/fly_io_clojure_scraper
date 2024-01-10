FROM clojure:tools-deps-bookworm-slim AS builder

WORKDIR /opt

COPY . .

RUN clojure -Sdeps '{:mvn/local-repo "./.m2/repository"}' -T:build uber

FROM eclipse-temurin:21-alpine AS runtime
COPY --from=builder /opt/target/app.jar /app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-cp", "app.jar", "clojure.main", "-m", "acme.app"]
