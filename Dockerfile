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
RUN wget -O server.zip https://github.com/IL2HorusTeam/il2fb-ds-patches/releases/download/2.04/server-2.04.zip \
 && mkdir /il2ds \
 && unzip server.zip -d /il2ds \
 && rm -f server.zip


FROM alpine AS download-3.03
RUN wget -O patch.zip https://github.com/IL2HorusTeam/il2fb-ds-patches/releases/download/3.03/server-3.03.zip \
 && mkdir /il2ds \
 && unzip patch.zip -d /il2ds \
 && rm -f patch.zip


FROM alpine AS download-3.04
RUN wget -O patch.zip https://github.com/IL2HorusTeam/il2fb-ds-patches/releases/download/3.04/server-3.04.zip \
 && mkdir /il2ds \
 && unzip patch.zip -d /il2ds \
 && rm -f patch.zip


FROM alpine AS download-4.01
RUN wget -O patch.zip https://github.com/IL2HorusTeam/il2fb-ds-patches/releases/download/4.01/server-4.01.zip \
 && mkdir /il2ds \
 && unzip patch.zip -d /il2ds \
 && rm -f patch.zip


FROM alpine AS download-4.02
RUN wget -O patch.zip https://github.com/IL2HorusTeam/il2fb-ds-patches/releases/download/4.02/server-4.02.zip \
 && mkdir /il2ds \
 && unzip patch.zip -d /il2ds \
 && rm -f patch.zip


FROM alpine AS download-4.03
RUN wget -O patch.zip https://github.com/IL2HorusTeam/il2fb-ds-patches/releases/download/4.03/server-4.03.zip \
 && mkdir /il2ds \
 && unzip patch.zip -d /il2ds \
 && rm -f patch.zip


FROM alpine AS download-4.04
RUN wget -O patch.zip https://github.com/IL2HorusTeam/il2fb-ds-patches/releases/download/4.04/server-4.04.zip \
 && mkdir /il2ds \
 && unzip patch.zip -d /il2ds \
 && rm -f patch.zip


FROM alpine AS download-4.05
RUN wget -O patch.zip https://github.com/IL2HorusTeam/il2fb-ds-patches/releases/download/4.05/server-4.05.zip \
 && mkdir /il2ds \
 && unzip patch.zip -d /il2ds \
 && rm -f patch.zip


FROM alpine AS download-4.06
RUN wget -O patch.zip https://github.com/IL2HorusTeam/il2fb-ds-patches/releases/download/4.06/server-4.06.zip \
 && mkdir /il2ds \
 && unzip patch.zip -d /il2ds \
 && rm -f patch.zip


FROM alpine AS download-4.07
RUN wget -O patch.zip https://github.com/IL2HorusTeam/il2fb-ds-patches/releases/download/4.07/server-4.07.zip \
 && mkdir /il2ds \
 && unzip patch.zip -d /il2ds \
 && rm -f patch.zip


FROM alpine AS download-4.08
RUN wget -O patch.zip https://github.com/IL2HorusTeam/il2fb-ds-patches/releases/download/4.08/server-4.08.zip \
 && mkdir /il2ds \
 && unzip patch.zip -d /il2ds \
 && rm -f patch.zip


FROM alpine AS download-4.09
RUN wget -O patch.zip https://github.com/IL2HorusTeam/il2fb-ds-patches/releases/download/4.09/server-4.09.zip \
 && mkdir /il2ds \
 && unzip patch.zip -d /il2ds \
 && rm -f patch.zip


FROM alpine AS download-4.10
RUN wget -O patch.zip https://github.com/IL2HorusTeam/il2fb-ds-patches/releases/download/4.10/server-4.10.zip \
 && mkdir /il2ds \
 && unzip patch.zip -d /il2ds \
 && rm -f patch.zip


FROM alpine AS download-4.10.1
RUN wget -O patch.zip https://github.com/IL2HorusTeam/il2fb-ds-patches/releases/download/4.10.1/server-4.10.1.zip \
 && mkdir /il2ds \
 && unzip patch.zip -d /il2ds \
 && rm -f patch.zip


FROM alpine AS download-4.11
RUN wget -O patch.zip https://github.com/IL2HorusTeam/il2fb-ds-patches/releases/download/4.11/server-4.11.zip \
 && mkdir /il2ds \
 && unzip patch.zip -d /il2ds \
 && rm -f patch.zip


FROM alpine AS download-4.11.1
RUN wget -O patch.zip https://github.com/IL2HorusTeam/il2fb-ds-patches/releases/download/4.11.1/server-4.11.1.zip \
 && mkdir /il2ds \
 && unzip patch.zip -d /il2ds \
 && rm -f patch.zip


FROM alpine AS download-4.12
RUN wget -O patch.zip https://github.com/IL2HorusTeam/il2fb-ds-patches/releases/download/4.12/server-4.12.zip \
 && mkdir /il2ds \
 && unzip patch.zip -d /il2ds \
 && rm -f patch.zip


FROM alpine AS download-4.12.1
RUN wget -O patch.zip https://github.com/IL2HorusTeam/il2fb-ds-patches/releases/download/4.12.1/server-4.12.1.zip \
 && mkdir /il2ds \
 && unzip patch.zip -d /il2ds \
 && rm -f patch.zip


