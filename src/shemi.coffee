module.exports = ((dir, alias) ->
    { run: ->
        program = require('commander')
        colors = require('colors')
        migrate = require('./migrate')
        program.version '0.1.3'
        program.command('help').description('help').action (cmd) ->
            program.help()
            return
        program.command('init').description('initialize project configuration').action (cmd) ->
            migrate.init()
            return
        program.command('migrate').description('migrate').action ->
            migrate.run()
            return
        program.command('list').option('--all', 'Show all migrations. (Default)').option('--done', 'Show all migrations ran.').option('--do', 'Show all migrations to be ran.').description('list').action (cmd) ->
            message = ''
            migrations = []
            if cmd.done
                message = 'All migrations:\n'
                migrations = migrate.getMigrated()
            else if cmd.do
                message = 'All migrations ran:\n'
                migrations = migrate.getMigrations()
            else
                message = 'All migrations to be ran:\n'
                migrations = migrate.getAllMigrations()
            console.log message
            for x of migrations
                `x = x`
                file = migrations[x]
                console.log file
            return
        program.parse process.argv
        if !program.args.length
            program.help()
        return
 }
)()
