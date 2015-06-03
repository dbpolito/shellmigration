var fs = require('fs'),
    colors = require('colors'),
    execSync = require('child_process').execSync;

module.exports = function migrate(dir, alias) {

    var currentPath = fs.realpathSync('.'),
        migrationsPath = currentPath + '/migrations',
        arrayDiff = function (a1, a2) {
            var a = [], diff = [];

            for (var i=0;i<a1.length;i++) {
                a[a1[i]]=true;
            }

            for (var i=0;i<a2.length;i++) {
                if(a[a2[i]]) {
                    delete a[a2[i]];
                } else {
                    a[a2[i]]=true;
                }
            }

            for(var k in a) {
                diff.push(k);
            }

            return diff;
        };

    return {
        getAllMigrations: function() {
            return fs.readdirSync(migrationsPath).filter(function(file) {
                return file.indexOf('.sh') !== -1;
            });
        },

        getMigrated: function() {
            if (!fs.existsSync(migrationsPath + '/.migrated')) {
                console.log('File ' + migrationsPath + '/.migrated not found, something is wrong in your configs or you forgot to run: shellmigration init');
                process.exit();
            }
            return fs.readFileSync(migrationsPath + '/.migrated', 'utf8').split("\n").filter(function(file) {
                file = file.trim();
                return file !== '' && fs.existsSync(migrationsPath + '/' + file)
            });
        },

        getMigrations: function() {
            return arrayDiff(this.getAllMigrations(), this.getMigrated());
        },

        init: function() {
            fs.mkdirSync('./migrations');

            fs.createReadStream('./stubs/shellmigration.json').pipe(fs.createWriteStream('./shellmigration.json'));
            fs.createReadStream('./stubs/gitignore').pipe(fs.createWriteStream('./migrations/.gitignore'));
            fs.createReadStream('./stubs/migrated').pipe(fs.createWriteStream('./migrations/.migrated'));
        },

        run: function() {
            var migrated = this.getMigrated(),
                migrations = this.getMigrations();

            if (!migrated.length && !migrations.length) {
                console.log(colors.red('No migrations.'));
                process.exit();
            } else if (!migrations.length) {
                console.log(colors.green('You are up to date, good job!'));
                process.exit();
            }

            for (x in migrations) {
                var file = migrations[x];
                console.log('Running migration:', file);
                console.log(execSync('sh ' + file, {
                    cwd: migrationsPath,
                    encoding: 'utf8',
                }));
                fs.appendFileSync(migrationsPath + '/.migrated', file + "\n")
            }

            console.log(colors.green('Everything is finished, ' + migrations.length + ' migrations where ran successfully.'));
        }
    };

}();
