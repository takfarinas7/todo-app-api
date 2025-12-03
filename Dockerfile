# ----------------------------------------------------------------------------------
# UTILISATION DU LISTING 1 ADAPTÉ
# ----------------------------------------------------------------------------------
# Utiliser une image de base pour le build Maven
FROM maven:3.8.7-jdk-21 AS build 
WORKDIR /app 

# Correction: Copie tout et compile
COPY . . 
# vos commandes de build ici
RUN mvn clean package -DskipTests
# ----------------------------------------------------------------------------------


# Image finale pour l’excution
FROM eclipse-temurin:21-jre-alpine

# Déclare le point de montage pour la persistance H2
RUN mkdir -p /data
VOLUME /data 
WORKDIR /app
EXPOSE 8080

# vos commandes d’execution ici
COPY --from=build /app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
# ----------------------------------------------------------------------------------