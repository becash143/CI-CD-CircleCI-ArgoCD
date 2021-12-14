FROM openjdk:11-jdk
MAINTAINER bikash.bhandari1986@gmail.com
ARG code_version
ENV VERSION $code_version
ARG db_name
ENV db_name $db_name
RUN useradd -ms /bin/bash myapp
USER myapp
WORKDIR /usr/src/myapp

COPY ./target/assignment-$VERSION.jar /usr/src/myapp/
CMD java -jar -Dspring.profiles.active=$db_name assignment-$VERSION.jar
