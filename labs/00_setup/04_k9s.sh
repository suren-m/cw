mkdir k9s && cd k9s
wget https://github.com/derailed/k9s/releases/download/v0.20.5/k9s_Linux_x86_64.tar.gz -O k9s.tar.gz
tar -xvzf k9s.tar.gz
sudo mv k9s /usr/local/bin/
cd ..
rm -rf ./k9s
