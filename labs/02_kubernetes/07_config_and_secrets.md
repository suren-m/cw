# Config and Secrets

### Steps

1. Create a configmap named myconfig with values `<your-firstname>-1=lala,<your-firstname>-2=lolo`

    ```bash
        kubectl create configmap <your-firstname>-myconfig --from-literal=<your-firstname>-1=lala --from-literal=<your-firstname>-2=lolo
    ```

>Bonus: Where is this config Map located? Hint: It's not in your namespace. (see configuration on vs extension)

### IMPORTANT: In the lab environment, every participant has full access to the shared cluster, so please do not put anything sensitive in the secrets as others will be able to see it too. Just put some dummy text as in example below.


2. Create a secret called mysecret with the values <your-firstname>-password=mypass

    ```bash
        kubectl create secret generic <your-firstname>-mysecret --from-literal=<your-firstname>-password=mypass
    ```

3. Create a new nginx pod that loads the value from configmap ```<your-firstname>-myconfig``` ->  ```<your-firstname>-1``` in an env variable called 'option'. Also load secret '<your-firstname>-mysecret' as a volume inside an nginx pod on path ```/etc/secrets```.

    ```bash
    # review the manifest and look how the configMap and secret is referenced    
    # make sure your terminal's directory is set to yaml_files folder. `cd` into  or `cd ..` as needed.

    # open `config-and-secrets.yaml` in `yaml_files` folder with vs-code or just cat.    
    cat config-and-secrets.yaml

    # Create Pod from the script file
    # If you get file not found, make sure your terminal is set to right directory.    
    kubectl apply -f config-and-secrets.yaml

    # Or you can pass full path. 
    # For example, if your terminal is at `cw` folder, then 
    # `kubectl apply -f ./labs/02_kubernetes/yaml_files/config-and-secrets.yaml`
    ```

4. Check environment variable ```option``` and ```/etc/secrets``` has expected values

    ```bash
    kubectl exec -it nginx -- env | grep option
    kubectl exec -it nginx -- ls /etc/secrets
    ```
    or 

    ```bash
    kubectl exec -it nginx -- sh
    # And from within the container's shell
    env 
    # Look for the `option` env variable in the list
    cd /etc/secrets && ls
    cat <your-name>-password
    exit

5. Clean up your resources

    ```bash
        kubectl delete all --all
    ```
