# ----------------------------------------------------------------------------------
# ÉTAPE 1: DÉPLOIEMENT DU JAR PRÉ-COMPILÉ
# On utilise une image JRE simple. On n'a plus besoin de Maven ici.
FROM eclipse-temurin:21-jre-alpine
# Crée le répertoire où la DB sera stockée (pour K8s PVC)
RUN mkdir -p /data
VOLUME /data 

WORKDIR /app
EXPOSE 8080

# 🚨 C'EST LA CLÉ : On suppose qu'un fichier 'app.jar' a été créé avant le build Docker
# Le fichier 'app.jar' sera créé par l'étape Maven dans le build.yml
COPY target/todo-0.0.1-SNAPSHOT.jar app.jar 

ENTRYPOINT ["java", "-jar", "app.jar"]
# ----------------------------------------------------------------------------------