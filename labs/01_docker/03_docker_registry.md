# Docker Registry

> **Important**: We'll be using public docker registry for the purpose of labs and to faciliate collaboration. In actual development and production environments, you should be using a private registry such as `acr`. See: [Azure container registry](https://azure.microsoft.com/en-gb/services/container-registry/)

## Create a Docker hub account

Go to https://hub.docker.com/ and signup using your temporary outlook / hotmail account. If you are using your personal email to sign up for docker hub, make sure to log out completely at the end of this lab.

1. Once you have created a docker hub account, login via terminal as below. use `sudo` as required if you get permission denied.

    ```bash
        docker login
        # Enter your username and password when prompted
    ```

2. Before you can push your image to your registry, You need to tag it. 

    Tag your `hello-web` image as below. Replace the <image-id> and <dockerhub-username> as needed.

    ```bash
        sudo docker images hello-web 
        
        # Copy the image-id
        sudo docker tag <image-id> <dockerhub-username>/hello-web:1.0

        sudo docker push <docker-hub-username>/hello-web:1.0
    ```

3. Go to `hub.docker.com` to ensure your image is pushed correctly. We will come to this image later during kubernetes labs.

4. You can always test out your image by running it as follows. Use `sudo` as needed and make sure the port number is available.

```bash
    docker run -d -p 9010:80 <dockerhub-username>/hello-web:1.0
    docker ps
    docker stop <hello-web_container_id>
```

5. Logout of docker hub from terminal

```bash
    docker logout
```

### Clean up the resources as done before and ensure your environment is correctly tidied up.   

    ```bash
        sudo docker system prune -a
        # type `y` when prompted
        sudo docker ps -a
        sudo docker images
    ```
> Bonus: Try other approaches to clean up your environment too. `rmi`, `prune container`, etc.