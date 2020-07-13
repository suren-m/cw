# Setting up your lab environment

## 01 - Setup your lab environment on **vs code / codespaces**

Run the below commands in your vs code terminal. 

> If you are using azure cloud shell, skip to `02 - kubectl setup` further below

> You can launch an integrated terminal from menu button (three lines) on top-left. (See [here](https://github.com/suren-m/remote-workshop-env/blob/master/codespaces/assets/vs_code_overview.png) if you're new to vs code)

```bash
# get the setup script
wget https://raw.githubusercontent.com/suren-m/cw/master/labs/00_setup/lab_env.sh -O lab_env.sh

# give execution rights
chmod +x lab_env.sh

# run it
./lab_env.sh     
```

---

## 02 -  Configure kubectl to access the kubernetes cluster

Access to kubernetes clusters are managed using a config file.

#### For Codespaces users

* Create the config file by using below command. This should open vs code editor

    ```bash
    code ~/.kube/config
    ```

* Copy and paste the yaml contents from provided link (See chat for the link)

* Save the file (`Ctrl + S` on vs code or use the save option from menu (three lines) on top-left)

* Close the file

* Test the connection from terminal. Below should return a list of nodes.

    ```bash
    kubectl get nodes
    ```

* It is highly recommended that you use vs code via `codespaces` for the labs. But if for some reason you are unable to use it, then use `nano` as an editor for pasting the config.

    > **Below is only for those not using vs code and haven't completed above steps.**

    ```bash
    # create `.kube` directory if it doesn't exist
    mkdir ~/.kube
    
    # use nano only if above vs code approach didn't work.
    nano ~/.kube/config 

    # paste the contents of yaml from provided link. 
    # ctrl + shift + v (or use right click)

    # save the file and exit nano
    # save - ctrl + O 
    # Confirm save - just hit Enter when prompted to write the file (at bottom of screen)
    # exit - ctrl + x 

    # Check connection. Below should return a list of nodes.
    kubectl get nodes    
    ```

* If you're still having problems connecting to the cluster, feel free to reach out to the instructor.
---

## 03 - Setup your default namespace. (as we're sharing a cluster)

* Create a namespace with unique name. (for example, using a combination of your first-name and first-letter of your surname)

    > only use lower-case letters and dashes

```bash
    # for example, john-h or jane-s
    kubectl create namespace <your-firstname-and-initial> 
    
    # use your own namespace as a default 
    kubectl config set-context --current --namespace=<your-namespace-name>

    # test it. below should return `No resources found in <your-namespace>`
    kubectl get pods
```

---
## 04 - Extensions for vs code

Install Docker and Kubernetes extensions for VS Code

> Note: If you're new to vs code, please reach out for a quick primer.

* Goto Extensions (ctrl + shift + x)
* Search for below extensions and install them
    * Docker (extension by Microsoft)
    * Kubernetes (extension by Microsoft)       
* Click Install and Reload when asked

> **Important:** If you are on codespaces (vs online), it is highly recommended to keep your lab files backed up using something like github so you can take them with you. As always, please **do not** check-in any sensitive information into version control.
---

## Bonus

#### Install any dev tools and extensions you need on vs code online

> Feel free to configure your vs online environment as you prefer. It already comes with dotnet and nodejs installed. 

#### Some command line tips

* Ctrl + C - exit (sometimes ctrl + d if you are in a python interpreter for example)
* Ctrl + L - clear screen
* Ctrl + A - go to begining of the line
* Ctrl + E - go to end of the line (may be overrided with vs shortcuts)

>Note: `tmux` stands for terminal multiplexer and has many useful features such as `split-panes`,  `sessions`, `synchronized typing`,  etc. To use it just type `tmux` and then `ctrl + b` followed by `"` or `%` to split the panes as needed. To exit tmux, just type `exit`. See [docs](https://tmuxcheatsheet.com/) for more options such as sessions. 

#### VS Code tips

* Ctrl + shift + p - Command palette. From there,
    * To toggle / maximize vs terminal, type `Maximized Panel` 
