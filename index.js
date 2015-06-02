function array_diff(a1, a2)
{
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
}

var fs = require('fs'),
    execSync = require('child_process').execSync,
    currentPath = fs.realpathSync('.'),
    migrationsPath = currentPath + '/migrations',
    migrations = fs.readdirSync(migrationsPath).filter(function(file) {
        return file.indexOf('.sh') !== -1;
    }),
    migrated = fs.readFileSync(migrationsPath + '/.migrated', 'utf8').split("\n").filter(function(file) {
        file = file.trim();
        return file !== '' && fs.existsSync(migrationsPath + '/' + file)
    }),
    migrate = array_diff(migrations, migrated);

for (x in migrate) {
    var file = migrate[x];
    console.log('Running migration:', file, execSync('sh ' + file, {
        cwd: migrationsPath,
        encoding: 'utf8',
    }));
    fs.appendFileSync(migrationsPath + '/.migrated', file + "\n")
}
