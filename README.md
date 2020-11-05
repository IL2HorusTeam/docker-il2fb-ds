# docker-il2fb-ds

This repository contains a definition of a Docker image with the dedicated server of «IL-2 Sturmovik: Forgotten Battles» flight simulator of version `4.14.1` running under 32-bit `wine` `5.0`. See tags for other versions.

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
* `il2ds` user belonging to the `il2ds` and `wine` groups with home dir at `/home/il2ds`. No login shell.
* Configured 32-bit `wine` prefix at `/home/il2ds/.wine32`.
* Dedicated server of version `4.14.1` installed at `/il2ds` and running via `il2ds` user.
* ENV variables:

  | Var Name             | Used by `wine`? | Default Value               | Description |
  | -------------------- | --------------- | --------------------------- | ----------- |
  | `WINEPREFIX`         | yes             | `"/home/il2ds/.wine32"`     | Path to `wine` configs |
  | `WINEARCH`           | yes             | `"win32"`                   | Used by `wine` tools |
  | `WINEDEBUG`          | yes             | `"-all"`                    | Disables `wine` warnings |
  | `IL2DS_CONF`         | no              | `"/il2ds/conf/confs.ini"`   | Path to `il2ds` config to use |
  | `IL2DS_INIT`         | no              | `"/il2ds/scripts/init.cmd"` | Path to `il2ds` initialization script |
  | `IL2DS_JAVA_HEAP_MB` | no              | `256`                       | Size of Java Heap in megabytes |

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

### Basic

The basic example with published UDP port `21000`:

``` shell
docker run -it --rm -p 0.0.0.0:21000:21000/udp il2horusteam/il2ds:4.14.1-wine5.0
```

Example output:

```
DT Version 1.1.1.0
RTS Version 2.2
Core Version 2.0
Sound: Native library (build 1.1, target - P IV) loaded.
IL2 FB dedicated server v4.14.1m
1>f /il2ds/scripts/gc.cmd
>GC
Memory: total(4456448) free(437344)
>GC
Memory: total(4128768) free(479032)
>GC
Memory: total(4128768) free(478616)
>timeout 3600000 f /il2ds/scripts/gc.cmd
6>
```


### Custom Configs

The server uses the config `/il2ds/conf/confs.ini` by default.

In order to use a custom config, a volume with a custom `confs.ini` file has to be mounted to `/il2ds/conf`.

It's good to mount that volume as read-only.

For example, in case the server's configs are stored in the host's `/opt/il2ds/conf` directory:

``` shell
docker run -it --rm \
  -p 0.0.0.0:21000:21000/udp \
  -v /opt/il2ds/conf:/il2ds/conf:ro \
  il2horusteam/il2ds:4.14.1-wine5.0
```

If there is a need to use a config file with a custom name, this can be specified via `IL2DS_CONF` env var.

For example, running the server with the config file `custom_confs.ini` residing in the host's `/opt/il2ds/conf` directory:

``` shell
docker run -it --rm \
  -p 0.0.0.0:21000:21000/udp \
  -v /opt/il2ds/conf:/il2ds/conf:ro \
  -e IL2DS_CONF=/il2ds/conf/custom_confs.ini
  il2horusteam/il2ds:4.14.1-wine5.0
```


### Custom Initialization Scripts

The server uses the init script `/il2ds/scripts/init.cmd` by default.

In order to use a custom script, a volume with a custom `init.cmd` file has to be mounted to `/il2ds/scripts`.

It's good to mount that volume as read-only.

For example, in case the server's scripts are stored in the host's `/opt/il2ds/scripts` directory:

``` shell
docker run -it --rm \
  -p 0.0.0.0:21000:21000/udp \
  -v /opt/il2ds/scripts:/il2ds/scripts:ro \
  il2horusteam/il2ds:4.14.1-wine5.0
```

If there is a need to use an init file with a custom name, this can be specified via `IL2DS_INIT` env var.

For example, running the server with the ini file `custom_init.cmd` residing in the host's `/opt/il2ds/scripts` directory:

``` shell
docker run -it --rm \
  -p 0.0.0.0:21000:21000/udp \
  -v /opt/il2ds/scripts:/il2ds/scripts:ro \
  -e IL2DS_INIT=/il2ds/scripts/custom_init.cmd
  il2horusteam/il2ds:4.14.1-wine5.0
```


# Custom Java Heap Size

The server uses `256` megabytes for the Java Heap by default.

It is possible to change this values to one of the following:

* `256`
* `384`
* `512`
* `768`
* `1024`

The value can be set via `IL2DS_JAVA_HEAP_MB` env var, for example:

``` shell
docker run -it --rm \
  -p 0.0.0.0:21000:21000/udp \
  -e IL2DS_JAVA_HEAP_MB=768 \
  il2horusteam/il2ds:4.14.1-wine5.0
```


### Custom Missions

The server uses missions from the ``/il2ds/Missions/Net`` by default.

In order to use custom missions, a volume with missions has to be mounted to `/il2ds/Missions/Net`.

It's good to mount that volume as read-only.

For example, in case the server's missions are stored in the host's `/opt/il2ds/missions` directory:

``` shell
docker run -it --rm \
  -p 0.0.0.0:21000:21000/udp \
  -v /opt/il2ds/missions:/il2ds/Missions/Net:ro \
  il2horusteam/il2ds:4.14.1-wine5.0
```


### Accessing Server's Logs

By default, the server is configured to write its logs into the `/il2ds/logs` directory:

