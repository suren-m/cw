# Getting Started with Docker

>**Important:** You would want to prefix docker commands with `sudo` if you are on linux environments such as `vs online`. Or else, you will get `permission denied` exceptions. There are a few ways to work around this, but that's out of scope for now.

> if you forget to type `sudo`, just type `sudo !!` the second time. In bash, `!!` means to simply repeat the previous command and is quite invaluable when working with linux environments. 

## Hello World Container

From terminal, run

```bash 
    docker run hello-world
```

> **Note:** `docker run` = `docker create` + `docker start` (+ also `docker attach`)

* Where did the image `hello-world` come from? Is it a docker official image?

>  Hint: See https://hub.docker.com/_/hello-world 

* Observe the output log, starting from `pulling` the image from public registry.

* Understand the architecture. (We'll look at build shortly)

![Docker Architecture](../assets/docker_architecture.svg)

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

>`i` - keep STDIN open even if not attached

>`t` - Allocate a pseudo-tty

One easy way to remember: `-it` -> interactive terminal

### See locally cached images

```bash
    docker images 
```
*   prefix with `sudo` as needed

The result shows images that are locally cached in your environment. So, the next time you `run` that exact image, it won't be pulled from registry.

### Experimenting with the same ubuntu image

* Run the same ubuntu image again but with a little twist

1. Run it without `bash` in the end.
    ```bash
        docker run -it ubuntu
    ```
2

```bash
    docker run -it ubuntu ls    
```

* Observe the result. What's going on here? We are overriding the default cmd for that image

> See https://docs.docker.com/engine/reference/run/#cmd-default-command-or-options

### Create a simple Dockerfile to host a we

```bash
#1. Create a Docker File w
```