# Stage 1: Build the application
FROM maven:3.8.5-openjdk-17 AS BUILD

WORKDIR /app
COPY . .

RUN mvn clean package -DskipTests

# Stage 2: Create a lightweight image
FROM openjdk:17.0.1-jdk-slim

WORKDIR /app
COPY --from=BUILD /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]