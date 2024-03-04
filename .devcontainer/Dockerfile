FROM python:3.11

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    USER=tods

EXPOSE 8000

    # create non-root $USER and home directory
RUN useradd --create-home --shell /bin/bash $USER && \
    # setup directory and permissions for docs
    mkdir -p /app/mkdocs && \
    chown -R $USER /app/mkdocs && \
    # install server components
    apt-get update && \
    apt-get install -qq --no-install-recommends build-essential && \
    python -m pip install --upgrade pip

WORKDIR /app/mkdocs

USER $USER

# update PATH for local pip installs
ENV PATH "$PATH:/home/$USER/.local/bin"

COPY docs/requirements.txt docs/requirements.txt
RUN pip install -r docs/requirements.txt && pip install pre-commit

COPY . .

# install pre-commit environments in throwaway Git repository
# https://stackoverflow.com/a/68758943
RUN git init . && \
    pre-commit install-hooks && \
    rm -rf .git

CMD ["mkdocs", "serve", "--dev-addr=localhost:8000"]
