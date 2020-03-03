# gta-assignment

# Install these dependecies:

ruby

postgresql

bundler

Coin-OR CBC


# Install CBC

cd /usr/local

svn co https://projects.coin-or.org/svn/Cbc/stable/2.8 coin-Cbc

cd coin-Cbc

./configure -C #Optionally add --enable-cbc-parallel here to enable multiple threads for cbc

make

make install

PATH=$PATH:/usr/local/coin-Cbc/bin


# For mac : 

$ brew install postgresql

$ gem install bundler

to start the postgres server: $pg_ctl -D /usr/local/var/postgres start



# To run locally : 

$ pg_ctl -D /usr/local/var/postgres start

$ bundle install 

$ cp _sample.env .env

$ should add secrets to secrets.yml

$ add key to scout_apm.yml

$ foreman run rake db:create

$ foreman run rake db:migrate

$ foreman run rake db:setup

$ foreman start

browse to http://localhost:3000/


# For deploying: 

$ heroku git:remote -a gtaassignment

$ bundle install

$ git add .

$ git commit -m "up"
 
$ git push heroku master

$ heroku run rake db:migrate

$ heroku open


# Deploying for new project: 

$ heroku git:remote -a gtaassignment

$ heroku buildpacks:add --index 1 https://github.com/heroku/heroku-buildpack-apt

$ heroku buildpacks:set heroku/ruby

$ bundle install

$ git add .

$ git commit -m "up"
 
$ git push heroku master

$ heroku addons:create heroku-postgresql:hobby-dev

$ heroku run rake db:migrate

$ heroku open

# Google OAuth 

go to https://console.developers.google.com to set credentials

https://console.developers.google.com -> credentials -> credentials -> OAuth Content Screen -> set Product name shown to users

set the Authorized redirect URIs

https://console.developers.google.com -> credentials -> credentials -> create credentials -> OAuth Client ID -> Web application -> Authorized redirect URIs = 

http://gtaassignment.herokuapp.com/users/auth/google_oauth2/callback
https://gtaassignment.herokuapp.com/users/auth/google_oauth2/callback
http://localhost:3000/users/auth/google_oauth2/callback

Authorized JavaScript origins = 

http://localhost:3000

https://gtaassignment.herokuapp.com (hosted application url)

open _sample.env and edit google client id and secret

after that enable Google+ API

https://console.developers.google.com -> Library

DONE




# GTA_Assignment
