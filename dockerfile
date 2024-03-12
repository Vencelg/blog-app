# Stage 1: Build the SvelteKit application
FROM node:16 AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Run the application
FROM node:16 AS runtime
WORKDIR /app
COPY --from=build /app/build ./build
COPY --from=build /app/package.json ./package.json
COPY --from=build /app/package-lock.json ./package-lock.json
RUN npm ci --production
EXPOSE 3000
CMD ["node", "build"]
