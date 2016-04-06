# README


# Server:
```
git clone https://github.com/ciaoben/movies.git
bundle install
npm install
rails s 
```

# Client:
```
bundle install
sudo mkdir /usr/local/bin/local.movie.daemon
sudo cp -R local.movie.daemon/ /usr/local/bin/local.movie.daemon
sudo cp local.movie.daemon/movie.daemon.plist /Library/LaunchDaemons
```

# Commands

`/usr/bin/local.movie.daemon/agent` - start the agent
`/usr/bin/local.movie.daemon/sync_now /Users/ben/Downloads/torrents/` - use this for first sync, substitute the folder to watch
`/usr/bin/local.movie.daemon/agent` - reset local db
