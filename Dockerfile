# ----------------------------------------------------------------------------------
# ÉTAPE 1: ÉTAPE DE BUILD (COMPILATION DE L'APPLICATION AVEC MAVEN)
# Passage à JDK 25 pour le build (Phase 3)
FROM maven:3.8.7-jdk-25 AS build

# CECI EST CRUCIAL : Définir le répertoire de travail
WORKDIR /app 

# SOLUTION CORRIGÉE : Copie tout en une fois et compile (plus robuste en CI/CD)
COPY . . 

# Compile et package l'application dans un fichier JAR.
RUN mvn clean package -DskipTests
# ----------------------------------------------------------------------------------


# ----------------------------------------------------------------------------------
# ÉTAPE 2: ÉTAPE FINALE (EXÉCUTION DE L'APPLICATION)
# Passage à JRE 25 pour l'exécution (Phase 3)
FROM eclipse-temurin:25-jre-alpine

# Déclare le point de montage pour le volume persistant (même si nous utilisons MariaDB externe, c'est une bonne pratique)
RUN mkdir -p /data
VOLUME /data 

WORKDIR /app

EXPOSE 8080

# Copie le fichier JAR compilé depuis l'étape de 'build'
COPY --from=build /app/target/*.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
# ----------------------------------------------------------------------------------