FROM ubuntu:18.04

# Update the repository sources list
RUN apt-get update

# Install and run apache
RUN apt-get install -y apache2 && apt-get clean
COPY ./index.html /var/www/html/
CMD apachectl -D FOREGROUND