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

# Set appropriate permissions
RUN chown -R www-data:www-data /usr/src/app

# Start the app
CMD ["npm", "start"]