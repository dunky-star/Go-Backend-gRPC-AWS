FROM golang:1.22-alpine

WORKDIR /app

COPY . .

RUN go build -o main main.go

EXPOSE 9090

CMD [ "/app/main" ] 