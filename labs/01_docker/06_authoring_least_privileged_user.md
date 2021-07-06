## Running Docker Container as a Least Privileged User

#### 1. Create a folder such as `lpu-base-image` and create a `Dockerfile` within it.

#### 2. Build a custom base image with least privileged user.

> Type in the following in `Dockerfile`. 
> Here we create a user called `devuser` and add them to `devgroup`

```bash
FROM ubuntu:20.04
RUN groupadd -r devgroup && useradd -r -g devgroup devuser
USER devuser
```
> Build the image
```bash
docker build . -t custom-ubuntu-lpu:20.04
```

> Cd out of that directory
```bash
cd ..
```

#### 3. Create an image that uses our new custom-ubuntu image with least privileged user.

> Create a new folder called `lpu-id-printer` and a `Dockerfile` within it.
```bash
FROM custom-ubuntu-lpu:20.04
CMD ["id"]
```

> Build and Run that container

```
docker build . -t lpu-id-printer:1.0
docker run lpu-id-printer:1.0
```

> Above will launch the cmd as `devuser` (non-root) and should print details about that user.

> Feel free to do a `run -it` into a container of `lpu-id-printer:1.0` and try deleting any programs in `/bin` folder. You should see a permission denied message.

---

Note: In real world scenarios, make sure the user account has just enough rights to the application directory inside the container. 

> See more about best practices here: 
https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
https://www.docker.com/blog/intro-guide-to-dockerfile-best-practices/
