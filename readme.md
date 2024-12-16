# Introduction

DISCLAIMER
============

**UNMAINTAINED/ABANDONED CODE / DO NOT USE**

Due to the new EU Cyber Resilience Act (as European Union), even if it was implied because there was no more activity, this repository is now explicitly declared unmaintained.

The content does not meet the new regulatory requirements and therefore cannot be deployed or distributed, especially in a European context.

This repository now remains online ONLY for public archiving, documentation and education purposes and we ask everyone to respect this.

As stated, the maintainers stopped development and therefore all support some time ago, and make this declaration on December 15, 2024.

We may also unpublish soon (as in the following monthes) any published ressources tied to the corpusops project (pypi, dockerhub, ansible-galaxy, the repositories).
So, please don't rely on it after March 15, 2025 and adapt whatever project which used this code.




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
