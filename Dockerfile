FROM arm64v8/golang:alpine3.13 AS builder

# Build Environment
RUN apk update
ADD ./loop /loop

# Install Loop
WORKDIR /loop/cmd
RUN go install ./...

FROM arm64v8/alpine:3.13 AS runner

RUN apk update
RUN apk add --no-cache tini
RUN apk add --no-cache coreutils
RUN apk add --no-cache curl
RUN apk add --no-cache bash

WORKDIR /

COPY --from=builder ./loop ./loop
COPY --from=builder ./go ./go
RUN chmod a+x /go/bin/loop
RUN chmod a+x /go/bin/loopd

# Import Entrypoint and give permissions
ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh
# ADD assets/utils/check-web.sh /usr/local/bin/check-web.sh
# RUN chmod +x /usr/local/bin/check-web.sh

EXPOSE 80 11010 8081

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
