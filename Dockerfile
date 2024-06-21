#Build stage using multi-stage
FROM golang:1.22-alpine3.20 AS builder
WORKDIR /app
COPY . .
RUN go build -o main main.go

#RUN stage
FROM alpine:3.20
WORKDIR /app
COPY --from=builder /app/main .
COPY app.env .
EXPOSE 9090

CMD [ "/app/main" ]