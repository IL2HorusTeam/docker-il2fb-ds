# docker-il2fb-ds

This repository contains a definition of a Docker image with the dedicated server of «IL-2 Sturmovik: Forgotten Battles» flight simulator of version `2.04` running under 32-bit `wine` `5.0`.

Image is built from official server patches (see [`il2fb-ds-patches`](https://github.com/IL2HorusTeam/il2fb-ds-patches)) on top of [`il2horusteam/wine:5.0`](https://hub.docker.com/r/il2horusteam/wine).


## Public builds

This Docker image is available as `il2horusteam/il2ds` at [Docker Hub](https://hub.docker.com/r/il2horusteam/il2ds):

``` shell

docker pull il2horusteam/il2ds

```

## Build Args

The image has several arguments which can be changed during the build time:

| Arg Name      | Default Value | Description                       |
| ------------- | ------------- | --------------------------------- |
| `IL2DS_UID`   | `21000`       | `UID` to use for the user `il2ds` |
| `IL2DS_GID`   | `21000`       | `GID` to use for the user `il2ds` |


## Deliverables

The image provides:

* `il2ds` group.
* `il2ds` user belonging to the `il2ds` and `wine` groups with home dir at `/il2ds`. No login shell.
* Configured 32-bit `wine` prefix at `/il2ds/.wine32`.
* Dedicated server of version `2.04` installed at `/il2ds` and running via `il2ds` user.
* ENV variables:

  | Var Name       | Used by `wine`? | Value                       | Description |
  | -------------- | --------------- | --------------------------- | ----------- |
  | `WINEPREFIX`   | yes             | `"/il2ds/.wine32"`          | Path to `wine` configs |
  | `WINEARCH`     | yes             | `"win32"`                   | Used by `wine` tools |
  | `WINEDEBUG`    | yes             | `"-all"`                    | Disables `wine` warnings |
  | `IL2DS_CONF`   | no              | `"/il2ds/conf/confs.ini"`   | Path to `il2ds` config to use |
  | `IL2DS_INIT`   | no              | `"/il2ds/scripts/init.cmd"` | Path to `il2ds` initialization script |

* Exposed ports:

  | Port        | Description |
  | ----------- | ----------- |
  | `21000/udp` | Port for players |
  | `20000/tcp` | Port of the management console |
  | `10000/udp` | Port of the Device Link |

* Volumes:

  | Path                   | Description |
  | ---------------------- | ----------- |
  | `/il2ds/conf/`         | Volume where server's configs can be mounted |
  | `/il2ds/logs/`         | Volume where server's logs can be mounted |
  | `/il2ds/scripts/`      | Volume where server's scripts can be mounted |
  | `/il2ds/Missions/Net/` | Volume where missions can be mounted |


## Usage Examples

The basic example with published UDP port `21000`:

``` shell
docker run -it --rm -p 21000:21000/udp il2horusteam/il2ds:2.04-wine5.0
```


Example output:

```
IL2 FB dedicated server v2.04
Sound: Native library (build 1.1, target - standard) loaded.
RTS Version 2.1
Core Version 2.0
1>f /il2ds/scripts/gc.cmd
>GC
Memory: total(4980736) free(752312)
>GC
Memory: total(4456448) free(809872)
>GC
Memory: total(4390912) free(743920)
>timeout 3600000 f /il2ds/scripts/gc.cmd
6>
```


Running with an attached read-only volume containing `confs.ini` config file:

``` shell
docker run -it --rm \
  -p 21000:21000/udp \
  -v /etc/conf.d/il2ds:/il2ds/conf:ro \
  il2horusteam/il2ds:2.04-wine5.0
```


Running with a specific config from an attached read-only volume:

``` shell
docker run -it --rm \
  -p 21000:21000/udp \
  -v /opt/il2ds/conf:/il2ds/conf:ro \
  -e IL2DS_CONF=/il2ds/conf/custom_confs.ini
  il2horusteam/il2ds:2.04-wine5.0
```

Running with an attached read-only volume containing `init.cmd` initialization script:

``` shell
docker run -it --rm \
  -p 21000:21000/udp \
  -v /opt/il2ds/scripts:/il2ds/scripts:ro \
  il2horusteam/il2ds:2.04-wine5.0
```


Running with a specific init script from an attached read-only volume:

``` shell
docker run -it --rm \
  -p 21000:21000/udp \
  -v /opt/il2ds/scripts:/il2ds/scripts:ro \
  -e IL2DS_INIT=/il2ds/scripts/custom_init.cmd
  il2horusteam/il2ds:2.04-wine5.0
```


Running with a read-only attached volume with missions:

``` shell
docker run -it --rm \
  -p 21000:21000/udp \
  -v /opt/il2ds/missions:/il2ds/Missions/Net:ro \
  il2horusteam/il2ds:2.04-wine5.0
```

Running with an attached volume for storing logs:

``` shell
docker run -it --rm \
  -p 21000:21000/udp \
  -v /opt/il2ds/logs:/il2ds/logs \
  il2horusteam/il2ds:2.04-wine5.0
```
