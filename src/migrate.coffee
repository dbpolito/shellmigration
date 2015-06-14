fs = require('fs')
colors = require('colors')
execSync = require('child_process').execSync
arrayDiff = require('./array_diff')
currentPath = fs.realpathSync('.')
migrationsPath = currentPath + '/migrations'

class Migrate
    getAllMigrations: ->
        fs
            .readdirSync migrationsPath
            .filter (file) ->
                file.indexOf('.sh') isnt -1

    getMigrated: ->
        if not fs.existsSync(migrationsPath + '/.migrated')
            console.log 'File ' + migrationsPath + '/.migrated not found, something is wrong in your configs or you forgot to run: shellmigration init'
            process.exit()

        fs
            .readFileSync(migrationsPath + '/.migrated', 'utf8')
            .split('\n')
            .filter (file) ->
                file = file.trim()
                file isnt '' and fs.existsSync(migrationsPath + '/' + file)

    getMigrations: ->
        arrayDiff @getAllMigrations(), @getMigrated()

    isMigrated: (file) ->
        this.getMigrated().indexOf(file) isnt -1

    init: ->
        path = fs.realpathSync(__dirname)
        fs.mkdirSync migrationsPath
        fs.createReadStream(path + '/stubs/shellmigration.json').pipe fs.createWriteStream(currentPath + '/shellmigration.json')
        fs.createReadStream(path + '/stubs/gitignore').pipe fs.createWriteStream(migrationsPath + '/.gitignore')
        fs.createReadStream(path + '/stubs/migrated').pipe fs.createWriteStream(migrationsPath + '/.migrated')

    run: ->
        migrated = @getMigrated()
        migrations = @getMigrations()

        if not migrated.length and not migrations.length
            console.log colors.red('No migrations.')
            process.exit()
        else if not migrations.length
            console.log colors.green('You are up to date, good job!')
            process.exit()

        for index, file of migrations
            console.log 'Running migration:', file
            console.log execSync('sh ' + file,
                cwd: migrationsPath
                encoding: 'utf8')
            fs.appendFileSync migrationsPath + '/.migrated', file + '\n'

        console.log colors.green('Everything is finished, ' + migrations.length + ' migrations where ran successfully.')

    list: (type) ->
        if type is 'done'
            message = 'All migrations ran:\n'
            migrations = this.getMigrated()
        else if type is 'do'
            message = 'All migrations to be ran:\n'
            migrations = this.getMigrations()
        else
            message = 'All migrations:\n'
            migrations = this.getAllMigrations()

        console.log message

        for index, file of migrations
            output = file

            if type is 'all' and this.isMigrated file
                output = file + ' (migrated)'

            console.log output

module.exports = ((dir, alias) ->
    new Migrate
)()
