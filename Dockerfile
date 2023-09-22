#Build Stage
FROM ringcentral/maven:3.8.2-jdk17 as build
COPY . .
RUN mvn clean package -DskipTests
#Package
FROM eclipse-temurin:17-jdk-alpine
COPY --from=build target/MyAssist-0.0.1-SNAPSHOT.jar /opt/MyAssist.jar
EXPOSE 8080

# Set environment variables for Flyway
ENV FLYWAY_VERSION 8.5.6
ENV FLYWAY_HOME /flyway

# Install Flyway
RUN apk --no-cache add curl \
    && curl -LJO "https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}-linux-x64.tar.gz" \
    && tar -xzvf "flyway-commandline-${FLYWAY_VERSION}-linux-x64.tar.gz" \
    && rm "flyway-commandline-${FLYWAY_VERSION}-linux-x64.tar.gz" \
    && mv "flyway-${FLYWAY_VERSION}" "${FLYWAY_HOME}" \
    && apk del curl
# Copy your Flyway migration scripts to the container
COPY src/main/resources/db/migration /flyway/sql/
    

ENTRYPOINT ["java","-jar","/opt/MyAssist.jar"]
