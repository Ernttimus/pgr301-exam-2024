FROM maven:3.8.7-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

FROM amazoncorretto:17-alpine AS runtime
WORKDIR /app
COPY --from=build /app/target/imagegenerator-0.0.1-SNAPSHOT.jar app.jar

ENV SQS_QUEUE_URL=""

ENTRYPOINT ["java", "-jar", "app.jar"]
CMD ["\"Enter your message prompt here\""]
