FROM ubuntu:14.04

RUN apt-get update && apt-get install ruby libapr1-dev -y
ADD https://github.com/geofffranks/spruce/releases/download/v1.6.0/spruce-linux-amd64 /usr/local/bin/spruce
ADD https://cli.run.pivotal.io/stable?release=linux64-binary&source=github /tmp/cf-cli.tgz
RUN tar -xvzf /tmp/cf-cli.tgz -C /usr/local/bin/
RUN chmod 755 /usr/local/bin/spruce /usr/local/bin/cf
ADD https://packages.chef.io/stable/ubuntu/12.04/chefdk_0.16.28-1_amd64.deb /tmp/chefdk.deb
RUN dpkg -i /tmp/chefdk.deb
RUN mkdir .chef
RUN echo "log_level     :info"  >> .chef/knife.rb
RUN echo "log_location  STDOUT" >> .chef/knife.rb

# Install Go
RUN \
  mkdir -p /goroot && \
  curl https://storage.googleapis.com/golang/go1.6.3.linux-amd64.tar.gz | tar xvzf - -C /goroot --strip-components=1

# Set environment variables.
ENV GOROOT /goroot
ENV GOPATH /gopath
ENV PATH $GOROOT/bin:$GOPATH/bin:$PATH