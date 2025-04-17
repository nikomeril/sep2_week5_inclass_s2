FROM openjdk:17
COPY ./src /
WORKDIR /
RUN javac App.java
CMD ["java", "App"]
