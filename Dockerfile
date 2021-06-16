FROM node:lts

WORKDIR /usr/src/app

COPY . /usr/src/app/

RUN yarn --cwd /usr/src/app/js/ install \
&& chmod +x /usr/src/app/js/deploy-web.sh \
&& (cd /usr/src/app/js/ ; sh deploy-web.sh)
 

EXPOSE 80

CMD ["node", "server.js"]
