FROM docker:stable

RUN mkdir -p /root/.docker
ENV HOME /root
ENV USER root
ENV DOCKER_CONFIG /root/.docker/

# add the wrapper which acts as a drone plugin
COPY plugin.sh /root/plugin.sh
ENTRYPOINT [ "/root/plugin.sh" ]
