# Docker File

## Create your first Dockerfile and execute a `CMD` (greeter:1.0)

1. Create a folder as needed. For e.g: `mkdir my_first_dockerfile` and `cd` into that folder or open that in `vs online`

2. Create a Dockerfile and just call it `Dockerfile` to keep up with the conventions.

3. Type the below inside the `Dockerfile`. (Avoid copy pasting unless specified)

    ```bash
    FROM ubuntu # Base Layer

    CMD ["echo", "Hello everyone"]

    ```

4. Build your Docker Image. Make sure the terminal is pointing to the directory where `Dockerfile` is located.

    > Don't forget to prefix with `sudo` if you are on vs online.

    ```bash
        # Build an image called `greeter` and tag it as version `1.0`
        docker build . -t greeter:1.0
    ```

    > Important: Take your time to understand what `-t` does. And also note the `.` after docker build. 

5. See your new docker image by `sudo docker images`

6. Launch a container from the new docker image.

    ```bash
        docker run greeter:1.0

        # Observe the output
    ```

7. Make it print something else by overriding the default CMD

    ```bash
        docker run greeter:1.0 echo "hello universe"
        #or any command of your choice that is available in ubuntu image
        docker run greeter:1.0 sleep "3"
    ```
    Notice that we have to specify the full command to override the existing one.

## Use `Entrypoint` to make greeter a bit more configurable.

1. Update the `Dockerfile` as below. Comment out previously written code if needed.

    ```bash
        FROM ubuntu

        ENTRYPOINT [ "echo" ]

        CMD ["Hello everyone"]
    ```

2. `Build` and tag greeter image with version 2.0 and `Run` the container.

    ```bash
        docker build . -t greeter:2.0 
        docker run greeter:2.0
    ```
3. Now just run the below to make the container print message of your choice.

    ```bash
        docker run greeter:2.0 "Hello Greeter 2.0"
    ```

## Use `COPY` to launch a simple static website

1. Create a new `Dockerfile` in another folder or feel free to continue working on your existing `Dockerfile`. 

2. Create a folder called `website` and create a file inside called `index.html`. Type some simple markup such as below.

    ```html
        <h1>Hello World</h1>
    ```

3. Now, type the below into your `Dockerfile`

    ```bash
        FROM nginx:alpine 
        # Notice the change in base image. 
        COPY ./website/ /usr/share/nginx/html
        # Copy the contents of website folder into nginx default website location
    ```

>Nginx is a powerful and highly popular webserver. See Nginx base image here: https://hub.docker.com/_/nginx

5. Now Build your docker image as below: (feel free to pick your own name for the image)

    Make sure your folder structure should look something like below before building.

    ```bash
    .
    ├── Dockerfile
    └── website
        └── index.html
    ```

    ```bash
        docker build . -t hello-web:1.0
        docker images "hello-web" # to see your new built image. 
    ```

5. Run the image detached and do port-forwarding. You will get an exception if the port is already in use.

    ```bash
        docker run --name my-first-website -d -p 9000:80 hello-web:1.0
        # Notice the `--name` argument. We give our own container name this time.
    ```

> **Important** : If you are on `vs online`, you will not be able to launch the website as there isn't any loopback (localhost) address. But this will work if you are running docker on your own machine or in a VM. We will see more of web apps once we start deploying to Kuberenetes.

6. Ensure the container is running as expected with `docker ps`. Observe all the columns of your `my-first-website` container.

### Clean up the resources as done before and ensure your environment is correctly tidied up.   

    ```bash
        sudo docker system prune -a
        sudo docker ps -a
        sudo docker images
    ```
> Bonus: Try other approaches to clean up your environment too. `rmi`, `prune container`, etc.



