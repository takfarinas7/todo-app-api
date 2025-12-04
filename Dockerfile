# ----------------------------------------------------------------------------------
# ÉTAPE 1: ÉTAPE DE BUILD (COMPILATION DE L'APPLICATION AVEC MAVEN)
# Utilisation de Java 25 pour le build
FROM maven:3-openjdk-25 AS build 

WORKDIR /app

# Copiez l'ensemble du contexte de build, incluant le pom.xml et src/
COPY . . 

# Exécutez la compilation
RUN mvn clean package -DskipTests
# ----------------------------------------------------------------------------------


# ----------------------------------------------------------------------------------
# ÉTAPE 2: ÉTAPE FINALE (EXÉCUTION DE L'APPLICATION)
# Utilisation d'un JRE minimaliste (alpine) avec Java 25 pour l'exécution
FROM eclipse-temurin:25-jre-alpine

RUN mkdir -p /data
VOLUME /data 

WORKDIR /app
EXPOSE 8080

# Changement du nom du JAR pour correspondre à la version 0.0.2-SNAPSHOT
COPY --from=build /app/target/todo-0.0.2-SNAPSHOT.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
# ----------------------------------------------------------------------------------