FROM alpine AS download-4.12.2
RUN wget -O patch.zip https://github.com/IL2HorusTeam/il2fb-ds-patches/releases/download/4.12.2/server-4.12.2.zip \
 && mkdir /il2ds \
 && unzip patch.zip -d /il2ds \
 && rm -f patch.zip


FROM alpine AS download-4.13
RUN wget -O patch.zip https://github.com/IL2HorusTeam/il2fb-ds-patches/releases/download/4.13/server-4.13.zip \
 && mkdir /il2ds \
 && unzip patch.zip -d /il2ds \
 && rm -f patch.zip


FROM alpine AS download-4.13.1
RUN wget -O patch.zip https://github.com/IL2HorusTeam/il2fb-ds-patches/releases/download/4.13.1/server-4.13.1.zip \
 && mkdir /il2ds \
 && unzip patch.zip -d /il2ds \
 && rm -f patch.zip


FROM alpine AS download-4.13.2
RUN wget -O patch.zip https://github.com/IL2HorusTeam/il2fb-ds-patches/releases/download/4.13.2/server-4.13.2.zip \
 && mkdir /il2ds \
 && unzip patch.zip -d /il2ds \
 && rm -f patch.zip


FROM alpine AS download-4.13.3
RUN wget -O patch.zip https://github.com/IL2HorusTeam/il2fb-ds-patches/releases/download/4.13.3/server-4.13.3.zip \
 && mkdir /il2ds \
 && unzip patch.zip -d /il2ds \
 && rm -f patch.zip


FROM alpine AS download-4.13.4
RUN wget -O patch.zip https://github.com/IL2HorusTeam/il2fb-ds-patches/releases/download/4.13.4/server-4.13.4.zip \
 && mkdir /il2ds \
 && unzip patch.zip -d /il2ds \
 && rm -f patch.zip


FROM alpine AS download-4.14
RUN wget -O patch.zip https://github.com/IL2HorusTeam/il2fb-ds-patches/releases/download/4.14/server-4.14.zip \
 && mkdir /il2ds \
 && unzip patch.zip -d /il2ds \
 && rm -f patch.zip


FROM alpine AS download-4.14.1
RUN wget -O patch.zip https://github.com/IL2HorusTeam/il2fb-ds-patches/releases/download/4.14.1/server-4.14.1.zip \
 && mkdir /il2ds \
 && unzip patch.zip -d /il2ds \
 && rm -f patch.zip


FROM alpine AS build

ARG IL2DS_UID
ARG IL2DS_GID

COPY --from=download-2.04   /il2ds /il2ds
COPY --from=download-3.03   /il2ds /il2ds
COPY --from=download-3.04   /il2ds /il2ds
COPY --from=download-4.01   /il2ds /il2ds
COPY --from=download-4.02   /il2ds /il2ds
COPY --from=download-4.03   /il2ds /il2ds
COPY --from=download-4.04   /il2ds /il2ds
COPY --from=download-4.05   /il2ds /il2ds
COPY --from=download-4.06   /il2ds /il2ds
COPY --from=download-4.07   /il2ds /il2ds
COPY --from=download-4.08   /il2ds /il2ds
COPY --from=download-4.09   /il2ds /il2ds
COPY --from=download-4.10   /il2ds /il2ds
COPY --from=download-4.10.1 /il2ds /il2ds
COPY --from=download-4.11   /il2ds /il2ds
COPY --from=download-4.11.1 /il2ds /il2ds
COPY --from=download-4.12   /il2ds /il2ds
COPY --from=download-4.12.1 /il2ds /il2ds
COPY --from=download-4.12.2 /il2ds /il2ds
COPY --from=download-4.13   /il2ds /il2ds
COPY --from=download-4.13.1 /il2ds /il2ds
COPY --from=download-4.13.2 /il2ds /il2ds
COPY --from=download-4.13.3 /il2ds /il2ds
COPY --from=download-4.13.4 /il2ds /il2ds
COPY --from=download-4.14   /il2ds /il2ds
COPY --from=download-4.14.1 /il2ds /il2ds

RUN rm -f /il2ds/confc.ini /il2ds/confs.ini /il2ds/gc.cmd /il2ds/server.cmd \
 && mkdir /il2ds/logs /il2ds/conf /il2ds/scripts \
 && rm -f /il2ds/il2sconsole.exe /il2ds/il2server_new.exe /il2ds/il2wconsole.exe

COPY conf/*    /il2ds/conf/
COPY scripts/* /il2ds/scripts/
COPY il2server.sh /il2ds/il2server.sh

RUN chown -R $IL2DS_UID:$IL2DS_GID /il2ds \
 && chmod 744 /il2ds/il2server.sh


FROM base

LABEL org.opencontainers.image.version="4.14.1"
LABEL org.opencontainers.image.source="https://github.com/IL2HorusTeam/il2fb-ds-docker/tree/4.14.1/"

ENV IL2DS_JAVA_HEAP_MB=256

COPY --from=build /il2ds /il2ds

USER il2ds

WORKDIR /il2ds

CMD /il2ds/il2server.sh
