FROM arm64v8/golang:alpine3.13 AS builder

# Build Environment
RUN apk update
RUN apk add --no-cache yarn
ADD ./lightning-terminal /lightning-terminal

# Install lightning-terminal
WORKDIR /lightning-terminal
RUN make install

FROM arm64v8/node:16-alpine3.11 AS runner

RUN apk update
RUN apk add --no-cache tini
RUN apk add --no-cache coreutils
RUN apk add --no-cache curl
RUN apk add --no-cache bash

WORKDIR /

COPY --from=builder ./lightning-terminal ./lightning-terminal
COPY --from=builder ./go ./go
RUN chmod a+x /go/bin/lightning-terminal
RUN chmod a+x /go/bin/lightning-terminald

# Import Entrypoint and give permissions
ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh
ADD assets/utils/check-web.sh /usr/local/bin/check-web.sh
RUN chmod +x /usr/local/bin/check-web.sh

EXPOSE 80 8443

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
