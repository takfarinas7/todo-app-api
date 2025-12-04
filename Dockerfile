# ----------------------------------------------------------------------------------
# ÉTAPE 1: ÉTAPE DE BUILD (COMPILATION DE L'APPLICATION AVEC MAVEN)
FROM maven:3-openjdk-17 AS build
WORKDIR /app 
COPY . . 
RUN mvn clean package -DskipTests
# ----------------------------------------------------------------------------------


# ----------------------------------------------------------------------------------
# ÉTAPE 2: ÉTAPE FINALE (EXÉCUTION DE L'APPLICATION)
FROM eclipse-temurin:17-jre-alpine

RUN mkdir -p /data
VOLUME /data 

WORKDIR /app
EXPOSE 8080

COPY --from=build /app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
# ----------------------------------------------------------------------------------