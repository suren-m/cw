#### Developing with Docker - Bonus / Additional challenges

> The following are fairly advanced scenarios meant for users that are already familiar with Docker. 

> Feel free to implement this scenario if you have enough time and are into or interested in software development.

> If you're new to docker or dotnet, take your time to get familiarzed with the technology before taking on these challenges.

#### 1. For dotnet developers

Consider a scenario where the above `strings-app` container needs to retrieve the length of a given string through a web-api container called `my-api`
 
In order for `strings-app` to connect to the `my-api` container by its `name`, both containers should be on a user-defined bridge network. 
 
`strings-app` will use something like a `HttpClientFactory` in `dotnet` to speak to `my-api` endpoint that will just take a string and return its length.

> Additionally, try creating a docker-compose.yml file with two `services`. Then spin up both containers together using `docker-compose up` and bring them down using `docker-compose down`

> see: https://docs.docker.com/compose/compose-file/

---

#### 2. For Javascript developers 

The goal here is to get features such as `hot module reloading` working on a dockerized javascript app without having to rebuild the image everytime after a small change.

Create an `angular` or a `react` or a `vuejs` app using cli. (or even just a html page for now)

If using webpack, make sure hot module reloading is enabled on webpack.

Dockerize the app and create a separate `dockerfile.local` or/and `dockercompose.local.yaml`

Add a volume mount such as below to your `dockercompose.local.yaml`:  

``` volumes:
      - "/app/node_modules"
      - ".:/app"
```

> see: https://stackoverflow.com/questions/48685664/dockerized-angular-cli-application-hot-reload-fails

---