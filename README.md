[<img src="https://travis-ci.org/sul-dlss/was-thumbnail-service.svg?branch=master" alt="Build Status" />](https://travis-ci.org/sul-dlss/was-thumbnail-service)
[![Coverage Status](https://coveralls.io/repos/sul-dlss/was-thumbnail-service/badge.svg?branch=master)](https://coveralls.io/r/sul-dlss/was-thumbnail-service?branch=master)

# was-thumbnail-service
It is responsible for creating and delivering the thumbnails for the seed URIs.

## Download the code locally
```
git clone https://github.com/sul-dlss/was-thumbnail-service.git
cd was-thumbnail-service/
rvm use 2.1.4
bundle install
```

### Configure database
In the config/database.yml
Add database user/password

Open your mysql client.
```create database was_thumbnail_service```
In the shell,
``` bin/rake db:migrate RAILS_ENV=development```

### Prepare the configuration
Copy the configuration from the example
```cp config/environments/example.rb config/environments/development.rb ```

## Operation
In the shell, you can add a new seed to the database through the API.

```curl -i "http://localhost:3000/api/seed/create?druid=druid:ab123cd4567&uri=http://slac.stanford.edu"```

It should return 200, it means the uri is added successfully

```
bundle exec bin/delayed_job start
bundle exec rake RAILS_ENV=development was_thumbnail_service:run_thumbnail_monitor
```

Run the server.

```rails s```

You can get an overview of the system by going to http://localhost:3000/


