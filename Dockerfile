FROM python:3.9-slim

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

RUN apt-get update \
  && apt-get install -y --no-install-recommends build-essential libpq-dev \
  && rm -rf /var/lib/apt/lists/*

COPY Pipfile* .

RUN pip install pipenv
RUN pipenv install --system --deploy \
    && useradd -U app_user \
    && install -d -m 0755 -o app_user -g app_user /app/static

WORKDIR /app
USER app_user:app_user
COPY --chown=app_user:app_user . .
RUN chmod +x scripts/*.sh

ENTRYPOINT [ "scripts/entrypoint.sh" ]
CMD [ "scripts/start.sh", "server" ]
