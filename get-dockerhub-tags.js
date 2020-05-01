#!/usr/bin/node
const https = require("https");

async function getResponseText(response) {
    return await new Promise((resolve, reject) => {
        let data = "";

        response.on("data", chunk => data += chunk).on("end", () => resolve(data)).on("error", reject);
    });
}

async function getResults(url) {
    const response = await new Promise((resolve, reject) => {
        const request = https.get(url, resolve);
        request.on("error", reject);
    });

    const { next, results } = JSON.parse(await getResponseText(response));

    return next ? results.concat(await getResults(next)) : results;
}

async function printTags(url) {
    const results = await getResults(url);
    return results.forEach(({name}) => console.log(name));
}

printTags(process.argv[2]).catch(error => {
   console.error(`Unhandled error: ${error.stack || error}`);
   process.exit(-1);
});
