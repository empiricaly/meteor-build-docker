#!/usr/bin/node
const stdin = process.openStdin();

let data = "";

stdin.on('data', function(chunk) {
    data += chunk;
});

stdin.on('end', function() {
    JSON.parse(data).results.map(({name}) => name).forEach(name => console.log(name));
});