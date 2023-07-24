FROM python:3.11

WORKDIR /app/mkdocs
EXPOSE 8000

RUN python -m pip install --upgrade pip
COPY docs/requirements.txt docs/requirements.txt
RUN pip install -r docs/requirements.txt

COPY . .

CMD ["mkdocs", "serve", "--dev-addr=localhost:8000"]
