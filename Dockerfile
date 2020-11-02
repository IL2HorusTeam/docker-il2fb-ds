FROM alpine AS build

RUN wget https://github.com/IL2HorusTeam/il2fb-ds-patches/releases/download/2.04/server-2.04.zip \
 && mkdir /il2ds \
 && unzip server-2.04.zip -d /il2ds \
 && mkdir /il2ds/logs \
 && mkdir /il2ds/conf \
 && mkdir /il2ds/scripts

COPY conf/*    /il2ds/conf/
COPY scripts/* /il2ds/scripts/


FROM il2horusteam/wine:5.0

ARG IL2DSUID=21000
ARG IL2DSGID=21000

ENV IL2DSHOME="/il2ds"
ENV WINEPREFIX="$IL2DSHOME/.wine32"
ENV WINEDEBUG="-all"

LABEL org.opencontainers.image.version="2.04"
LABEL org.opencontainers.image.source="https://github.com/IL2HorusTeam/il2fb-ds-docker/tree/2.04/"
LABEL org.opencontainers.image.title="IL-2 FB DS"
LABEL org.opencontainers.image.ref.name="il2horusteam/il2ds"
LABEL org.opencontainers.image.url="https://hub.docker.com/r/il2horusteam/il2ds"
LABEL org.opencontainers.image.description="Dedicated server of «IL-2 Sturmovik: Forgotten Battles» flight simulator"
LABEL org.opencontainers.image.authors="Oleksandr Oblovatnyi <oblovatniy@gmail.com>"

COPY --from=build /il2ds "$IL2DSHOME"

RUN groupadd -g $IL2DSGID il2ds \
 && useradd \
      --system \
      -u $IL2DSUID \
      -g $IL2DSGID \
      -G wine \
      --shell /sbin/nologin \
      --home-dir "$IL2DSHOME" \
      il2ds \
 && rm -rf /home/wine/.wine32 \
 && wineboot --init \
 && winetricks d3dx9 corefonts \
 && chown -R il2ds:il2ds "$IL2DSHOME"

VOLUME [ \
  "$IL2DSHOME/conf/", \
  "$IL2DSHOME/logs/", \
  "$IL2DSHOME/scripts/", \
  "$IL2DSHOME/Missions/Net/" \
]

EXPOSE 21000/udp 20000/tcp 10000/udp

USER il2ds

WORKDIR "$IL2DSHOME"

CMD [ \
  "sh", "-c", \
  "/usr/bin/wine \"$IL2DSHOME/il2server.exe\" -conf \"$IL2DSHOME/conf/confs.ini\" -cmd \"$IL2DSHOME/scripts/init.cmd\"" \
]
