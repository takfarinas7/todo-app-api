# ----------------------------------------------------------------------------------
# ÉTAPE 1: ÉTAPE DE BUILD (COMPILATION DE L'APPLICATION AVEC MAVEN)
# Utilisation de Java 25 pour le build
FROM maven:3-openjdk-25 AS build 

WORKDIR /app

# Copiez le pom.xml en premier pour la mise en cache
COPY pom.xml . 
# Copiez ensuite le reste du code source
COPY src ./src 

# Exécutez la compilation
RUN mvn clean package -DskipTests

# ----------------------------------------------------------------------------------
# ÉTAPE 2: RUNTIME (Environnement d'exécution minimal)
# Utilisation d'un JRE minimaliste (alpine) avec Java 25 pour l'exécution
FROM eclipse-temurin:25-jre-alpine 

# Crée un répertoire de données vide
RUN mkdir -p /data 

# Définit le répertoire de travail
WORKDIR /app

# Définissez le nom du JAR compilé 
ARG JAR_FILE=target/todo-app-api-0.0.2-SNAPSHOT.jar 
# REMARQUE : Assurez-vous que ce nom de fichier correspond au JAR généré par Maven
COPY --from=build ${JAR_FILE} app.jar

# Configuration du port
EXPOSE 8080 

# Définit la commande d'exécution
ENTRYPOINT ["java", "-jar", "app.jar"]