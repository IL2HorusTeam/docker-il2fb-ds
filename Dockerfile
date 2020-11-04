ARG IL2DS_UID=21000
ARG IL2DS_GID=21000


FROM il2horusteam/wine:5.0 AS base

ARG IL2DS_UID
ARG IL2DS_GID

ENV WINEPREFIX="/home/il2ds/.wine32"
ENV WINEDEBUG="-all"

ENV IL2DS_CONF="/il2ds/conf/confs.ini"
ENV IL2DS_INIT="/il2ds/scripts/init.cmd"

LABEL org.opencontainers.image.title="IL-2 FB DS"
LABEL org.opencontainers.image.ref.name="il2horusteam/il2ds"
LABEL org.opencontainers.image.url="https://hub.docker.com/r/il2horusteam/il2ds"
LABEL org.opencontainers.image.description="Dedicated server of «IL-2 Sturmovik: Forgotten Battles» flight simulator"
LABEL org.opencontainers.image.authors="Oleksandr Oblovatnyi <oblovatniy@gmail.com>"

RUN groupadd -g $IL2DS_GID il2ds \
 && useradd \
      --system \
      -u $IL2DS_UID \
      -g $IL2DS_GID \
      -G wine \
      --shell /sbin/nologin \
      --create-home --home-dir /home/il2ds \
      il2ds \
 && rm -rf /home/wine/.wine32 \
 && su -s /bin/bash -c "wineboot --init && winetricks d3dx9" il2ds \
 && mkdir /il2ds \
 && chown il2ds:il2ds /il2ds

VOLUME [ \
  "/il2ds/conf/", \
  "/il2ds/logs/", \
  "/il2ds/scripts/", \
  "/il2ds/Missions/Net/" \
]

EXPOSE 21000/udp 20000/tcp 10000/udp


FROM alpine AS download-2.04
RUN wget https://github.com/IL2HorusTeam/il2fb-ds-patches/releases/download/2.04/server-2.04.zip \
 && mkdir /il2ds \
 && unzip server-2.04.zip -d /il2ds


FROM alpine AS build

ARG IL2DS_UID
ARG IL2DS_GID

COPY --from=download-2.04 --chown=$IL2DS_UID:$IL2DS_GID /il2ds /il2ds

RUN rm -f /il2ds/confc.ini /il2ds/confs.ini /il2ds/gc.cmd /il2ds/server.cmd \
 && mkdir /il2ds/logs /il2ds/conf /il2ds/scripts

COPY conf/*    /il2ds/conf/
COPY scripts/* /il2ds/scripts/

RUN chown -R $IL2DS_UID:$IL2DS_GID /il2ds


FROM base

LABEL org.opencontainers.image.version="2.04"
LABEL org.opencontainers.image.source="https://github.com/IL2HorusTeam/il2fb-ds-docker/tree/2.04/"

COPY --from=build --chown=il2ds:il2ds /il2ds /il2ds

USER il2ds

WORKDIR /il2ds

CMD [ \
  "sh", "-c", \
  "/usr/bin/wine /il2ds/il2server.exe -conf \"$IL2DS_CONF\" -cmd \"$IL2DS_INIT\"" \
]
