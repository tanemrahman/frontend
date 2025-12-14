FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./
RUN npm ci --only=production

# Copy application files
COPY server.js ./
# frontend/dist will be mounted via volume in docker-compose.yml

EXPOSE 3000

CMD ["node", "server.js"]

