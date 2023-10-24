#Build Stage
FROM ringcentral/maven:3.8.2-jdk17 as build
COPY . .
RUN mvn clean package -DskipTests
#Package
FROM eclipse-temurin:17-jdk-alpine
COPY --from=build target/MyAssist-0.0.1-SNAPSHOT.jar /opt/MyAssist.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/opt/Myassist.jar"]
