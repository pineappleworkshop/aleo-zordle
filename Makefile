docker-image := gcr.io/pineappleworkshop/aleo-zordle:0.0.0

docker-build:
	docker build -t $(docker-image) .

docker-run:
	docker run -it $(docker-image) 