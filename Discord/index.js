require('dotenv').config();

const { Client, Events, IntentsBitField } = require('discord.js');
const prefix = require('./config.json').prefix;

const client = new Client({ intents: ['MessageContent', 'Guilds', 'DirectMessages', 'GuildMessages'] });

client.once(Events.ClientReady, c => {
    console.log(c.user.tag + ' is online!')
})

client.on(Events.MessageCreate, msg => {
    if (msg.author.bot) return;
    if (!msg.content.startsWith(prefix)) return;
    
    const args = msg.content.trim().split(/ +/g)
    const cmd = args[0].slice(prefix.length).toLowerCase()

    if (cmd === 'encrypt') {
        const key = args[1];
        var n = (Number(key) <= 10000 && key) || false;

        if (!n) return msg.reply('Too much key to generate!');
        
        const dumpster = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
        var data = {}
        for (i=0; i<dumpster.length; i++) {
            atCode = dumpster.charCodeAt(i)
            data[atCode] = dumpster[i];
        }

        const clamp = (num, min, max) => Math.min(Math.max(num, min), max);
        var sub = [];
        do {
            const max_byte = clamp(n, 1, 122)
            const rm = Math.floor((Math.random() * max_byte) + 1)
            sub.push(rm)
            n = n - rm
        }
        while ( n != 0 )

        var response = ""
        for (val of sub) {
            if (data[val]) {
                response = response + data[val]
            } else {
                if (val >= 10) {
                    response = response + val.toString();
                } else {
                    response = response + ('_-')[Math.round(Math.random())] + val.toString();
                }
            }
        }

        msg.reply(response)
    }

    if (cmd == 'decrypt') {
        const str = args[1];
        const key = args[2];

        var alphabet = [];
        var numbers = [];

        charOnly = str.replace(/[^a-zA-Z]+/g, '')
        if (charOnly.length > 0) {
            for (val of charOnly) {
                alphabet.push(val);
            }
        }

        singleNum = str.matchAll(/(-|_)[0-9]/g)
        for (val of singleNum) {
            const num = val[0].replace(/[^0-9]/g, '');
            numbers.push(Number(num))
        }

        var twoDigitNumber = str.replace(/[a-zA-Z]/g, '').replace(/(-|_)[0-9]/g, '');
        for (val of twoDigitNumber.matchAll(/\d\d/g)) {
            numbers.push(Number(val[0]))
        }

        var sum = 0;
        for (val of alphabet) {
            const toByte = val.charCodeAt(val);
            sum += toByte;
        }

        for (val of numbers) {
            sum += val;
        }

        if (sum == key) {
            return msg.reply('They key of encrypted string is correct!')
        } else {
            return msg.reply('Wrong key!')
        }
    }
 })

client.login(process.env.TOKEN)