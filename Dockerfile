FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./
RUN npm ci --only=production

# Copy application files
COPY server.js ./
COPY frontend/dist ./frontend/dist

EXPOSE 3000

CMD ["node", "server.js"]

