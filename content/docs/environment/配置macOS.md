# macOS

## 推荐工具

```bash
brew install wget
brew install git
brew install vim
brew install iterm2
# 风扇控制
brew install --cask smcfancontrol
# 腾讯管家
brew install --cask tencent-lemon 
# vscode
brew install --cask visual-studio-code
# chrome
brew install --cask google-chrome
# 微信
brew install --cask wechat
# docker
# brew install --cask docker
# postman
brew install --cask postman
# v2rayu
brew install --cask v2rayu
# clashx
brew install --cask clashx
# discord
brew install --cask discord
# 快捷键
brew install --cask cheatsheet
# 网易云音乐
brew install --cask neteasemusic
# telegram
brew install --cask telegram
# Beyond Compare
brew install --cask beyond-compare
```

## 环境设置

```bash
# 允许ssh登录
sudo systemsetup -setremotelogin on
# 配置允许登录远程服务器
# append line "Host *" to end of /etc/ssh/sshd_config
echo "Host *" | sudo tee -a /etc/ssh/sshd_config
echo "    HostkeyAlgorithms +ssh-rsa" | sudo tee -a /etc/ssh/sshd_config
echo "    PubkeyAcceptedKeyTypes +ssh-rsa" | sudo tee -a /etc/ssh/sshd_config
# 配置ssh
ssh-keygen -t rsa
```