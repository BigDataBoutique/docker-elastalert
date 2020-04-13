FROM alpine:3.8

WORKDIR /app

RUN apk --update add python py-pip openssl ca-certificates py-openssl wget gettext
RUN apk add --update --no-cache ca-certificates openssl-dev openssl \
	libffi-dev gcc musl-dev wget libmagic \
	python3 python3-dev

COPY requirements.txt .
RUN pip3 install --upgrade pip setuptools wheel
RUN pip3 install -r requirements.txt

COPY . .
CMD ["sh", "/app/entrypoint.sh"]
