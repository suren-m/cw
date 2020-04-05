# Setting up your lab environment

### 01 Clone the repo into your vsonline workspace (or your environment of choice)

* Goto https://aka.ms/remote-containers-workshop and clone the repo using `https`

```bash
    git clone https://github.com/surenmcode/cw.git
```

> You are free to set up and organizse your lab workspace as you prefer. You can also just use the folders in this git repo for lab work if that suits you. For e.g: store your lab files inside `01_docker` folder when you are doing docker labs. 

> **Important** If you are on vs online, it is highly recommended to keep your lab work backed up in a version control hub such as github. Vs online is still in public preview and if your environment gets accidentally corrupted, you will lose your lab files. As always, please **do not** check-in any sensitive information into version control.

### 02 Install linux command line tools. 

> If you are new to linux command line, just install the below ones that would be helpful later during the labs.

```bash
# Cd into 00_setup folder (prefix parent dir as needed)
    cd labs/00_setup
```

```bash
# Install command line tools such httpie, jq, tmux. We will cover them later during demos.
    chmod +x 01_init.sh
    ./ 01_init.sh
```

```bash 
# Install kubectl. You will also need to install kubernetes extension for vs code alongside when prompted. (or install later)
    chmod +x 02_kubectl.sh
    ./02_kubectl.sh
```

```bash
# Install helm
    chmod +x 03_helm.sh
    ./03_helm.sh
```

```bash
# Remove get-helm.sh (tidy up)
    rm get_helm.sh
```

#### Install any dev tools and extensions you need on vs online

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
