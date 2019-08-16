FROM node:10

LABEL "com.github.actions.name"="GitHub Action for Firebase CLI"
LABEL "com.github.actions.description"="Deploy to Firebase Hosting, Cloud Functions, and more using the Firebase CLI"
LABEL "com.github.actions.icon"="upload-cloud"
LABEL "com.github.actions.color"="yellow"

RUN npm install -g firebase-tools
# add the wrapper which acts as a drone plugin

COPY plugin.sh /root/plugin.sh
ENTRYPOINT [ "/root/plugin.sh" ]
