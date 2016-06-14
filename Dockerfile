FROM node:6.2.1-slim

RUN apt-get update \
    && apt-get install -y git-core
RUN npm install -g elm@0.17.0

COPY elm-package.json elm-package.json
RUN elm package install --yes

COPY *.elm ./
COPY images/* images/
RUN elm make --output ubjer.js Main.elm CollisionExample.elm MiniCat.elm MegaCat.elm

EXPOSE 8000
CMD ["elm", "reactor", "--address", "0.0.0.0"]
