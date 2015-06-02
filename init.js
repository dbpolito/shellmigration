var fs = require('fs');

fs.mkdirSync('./migrations');

fs.createReadStream('./stubs/shellmigration.json').pipe(fs.createWriteStream('./shellmigration.json'));
fs.createReadStream('./stubs/gitignore').pipe(fs.createWriteStream('./migrations/.gitignore'));
fs.createReadStream('./stubs/migrated').pipe(fs.createWriteStream('./migrations/.migrated'));
