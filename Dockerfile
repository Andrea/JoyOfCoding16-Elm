FROM haskell:7.10.3


RUN apt-get update \
    && apt-get install -y git-core

COPY BuildFromSource.hs /BuildFromSource.hs
ENV PATH /Elm-Platform/0.17/.cabal-sandbox/bin:$PATH
RUN runhaskell BuildFromSource.hs 0.17

RUN cd /Elm-Platform/0.17/ \
    && git clone https://github.com/elm-lang/elm-lang.org.git \
    && cd elm-lang.org \
    && git checkout master \
    && cabal sandbox init --sandbox ../.cabal-sandbox \
    && cabal install --only-dependencies \
    && cabal configure \
    && cabal build

COPY elm-package.json /Elm-Platform/0.17/elm-lang.org/elm-package.json
COPY elm-package.json /Elm-Platform/0.17/elm-lang.org/tmp/elm-package.json
RUN cd /Elm-Platform/0.17/elm-lang.org \
    && elm package install -y \
    && rm -vr src/examples/* \
    && rm -vr src/pages/* \
    && cd tmp \
    && elm package install -y

COPY assets/* /Elm-Platform/0.17/elm-lang.org/assets/ 
COPY *.elm /Elm-Platform/0.17/elm-lang.org/src/shared/
COPY 0*/*.elm /Elm-Platform/0.17/elm-lang.org/src/examples/
COPY *.elm /Elm-Platform/0.17/elm-lang.org/src/examples/
RUN cd /Elm-Platform/0.17/elm-lang.org \
    && elm make --output examples.js src/examples/*.elm src/shared/*.elm

COPY pages/*.elm /Elm-Platform/0.17/elm-lang.org/src/pages/

EXPOSE 8000
WORKDIR /Elm-Platform/0.17/elm-lang.org
CMD ["./dist/build/run-elm-website/run-elm-website"]
