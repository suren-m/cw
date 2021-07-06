# Getting Started with Docker

## Hello World Container

From terminal, run

```bash 
    docker run hello-world
```

> **Note:** `docker run` = `docker create` + `docker start` (+ also `docker attach`)

* Where did the image `hello-world` come from? Is it an official image?

>  Hint: See https://hub.docker.com/_/hello-world 

* Observe the output log, starting from `pulling` the image from public registry.

* Understand the architecture. (We'll look at build shortly)

![Docker Architecture](../../assets/docker_architecture.svg)

### Run Ubuntu and interact with its shell environment!

```bash
    docker run -it ubuntu bash

    or 

    docker run -i -t ubuntu bash
```

Execute some commands inside that docker container

```bash 
    ls
```

> Exit the container shell by typing `exit`

Take your time to understand what `-it` flag does when used with `docker run`

``` 
`i` - keep STDIN open even if not attached
`t` - Allocate a pseudo-tty
```

One easy mnemonic to remember: `-it` -> interactive terminal

### See locally cached images

```bash
    docker images 
```
The result shows images that are locally cached in your environment. So, the next time you `run` that exact image, it won't be pulled from registry.

### Exploring docker run

* Run the same ubuntu image again but with a little twist

1. Run it without `bash` in the end. Notice how it still works the same way as before? This is because the ubuntu image's `cmd` is set to run `bash` by default. `exit` the container shell.
    ```bash
        docker run -it ubuntu
    ```

> Note: If we just run `docker run ubuntu`, bash will exit automatically as it does not have an stdin to listen to. We'll see later about executing a `process` using `EntryPoint` in docker and how web apps make use of it.

2. Now override the default `cmd` with some other command such as `ls`. Run the below and notice the difference in result.

```bash
    docker run -it ubuntu ls    
```

* Observe the result. What's going on here? We are overriding the default cmd for that image

> See https://docs.docker.com/engine/reference/run/#cmd-default-command-or-options

### Run a Webserver

Run an nginx webserver as below.

```bash
    docker run -d -p 9000:80 nginx 
    # -p stands for publish (publish a container's port to the host)

# You will be able to see the webpage on localhost:9000 if you are running docker locally or in a linux vm.

```

> `-d` flag indicates that the container will run in detatched mode, so it's not waiting for input via `stdin`

```bash
# See running containers
    docker ps    
```

Now, run another instance of nginx container. Just use a different port.

```bash
    docker run -d -p 9001:80 nginx
    docker ps # notice the new container from same image. Much like new objects from a class.
```

#### View the contents of the webpage from Terminal

You can view the webpage from browser or terminal using http client tools such as `curl` or `httpie` 

```bash
curl localhost:9000

# or via httpie (for coloured output and more helpful info)
http localhost:9001
```
    
#### Stop the nginx containers.

```bash           
    # run `docker ps` to list the running containers. 

    docker stop <container-id> 
            or
    docker stop <container_name_1> <container_name_2> # Note: it's container name not image name.
```

> Bonus: Look up for the difference between `stop`, `kill` and `rm` commands

#### See all containers including the `created` and `exited` ones

```bash
# `docker ps` only shows containers that are of status `Running`. To see all containers, use `-a` flag

    docker ps -a
```

#### You can always start a stopped container by issuing `start` command

Find the container, you want to start by looking up on `docker ps -a`. Just because the container has stopped or exited, it doesn't mean it's dead.

```bash
    docker start <container_id or name>
```

----

## Cleanup

### For removing a stopped container

```bash
docker rm <container_id/name>
```
### For removing images
```bash 
docker rmi image <image_id_1> <image_id_2>
```

#### Clean up Dangling resources with `docker system prune`
```bash
docker system prune
```

#### To clean up all resources including images,containers,volumes, etc.
```
docker system prune --all

# `y' when prompted
```

>Important: As with any other system, use clean up commands with caution. Do not force delete images that are still referenced by containers. 

Give these links a quick read:
* https://docs.docker.com/engine/reference/commandline/system_prune/
* https://docs.docker.com/config/pruning/
* https://docs.docker.com/engine/reference/commandline/rmi/

#### Check if your environment is cleaned up

```bash
docker ps -a
docker images -a
```
