return {
    bots = "Bots",
    ping = {
        ping = "pinging....",
        pong = "pong ``{{arg1}}ms``",
        description = "shows latency information"
    },
    help = {
        embedTitle = "Help for Tiger 2.0",
        embedDescription = "Hello! I'm Tiger, a bot written in Lua with the Discordia library.\nUse the reaction buttons to filter through the command list.\n\nRemember: for most commands, if it requires a prompt, you can skip it with the ``|`` character. For example: ``tiger ban @user | reason | duration``. If a command is restricted for you, you can grant it with ``tiger perms``.\n\nFinally, most commands have what are called **flags.** A flag allows you to further customize a command. Flags start with two dashes and go at the **END** of the command. Flags may contain arguments.\nTo view detailed information on a command, use the ``--help`` flag. For example: ``tiger ban --help`` will show you information on a command. It'll also show you other flags you can use. Example: ``tiger prune 100 --bots --contains test`` will look through 100 messages and prune the ones created by bots that contain the text 'test'.\n\nOfficial links: [Discord Server](https://discord.gg/62qYz8J) | [Invite](https://discordapp.com/oauth2/authorize?&client_id=225079733799485441&scope=bot&permissions=8)\n",
        description = "shows this menu",
    },
    reload = {
        description = "reloads a module",
        failed = "Module failed to reload: ``{{arg1}}``",
        success = "Successfully reloaded module ``{{arg1}}``",
        noname = "Please specify a module name."
    },
    autorole = {
        name = "Autoroles",
        description = "sets up an automatic role.",
        firstPrompt = "Would you like to **create** an autorole, **delete** an existing one, or **list** the current autoroles?",
        secondPrompt = "What condition would you like to apply to this role?\nConditions: **get**, **join**, **bot**",
        choices = {
            create = "create",
            delete = "delete",
            list = "list",
            get = "get",
            join = "join",
            bot = "bot"
        },
        roleFind = "What **role** are you targeting?",
        saveSuccess = "Successfully **saved** your new autorole.",
        roleError = "Cannot create an autorole for a role that is higher than your highest role.",
        roleDelete = "Successfully **deleted** your autorole.",
        invalidRoles = "Invalid Roles",
        none = "None to show.",
        autorolesFor = "Autoroles for **{{arg1}}**"
    },
    server = {
        description = "view detailed server information.",
        largeServer = "Large Server",
        owner = "Owner",
        emojis = "Emojis",
        members = "Members",
    },
    invite = {
        title = "Invite Tiger",
        botInvite = "Bot Invite",
        helpInvite = "Help Server Invite",
        description = "invites Tiger to your server."
    },
    user = {
        description = "view detailed user information."
    },
    stats = {
        description = "shows detailed information about Tiger."
    },
    ["8ball"] = {
        description = "predict the future!"
    },
    flipcoin = {
        description = "flip a coin."
    },
    cat = {
        description = "sends a random picture of a cat."
    },
    dog = {
       description = "sends a random picture of a dog." 
    },
    perms = {
        description = "configure command permissions."
    },
    giphy = {
        description = "searches giphy for a query."
    }
}