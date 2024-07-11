# JMusicBot-Updater
Updates JMusicBot Service to given version\
Used for https://github.com/jagrosh/MusicBot while running as a linux systemd service\

## Usage
```
./JMusicBot-Update.sh [-v version] [-l link] [-p path] [-s service] [-h]
```

## Options
**-v** version    Specify the version number (e.g., 1.2.3)\
**-l** link       Specify the direct download link\
**-p** path       Specify the directory path to save JMusicBot.jar (default is current directory)\
**-s** service    Specify the systemd service name (default is JMusicBot.service)\
**-h**            Help message\