| File Path                 | Description |
| ------------------------- | ----------- |
| `/il2ds/logs/console.log` | Logs of the server's console |
| `/il2ds/logs/events.log`  | Logs of in-mission events |


It's possible to access those logs from the host by mounting the volume `/il2ds/logs`.

As the server runs under the `il2ds` user inside containers, this user must have a write access to the mounted directory.

For example, create a directory for DS logs:

``` shell
mkdir -p /opt/il2ds/logs
```

Change its owner and owning group using UID and GID of the ``il2ds`` user (both are ``21000`` by default):

``` shell
chown 21000:21000 /opt/il2ds/logs
```

Set the access permissions:

``` shell
chmod 755 /opt/il2ds/logs
```

Now it's possible to run the server with the mounted volume:

``` shell
docker run -it --rm \
  -p 0.0.0.0:21000:21000/udp \
  -v /opt/il2ds/logs:/il2ds/logs \
  il2horusteam/il2ds:4.14.1-wine5.0
```

This will make server's logs available inside of the host's `/opt/il2ds/logs` directory:

``` shell
ls -l /opt/il2ds/logs
```
```
total 8
-rw-r--r-- 1 21000 21000 691 Nov  3 17:04 console.log
-rw-r--r-- 1 21000 21000 120 Nov  3 17:04 events.log
```

``` shell
cat /opt/il2ds/logs/console.log
```
```
[Nov 3, 2020 3:03:53 PM] ------------ BEGIN log session -------------
[3:03:55 PM]	1>f /il2ds/scripts/gc.cmd
[3:03:55 PM]	>GC
[3:03:55 PM]	Memory: total(4456448) free(437344)
[3:03:55 PM]	>GC
[3:03:55 PM]	Memory: total(4128768) free(479032)
[3:03:55 PM]	>GC
[3:03:55 PM]	Memory: total(4128768) free(478616)
[3:03:55 PM]	>timeout 3600000 f /il2ds/scripts/gc.cmd
[3:03:55 PM]	6>mission LOAD Net/dogfight/   1/01_1Net16armySummer1200.mis BEGIN
[3:04:02 PM]	7>[3:04:02 PM]	Loading mission Net/dogfight/   1/01_1Net16armySummer1200.mis...
[3:04:02 PM]	Load bridges
[3:04:02 PM]	Load static objects
[3:04:02 PM]	Mission: Net/dogfight/   1/01_1Net16armySummer1200.mis is Playing
[3:04:03 PM]	7>
```

``` shell
cat /opt/il2ds/logs/events.log
```
```
[Nov 3, 2020 3:04:02 PM] Mission: Net/dogfight/   1/01_1Net16armySummer1200.mis is Playing
[3:04:02 PM] Mission BEGIN
```

### Connecting to Console & Device Link

Even if the server's config sets `[NET]/localHost` and `[DeviceLink]/host` to `0.0.0.0`, it will not be possible to connect to the server's Console and Device Link outside of the server's containers.

The server allows connections only from addresses/subnets specified in `[Console]/IPS` and `[DeviceLink]/IPS` config parameters for Console and Device Link respectively.

By default these parameters are set to `127.0.0.1`:

``` ini
[Console]
IP=20000
IPS=127.0.0.1

[DeviceLink]
host=0.0.0.0
port=10000
IPS=127.0.0.1
```

This means that by default it's not possible to connect to Console and Device Link outside of server's containers.

In order to overcome this, the server has to run in a custom network with a specific subnet. That will allow to specifying the subnet in the server's config.

Add a custom network with a suitable subnet. For example, a network `il2ds` with a subnet `10.11.12.0/28`:

``` shell
docker network create --subnet 10.11.12.0/28 il2ds
```

Create a custom server's config, e.g. at `/opt/il2ds/conf/confs.ini`.

Add the address of that network's gateway (which is `10.11.12.1`) to the server's `IPS` parameters:

``` ini
[Console]
IP=20000
IPS=127.0.0.1 10.11.12.1
# ...

[DeviceLink]
host=0.0.0.0
port=10000
IPS=127.0.0.1 10.11.12.1
```

Run the server with the custom config and network, and with published ports of the Console and Device Link:

``` shell
docker run -it --rm \
  -p 0.0.0.0:21000:21000/udp \
  -p 127.0.0.1:20000:20000/tcp \
  -p 127.0.0.1:10000:10000/udp \
  -v /opt/il2ds/conf:/il2ds/conf:ro \
  --network il2ds \
  il2horusteam/il2ds:4.14.1-wine5.0
```

Check it's possible to connect to the server's Console:

``` shell
telnet 127.0.0.1 20000
```
```
Trying 127.0.0.1...
Connected to 127.0.0.1.
Escape character is '^]'.
```

Ensure the server responds to commands:

```
mission
```
```
Mission NOT loaded\n
<consoleN><7>
```


### Full example

The following command runs the server with all of the use-cases described above:

``` shell
docker run -it --rm \
  -p 0.0.0.0:21000:21000/udp \
  -p 127.0.0.1:20000:20000/tcp \
  -p 127.0.0.1:10000:10000/udp \
  -v /opt/il2ds/missions:/il2ds/Missions/Net:ro \
  -v /opt/il2ds/scripts:/il2ds/scripts:ro \
  -v /opt/il2ds/conf:/il2ds/conf:ro \
  -v /opt/il2ds/logs:/il2ds/logs \
  --network il2ds \
  -e IL2DS_JAVA_HEAP_MB=768 \
  il2horusteam/il2ds:4.14.1-wine5.0
```
