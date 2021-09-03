FROM python:3.9

WORKDIR /app/mkdocs
EXPOSE 8000

COPY . .

RUN pip install -r docs/requirements.txt

CMD ["mkdocs", "serve", "--dev-addr=localhost:8000"]
