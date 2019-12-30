FROM oracle/graalvm-ce:19.3.0-java8 as graalvm
#FROM oracle/graalvm-ce:19.3.0-java11 as graalvm # For JDK 11
COPY . /home/app/rofinewsgrabber
WORKDIR /home/app/rofinewsgrabber
RUN gu install native-image
RUN native-image --no-server --static -cp build/libs/rofinewsgrabber-*-all.jar

FROM frolvlad/alpine-glibc
EXPOSE 8080
COPY --from=graalvm /home/app/rofinewsgrabber/rofinewsgrabber /app/rofinewsgrabber
ENTRYPOINT ["/app/rofinewsgrabber", "-Djava.library.path=/app"]
