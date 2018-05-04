const fs = require("fs");

/****************************************
readData and readCred return promises to
read their respective files and work in
exactly the same way.
****************************************/

function readData() {
    return new Promise(function(resolve, reject) {
        fs.readFile("SLCM.postman_collection.json", function(err, data) {
            if (err) {
                reject(err.toString);
                throw err;
            } else resolve(JSON.parse(data));
        });
    });
}

function readCred() {
    return new Promise(function(resolve, reject) {
        fs.readFile("./src/cred.json", function(err, data) {
            if (err) {
                reject(err.toString);
                throw err;
            } else resolve(JSON.parse(data));
        });
    });
}

/****************************************
updateCredentials updates the runner
JSON with parameters from the cred JSON.
****************************************/

module.exports = function updateCredentials() {
    return new Promise(function(res, rej) {
        var dataPromise = readData();
        var credPromise = readCred();

        var postman = null;
        var cred = null;

        /************************************************************
        once dataPromise is resolved, req parses the actual request.
        ************************************************************/

        dataPromise.then(function(x) {
            postman = x;
            let req = postman.item[1].request.body.raw.split("&");

            /************************************************************
            credPromise resolution leads to updation of runner.
            ************************************************************/

            credPromise.then(function(cred) {
                let user = req[6].split("=")[0] + "=" + cred.username;
                let pass = req[7].split("=")[0] + "=" + cred.password;
                req[6] = user;
                req[7] = pass;
                postman.item[1].request.body.raw = req.join("&");
                fs.writeFile("SLCM.postman_runner.json", JSON.stringify(postman), function(err) {
                    if (err) throw err;
                });
            });
        });
    });
}