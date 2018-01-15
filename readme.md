# Introduction
Dockerfile for installation of a coturn server (tied to a matrix one).

- [compose](https://github.com/corpusops/setups.matrix)
- [coturn](https://github.com/coturn/coturn)
- [matrix img](https://github.com/corpusops/docker-matrix)
- [matrix](https://matrix.org)
- [riot](https://github.com/corpusops/docker-riot)

[compose]: https://github.com/corpusops/setups.matrix
[coturn]: https://github.com/coturn/coturn
[matrix img]: https://github.com/corpusops/docker-matrix
[matrix]: https://matrix.org
[github]: https://github.com/silvio/matrix-riot-docker

# Configuration

To configure run the image with "generate" as argument. You have to setup the
server domain and a `/data`-directory. After this you have to edit the
generated config files.

To get the things done, "generate" will create a own self-signed certificate.

> This needs to be changed for production usage.

Example:

    $ docker run -v /tmp/data:/data --rm -e SERVER_NAME=localhost -e REPORT_STATS=no silviof/docker-matrix generate

# Start

Think to forward tcp,udp:3478,5349,49152:65535

For starting you need the port bindings and a mapping for the
`/data`-directory.

    $ docker run -d v /tmp/data:/data silviof/docker-matrix start

You may also have to set the external ip of the server in turnserver.conf which is located in the `/data` volume:
`external-ip=XX.XX.XX.XX`

In case you don't want to expose the whole port range on udp you can change the portrange in turnserver.conf:
`min-port=XXXXX`
`max-port=XXXXX`

# Version information
To get the installed synapse version you can run the image with `version` as
argument or look at the container via cat.

    $ docker run -ti --rm silviof/docker-matrix version
    coturn:  master (88bd6268d8f4cdfdfaffe4f5029d489564270dd6)

    # docker exec -it CONTAINERID cat /coturn.version
    coturn:  master (88bd6268d8f4cdfdfaffe4f5029d489564270dd6)

# build specific arguments
* `BV_TURN`: coturn turnserver version, optional, defaults to `master`

For building of synapse version v0.11.0-rc2 and coturn with commit a9fc47e add
`--build-arg --build-arg BV_TURN=a9fc47efd77` to the `docker
build` command.

# Exported volumes
* `/data`: data-container
