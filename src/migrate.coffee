fs = require('fs')
colors = require('colors')
execSync = require('child_process').execSync
module.exports = ((dir, alias) ->
    currentPath = fs.realpathSync('.')
    migrationsPath = currentPath + '/migrations'

    arrayDiff = (a1, a2) ->
        `var i`
        a = []
        diff = []
        i = 0
        while i < a1.length
            a[a1[i]] = true
            i++
        i = 0
        while i < a2.length
            if a[a2[i]]
                delete a[a2[i]]
            else
                a[a2[i]] = true
            i++
        for k of a
            diff.push k
        diff

    {
        getAllMigrations: ->
            fs.readdirSync(migrationsPath).filter (file) ->
                file.indexOf('.sh') != -1
        getMigrated: ->
            if !fs.existsSync(migrationsPath + '/.migrated')
                console.log 'File ' + migrationsPath + '/.migrated not found, something is wrong in your configs or you forgot to run: shellmigration init'
                process.exit()
            fs.readFileSync(migrationsPath + '/.migrated', 'utf8').split('\n').filter (file) ->
                file = file.trim()
                file != '' and fs.existsSync(migrationsPath + '/' + file)
        getMigrations: ->
            arrayDiff @getAllMigrations(), @getMigrated()
        init: ->
            path = fs.realpathSync(__dirname)
            fs.mkdirSync currentPath + '/migrations'
            fs.createReadStream(path + '/stubs/shellmigration.json').pipe fs.createWriteStream('./shellmigration.json')
            fs.createReadStream(path + '/stubs/gitignore').pipe fs.createWriteStream(currentPath + '/migrations/.gitignore')
            fs.createReadStream(path + '/stubs/migrated').pipe fs.createWriteStream(currentPath + '/migrations/.migrated')
            return
        run: ->
            migrated = @getMigrated()
            migrations = @getMigrations()
            if !migrated.length and !migrations.length
                console.log colors.red('No migrations.')
                process.exit()
            else if !migrations.length
                console.log colors.green('You are up to date, good job!')
                process.exit()
            for x of migrations
                `x = x`
                file = migrations[x]
                console.log 'Running migration:', file
                console.log execSync('sh ' + file,
                    cwd: migrationsPath
                    encoding: 'utf8')
                fs.appendFileSync migrationsPath + '/.migrated', file + '\n'
            console.log colors.green('Everything is finished, ' + migrations.length + ' migrations where ran successfully.')
            return

    }
)()
