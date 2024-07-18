# cosmo-jobprotal-casestudy
Case Study for the Job Portal.
Creating a Docker setup for a job portal application using Laravel (backend) and React.js (frontend) involves creating Dockerfiles and a docker-compose.yml file to manage the services. Here’s a step-by-step guide:

![image](https://github.com/user-attachments/assets/c884ab95-87f2-44b1-9b3a-a78a94eb3021)

2. Dockerfile for Laravel (backend/Dockerfile)
dockerfile

# Use an official PHP runtime as a parent image
FROM php:8.1-fpm

# Set working directory
WORKDIR /var/www

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy existing application directory contents
COPY . /var/www

# Copy existing application directory permissions
COPY --chown=www-data:www-data . /var/www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
3. Dockerfile for React.js (frontend/Dockerfile)
dockerfile
Copy code
# Use an official Node.js runtime as a parent image
FROM node:16

# Set working directory
WORKDIR /usr/src/app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the app
RUN npm run build

# Expose the port the app runs on
EXPOSE 3000

# Start the app
CMD ["npm", "start"]
4. docker-compose.yml
yaml

version: '3.8'

services:
  # Laravel Service
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    image: job-portal-backend
    container_name: job-portal-backend
    restart: unless-stopped
    tty: true
    environment:
      SERVICE_NAME: backend
      SERVICE_TAGS: dev
    working_dir: /var/www
    volumes:
      - ./backend:/var/www
      - ./backend/vendor:/var/www/vendor
    networks:
      - app-network
    depends_on:
      - db

  # React.js Service
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    image: job-portal-frontend
    container_name: job-portal-frontend
    restart: unless-stopped
    tty: true
    environment:
      - CHOKIDAR_USEPOLLING=true
    volumes:
      - ./frontend:/usr/src/app
      - /usr/src/app/node_modules
    ports:
      - "3000:3000"
    networks:
      - app-network

  # Database Service
  db:
    image: mysql:5.7
    container_name
: job-portal-db
restart: unless-stopped
environment:
MYSQL_DATABASE: job_portal
MYSQL_ROOT_PASSWORD: rootpassword
MYSQL_USER: jobuser
MYSQL_PASSWORD: jobpassword
volumes:
- db-data:/var/lib/mysql
ports:
- "3306:3306"
networks:
- app-network

volumes:
db-data:

networks:
app-network:
driver: bridge

bash

### 5. Steps to Setup and Run

1. **Create Project Directory**:
   Make sure you have the directory structure as outlined above.

2. **Laravel Project Setup**:
   Inside the `backend` directory, set up your Laravel project (if not already done):
   ```sh
   cd backend
   composer create-project --prefer-dist laravel/laravel .
React Project Setup:
Inside the frontend directory, set up your React project (if not already done):

sh

cd frontend
npx create-react-app .
Update Environment Variables:

Create a .env file in the backend directory and set the database connection details:

DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=job_portal
DB_USERNAME=jobuser
DB_PASSWORD=jobpassword
Build and Run Containers:
From the root directory of your project, run:

sh

docker-compose up --build
Accessing the Application:

The Laravel backend will be accessible at http://localhost:9000
The React frontend will be accessible at http://localhost:3000
This setup provides a clear separation of concerns with a dedicated service for the backend, frontend, and database. The Docker containers ensure consistent development and deployment environments.
