class Shemi
    run: ->
        program = require 'commander'
        colors = require 'colors'
        migrate = require './migrate'

        program.version '0.1.3'

        program
            .command 'help'
            .description 'help'
            .action (cmd) ->
                program.help()

        program
            .command 'init'
            .description 'initialize project configuration'
            .action (cmd) ->
                migrate.init()

        program
            .command 'migrate'
            .description 'migrate'
            .action (cmd) ->
                migrate.run()

        program
            .command 'list'
            .option '--all', 'Show all migrations. (Default)'
            .option '--done', 'Show all migrations ran.'
            .option '--do', 'Show all migrations to be ran.'
            .description 'list'
            .action (cmd) ->
                type = switch
                    when cmd.done then 'done'
                    when cmd.do then 'do'
                    else 'all'

                migrate.list type

        program.parse process.argv

        program.help() if not program.args.length

module.exports = ((dir, alias) ->
    new Shemi
)()
