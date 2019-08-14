FROM golangci/golangci-lint:v1.17

ENV HOME /root

# add the wrapper which acts as a drone plugin
COPY plugin.sh /root/plugin.sh
ENTRYPOINT [ "/root/plugin.sh" ]
