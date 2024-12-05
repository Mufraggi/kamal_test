# Étape 1 : Build
FROM node:20-alpine AS builder

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers nécessaires pour l'installation
COPY package.json yarn.lock ./

# Installer les dépendances
RUN yarn install --frozen-lockfile

# Copier le reste des fichiers de l'application
COPY . .

# Construire l'application avec Vite
RUN yarn build

# Étape 2 : Runtime
FROM nginx:stable-alpine

# Copier les fichiers construits vers Nginx
COPY --from=builder /app/dist /usr/share/nginx/html

# Exposer le port 80
EXPOSE 80

# Commande par défaut pour démarrer Nginx
CMD ["nginx", "-g", "daemon off;"]
