[<img src="https://travis-ci.org/sul-dlss/was-thumbnail-service.svg?branch=master" alt="Build Status" />](https://travis-ci.org/sul-dlss/was-thumbnail-service)
[![Coverage Status](https://coveralls.io/repos/sul-dlss/was-thumbnail-service/badge.svg?branch=master)](https://coveralls.io/r/sul-dlss/was-thumbnail-service?branch=master)
[![GitHub version](https://badge.fury.io/gh/sul-dlss%2Fwas-thumbnail-service.svg)](https://badge.fury.io/gh/sul-dlss%2Fwas-thumbnail-service)

# was-thumbnail-service
Rails app for providing thumbnail images for web archiving seed object URIs.    These thumbnails are intended to be used by discovery environments that include the seed objects, such as SearchWorks, and by access tools such as sul-embed.

The thumbnail images are derived from WARC artifacts in an openwayback machine corresponding to the seed URI.  There may be one or more thumbnail images per seed URI -- particular "mementos" are chosen for images based on the simhash gem's "hamming distance" between mementos.

Background job workers are used to determine if new mementos have been added to the Wayback machine and if so, if new thumbnails should be generated.

Note that when `was_robot_suite` step `wasSeedDissemnationWF` triggers thumbnail image creation, thumbnail is added to DOR object contentMetadata.  However new thumbnail images created by the background workers are put only in the digital stacks, not in DOR object contentMetadata.  This allows DOR seed objects to redo their thumbnails in the digital stacks without altering the DOR object itself.

## Download the code locally
```
git clone https://github.com/sul-dlss/was-thumbnail-service.git
cd was-thumbnail-service/
bundle install
```

## Configuration

### Settings
Copy the configuration from the example.
```
cp config/environments/example.rb config/environments/development.rb
```

### Database

#### config/database.yml

##### MySql

1. Add database user/password

2. Create the mysql databases

```
- mysql -e 'create database test_was_thumbnail_service;'
- mysql -e 'create database dev_was_thumbnail_service;'
```

or from mysql client:
```
create database dev_was_thumbnail_service;
create database test_was_thumbnail_service;
```

##### SQLite (for local testing)

Revise `config/database.yml` with these changes:

```
development:
  # <<: *default
  # database: dev_was_thumbnail_service
  adapter: sqlite3
  database: db/test.sqlite3
  pool: 5
  timeout: 5000

# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.
#test:
#  <<: *default
#  database: test_was_thumbnail_service
test:
  adapter: sqlite3
  database: db/test.sqlite3
  pool: 5
  timeout: 5000
```

Sqlite does not need a separate step to create the database.

###### Note about testing with SQLite

Note that some specs fail with sqlite.  There appears to be a simhash value in some test fixtures that only works with mysql, not sqlite.  To get around this, there is a rake task to run all tests except those that require mysql:

```
rake spec_sqlite
```

#### Perform database migrations (set up the schema)

```
rake db:migrate
```

## Operation

### Run the Rails server.

```
rails s
```

You can get an overview of the system by going to http://localhost:3000/ .  This should show a table of seed objects in the database, their druids, URIs, number of mementos and number of images.

### Adding a new seed

#### locally

In the shell, you can add a new seed to the database through the API.  Choose a uri in the openwayback app you entered in your configuration.

```
curl -i "http://localhost:3000/api/seed/create?druid=druid:ab123cd4567&uri=http://slac.stanford.edu"
```

It should return 200, meaning the seed URI is added successfully.  At first, the rails app table will show the seed's druid and uri, but there will be no mementos or thumbnails.  Those will be added via a background process.

#### in our infrastructure

When a new seed is accessioned (generally via `was-registrar`), a workflow step from `wasSeedDissemnationWF` (from `was_robot_suite`) will call the api (as above) to add the seed to the was-thumbnail-service.

### Thumbnail generation

This is done as a background process with `delayed_job`:

```
bin/delayed_job start
rake RAILS_ENV=development was_thumbnail_service:run_thumbnail_monitor
```
