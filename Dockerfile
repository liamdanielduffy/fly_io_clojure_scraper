FROM selenium/standalone-chrome:latest

# Switch to root user to install packages
USER root

# Install OpenJDK 21 & git
RUN apt-get update && \
    apt-get install -y openjdk-21-jre-headless git

# Install Clojure
RUN curl -L -O https://github.com/clojure/brew-install/releases/latest/download/linux-install.sh && \
    chmod +x linux-install.sh && \
    ./linux-install.sh


# Copy directory into /opt
WORKDIR /opt
COPY . .

# Build uberjar
RUN clojure -Sdeps '{:mvn/local-repo "./.m2/repository"}' -T:build uber

EXPOSE 8080

ENTRYPOINT ["java", "-cp", "app.jar", "clojure.main", "-m", "acme.app"]