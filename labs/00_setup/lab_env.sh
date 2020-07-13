# setup directories
mkdir cw_labs && cd cw_labs
mkdir docker 
mkdir kubernetes 

# update the package repos
sudo apt update -y

# install essential tools
sudo apt install -y tmux httpie curl wget \ 
nano jq htop tree zip unzip file 

# K9s
mkdir k9s && cd k9s
wget https://github.com/derailed/k9s/releases/download/v0.20.5/k9s_Linux_x86_64.tar.gz -O k9s.tar.gz
tar -xvzf k9s.tar.gz
sudo mv k9s /usr/local/bin/
cd ..
rm -rf ./k9s

printf "...All Set...\n"
printf "...You can now start doing your labs from current directory - $(pwd)...\n"