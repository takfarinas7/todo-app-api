# ----------------------------------------------------------------------------------
# ÉTAPE 1: ÉTAPE DE BUILD (COMPILATION DE L'APPLICATION AVEC MAVEN)
FROM maven:3.8.7-jdk-21 AS build # Changé à JDK 21 (stable)

WORKDIR /app 
COPY . . 
RUN mvn clean package -DskipTests
# ----------------------------------------------------------------------------------


# ----------------------------------------------------------------------------------
# ÉTAPE 2: ÉTAPE FINALE (EXÉCUTION DE L'APPLICATION)
FROM eclipse-temurin:21-jre-alpine # Changé à JRE 21

RUN mkdir -p /data
VOLUME /data 

WORKDIR /app
EXPOSE 8080
COPY --from=build /app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
# ----------------------------------------------------------------------------------