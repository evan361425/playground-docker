FROM ghcr.io/lunarmodules/busted:v2 AS builder

RUN set -xe && \
        apk add --no-cache --virtual .build-deps \
            git \
            jq \
            gcc \
            g++ \
            libc-dev \
            make \
            cmake \
            readline-dev \
        && \
        apk add --no-cache \
            readline
RUN set -xe && \
        git clone --depth=1 --recurse-submodules https://github.com/Koihik/LuaFormatter.git /tmp/luaformatter \
        && cd /tmp/luaformatter \
        && mkdir build \
        && cd build \
        && cmake .. -DBUILD_TESTS=FALSE \
        && cmake --build . --target install

FROM ghcr.io/lunarmodules/busted:v2 AS final

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
          jq \
          libgcc \
          libstdc++

COPY --from=builder /usr/local/bin/lua-format /usr/local/bin/lua-format

COPY ./entrypoint.sh /internal/entrypoint.sh

WORKDIR /data

ENTRYPOINT ["sh", "/internal/entrypoint.sh"]
