#Build stage using multi stage
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o main main.go

#RUN stage
FROM alpine
WORKDIR /app
COPY --from=builder /app/main .
EXPOSE 9090

CMD [ "/app/main" ] 