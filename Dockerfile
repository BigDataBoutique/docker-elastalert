FROM alpine:3.12

WORKDIR /app
RUN apk add --update --no-cache git tzdata gettext ca-certificates openssl-dev openssl openssh \
	libffi-dev gcc musl-dev wget libmagic \
	python3 python3-dev py3-pip

COPY requirements.txt .
RUN pip3 install --upgrade pip setuptools wheel
RUN pip3 install -r requirements.txt
COPY . .
RUN chmod u+x /app/entrypoint.sh

ENV TZ=UTC
CMD ["sh", "/app/entrypoint.sh"]
