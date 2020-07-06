# Define required macros here
SHELL = /bin/sh

deploy:
	docker build . -t surenmcode/crash-test-app:1.0
	docker push surenmcode/crash-test-app:1.0
	kubectl delete all --all
	kubectl apply -f crash-test-app.yaml
	

