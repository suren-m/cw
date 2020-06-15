# Dockerfile - Level II (multi stage builds using a simple dotnet core app)

## Containerize a simple dotnet app

1. Create a folder called `my-apps` and `cd` into it.

    ```bash
        mkdir my-apps && cd my-apps
    ```

2. Create a console app using dotnet cli and call it `strings-app`

    ```bash
        dotnet new console -n strings-app 
    ```

3. Create a `Dockerfile` in the `my-apps` directory and enter the below.

    ```Dockerfile

        FROM mcr.microsoft.com/dotnet/core/runtime:3.1-buster-slim AS base
        WORKDIR /app

        FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
        WORKDIR /src
        COPY ["strings-app/strings-app.csproj", "strings-app/"]
        RUN dotnet restore "strings-app/strings-app.csproj"
        COPY . .
        WORKDIR "/src/strings-app"
        RUN dotnet build "strings-app.csproj" -c Release -o /app/build

        FROM build AS publish
        RUN dotnet publish "strings-app.csproj" -c Release -o /app/publish

        FROM base AS final
        WORKDIR /app
        COPY --from=publish /app/publish .
        ENTRYPOINT ["dotnet", "strings-app.dll"]

    ```

2. Modify the `Main` method in `Program.cs` of `strings-app` as below

```csharp
        static void Main(string[] args)
        {
            while(true) {            
                Console.WriteLine("Enter a string to check it's length or type quit to exit the app:");
                var input = Console.ReadLine();
                if (input.ToLower() == "quit") { break; }
                Console.WriteLine(input.Length);
            }
        }
```

3. Ensure the folder structure looks like below. Notice that the `Dockerfile` is one level up.

```bash
.
└── my-apps
    ├── Dockerfile
    └── strings-app
        ├── Program.cs
        ├── obj             
        └── strings-app.csproj
```

4. Build your Docker Image from `my-apps` folder. Don't forget to prefix with `sudo` if you are on vsonline.

```bash
    docker build . -t strings-app:1.0    
```

5. Now run your app and interact with it.

```bash
    docker run -it --rm strings-app:1.0
    # --rm will automatically remove the container when it exits
```

#### Clean up the environment as done in previous sections

    ```bash
        sudo docker system prune -a
        sudo docker ps -a
        sudo docker images
    ```
> Bonus: Try other approaches to clean up your environment too. `rmi`, `prune container`, etc.

#### Dockerfile Authoring Best Practices
 * https://docs.docker.com/develop/develop-images/dockerfile_best-practices/

#### Advanced / Bonus Challenge

 Take a look at Docker networking and options such as  `user-defined bridge` networks. 
  
 For example, Imagine a scenario where the above `strings-app` container needs to cache recently typed input to a redis cache. 
 
 In order for `strings-app` to connect to the redis container by its `name`, both containers should be on a user-defined bridge network.
 
 See:
 * https://docs.docker.com/network/bridge/
 * https://docs.docker.com/network/

 Feel free to implement this if you have enough time. 
 
  #### Know the advantages and limitations of docker-compose 
 
 #### Hint for strings_app that uses Redis 
 
 #### Note: This may not work in Codespaces / vs online
 
 ```csharp
 using System;
using ServiceStack.Redis;

namespace strings_app
{
    class Program
    {
        static void Main(string[] args)
        {
            // https://docs.servicestack.net/netcore-redis#basic-example
            var manager = new RedisManagerPool("my-cache:6379");
            using (var client = manager.GetClient())
            {
                while(true) {            
                    Console.WriteLine("Enter a string to check it's length or type quit to exit the app:");

                    var input = Console.ReadLine();
                    if (input.ToLower() == "quit") { break; }

                    var cache = client.Get<string>(input);
                    if(cache !=null) {
                        Console.WriteLine($"Cache Hit for {input}");
                        Console.WriteLine(cache);
                    } else {
                        var length = input.Length;
                        Console.WriteLine(length);
                        Console.WriteLine($"Setting Cache for {input}");    
                        client.Set(input, length);                    
                    }

                    Console.WriteLine("...........\n");                                      
                }                
            }

           
        }
    }
}
```
