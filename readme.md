[![Stories in Ready](https://badge.waffle.io/dbpolito/shellmigration.png?label=ready&title=Ready)](https://waffle.io/dbpolito/shellmigration)
## shellmigration

Manage environments are hard, every time you need to add a new dependency, install something here, change something there, right?

__shellmigration__ is here you help you, this basically create versions of your environment.

### Install

````
npm install -g shellmigration
````

### How to use

````
shellmigration init
````

This will setup your folder, creating the files below:

````
- migrations/
--- .gitignore
--- .migrated
- shellmigrations.js
````

Create the files you want to run inside the folder `migrations`, for example:

__File: migrations/20150602122250_echo_ok.sh__

````
#!/bin/bash

echo 'OK'
````

Now, to run the migrations:

````
shellmigration migrate
````

You can also run:

````
shellmigration list --all
shellmigration list --done
shellmigration list --do
````

#### This is under development.
