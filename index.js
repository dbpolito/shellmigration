var program = require('commander'),
    colors = require('colors'),
    migrate = require('./migrate');

program.version('0.1.0');

program
    .command('help')
    .description('help')
    .action(function(cmd){
        program.help();
    });

program
    .command('init')
    .description('initialize project configuration')
    .action(function(cmd){
        migrate.init();
    });

program
    .command('migrate')
    .description('migrate')
    .action(function(){
        migrate.run();
    });

program
    .command('list')
    .option('--all', 'Show all migrations. (Default)')
    .option('--done', 'Show all migrations ran.')
    .option('--do', 'Show all migrations to be ran.')
    .description('list')
    .action(function(cmd){
        var message = '',
            migrations = [];

        if (cmd.done) {
            message = 'All migrations:\n'
            migrations = migrate.getMigrated();
        } else if (cmd.do) {
            message = 'All migrations ran:\n'
            migrations = migrate.getMigrations();
        } else {
            message = 'All migrations to be ran:\n'
            migrations = migrate.getAllMigrations();
        }

        console.log(message);

        for (x in migrations) {
            var file = migrations[x];

            console.log(file)
        }
    });

program.parse(process.argv);

if (!program.args.length) program.help();
