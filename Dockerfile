# based on https://gist.github.com/theronic/084a1c24fef7eb2a89a711239116e54b

FROM clojure:tools-deps-bookworm-slim AS builder

WORKDIR /opt

COPY . .

RUN clj -Sdeps '{:mvn/local-repo "./.m2/repository"}' -T:build uber

FROM --platform=linux/amd64 eclipse-temurin:21 AS runtime
COPY --from=builder /opt/target/app-0.0.1-standalone.jar /app.jar

RUN apt update -y && \
    apt install -y unzip chromium-browser libnss3

RUN wget https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/120.0.6099.109/linux64/chromedriver-linux64.zip -P /tmp/ && \
    unzip /tmp/chromedriver-linux64.zip -d /usr/local/bin/ && \
    rm /tmp/chromedriver-linux64.zip && \
    chmod 755 /usr/local/bin/chromedriver-linux64 && \
    ln -s /usr/local/bin/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver

EXPOSE 8090

ENTRYPOINT ["java", "-cp", "app.jar", "clojure.main", "-m", "acme.app"]
