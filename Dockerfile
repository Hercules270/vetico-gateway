# Build stage
FROM eclipse-temurin:21-jdk-jammy AS builder

# Set working directory
WORKDIR /app

# Copy gradle files first to leverage Docker cache
COPY gradle/ gradle/
COPY gradlew build.gradle settings.gradle ./

# Give execute permissions to gradlew
RUN chmod +x gradlew

# Download dependencies
RUN ./gradlew dependencies

# Copy source code
COPY src/ src/

# Build the application
RUN ./gradlew build -x test

# Runtime stage
FROM eclipse-temurin:21-jre-jammy

WORKDIR /app

# Copy the built jar from builder stage
COPY --from=builder /app/build/libs/*.jar app.jar

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "app.jar"]