# Étape 1 : Build de l'application Flutter Web
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Optimisation du cache des dépendances
COPY pubspec.yaml ./
RUN flutter pub get

# Copie du code et compilation en mode release pour le Web
COPY . .
RUN flutter build web --release

# Étape 2 : Serveur de production Nginx
FROM nginx:alpine

# Configuration Nginx optimisée pour Flutter SPA & Cloud Run
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Fichiers compilés Flutter
COPY --from=build /app/build/web /usr/share/nginx/html

# Port exposé pour Cloud Run (8080 par défaut)
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]