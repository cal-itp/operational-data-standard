# Running locally

Requires [Docker](https://docs.docker.com/get-docker/). The following commands
should be entered and run in a terminal program like `bash`.

## Clone the repository

```bash
git clone https://github.com/cal-itp/mkdocs-template
cd mkdocs-template
```

## Build the image

```bash
docker build -t mkdocs-template -f docs/Dockerfile .
```

## Run a container

```bash
docker run -p 8000:8000 mkdocs-template
```

The site should be available at <http://localhost:8000>.

## VS Code Remote Containers

This repository comes with a [VS Code Remote Containers](https://code.visualstudio.com/docs/remote/containers)
configuration file.

Once you clone the repository locally, simply open it within VS Code, which will
prompt you to re-open the repository within the Remote Container.

Once running inside the Remote Container, the site is available at <http://localhost:8000>.
