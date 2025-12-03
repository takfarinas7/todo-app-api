# ----------------------------------------------------------------------------------
# ÉTAPE 1: BUILD (COMPILATION)
# Utilise l'image fournie par l'énoncé pour compiler le code Java avec Maven.
FROM maven:3.8.7-jdk-17 AS build

# Crée le répertoire de travail
WORKDIR /app

# Copie le pom.xml pour gérer les dépendances Maven
COPY pom.xml .
RUN mvn dependency:go-offline

# Copie le code source de l'application
COPY src ./src

# Compile le code et crée le fichier JAR final dans le dossier target/
RUN mvn clean package -DskipTests
# ----------------------------------------------------------------------------------


# ----------------------------------------------------------------------------------
# ÉTAPE 2: RUN (EXÉCUTION)
# Utilise une image JRE plus petite et plus légère pour lancer l'application.
FROM eclipse-temurin:17-jre-alpine

# Crée et déclare le répertoire /data pour le PVC Kubernetes
# Ceci est essentiel pour la Phase 2 du laboratoire.
RUN mkdir -p /data
VOLUME /data

# Définit le port sur lequel l'application écoute
EXPOSE 8080

# Copie le fichier JAR compilé depuis l'étape 'build'
COPY --from=build /app/target/*.jar app.jar

# Définit le point d'entrée pour l'exécution du JAR
ENTRYPOINT ["java", "-jar", "app.jar"]
# ----------------------------------------------------------------------------------