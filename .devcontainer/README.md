# Running locally in a devcontainer

## Requirements

- [Docker](https://www.docker.com/products/docker-desktop/)
- [VS Code](https://code.visualstudio.com/) with the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

Ensure Docker is running on your system before continuing.

## Obtain copy of source

```bash
git clone https://github.com/cal-itp/operational-data-standard.git
cd operational-data-standard
```

## Open in VS Code

```bash
code -r .
```

## Rebuild and Reopen devcontainer

You will be prompted to do so, or you may use the VS Code _Command Palette_:

```console
Ctrl/Cmd + Shift + P

> Dev Containers: Rebuild and Reopen in Container
```

## View docs locally

Once the devcontainer is setup and running, bring up the _Terminal_ window with:

```console
Ctrl/Cmd + `
```

Check the `PORTS` tab for the `Local Address` where the site is running (<http://localhost:8000> by default).

## Update and reload

When updates are made to the local files, the site automatically rebuilds and your browser window refreshes to show the changes.
