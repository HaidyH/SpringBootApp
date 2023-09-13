FROM adoptopenjdk:11-jdk-hotspot
WORKDIR /app
COPY target/myapp.jar .
EXPOSE 8080
CMD ["java", "-jar", "myapp.jar"]