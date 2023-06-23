APP_NAME ?= go-crud-redis

build:
	go build -o app

run:
	./app

redis:
	docker run -d --name=myredis -p 6379:6379 redis

image:
	docker build -t ${APP_NAME} -f Dockerfile .

container:
	docker run -p 5000:5000 --name myapp ${APP_NAME}
