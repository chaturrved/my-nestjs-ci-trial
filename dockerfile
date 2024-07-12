# Stage 1: Build the application
FROM node:20-alpine AS builder

# Create and change to the app directory.
WORKDIR /usr/src/app

# Copy package.json and pnpm-lock.yaml
COPY pnpm-lock.yaml package.json ./
# Install app dependencies using PNPM
RUN npm install -g pnpm

#Install dependencies
RUN pnpm install

# Copy the application source code.
COPY . .

# Build the application
RUN pnpm run build

# Stage 2: Run the application
FROM node:20-alpine

WORKDIR /usr/src/app

# Copy built application from the builder stage
COPY --from=builder /usr/src/app/dist ./dist
COPY package*.json ./

#Install pnpm and prod dependencies
RUN npm install -g pnpm
RUN pnpm install --only=production

EXPOSE 3000

# Command to run the application
CMD ["node", "dist/main"]
