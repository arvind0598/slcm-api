/****************************************
returns a promise to write data to a file
****************************************/

const fs = require("fs");
const newman = require("newman");
const exec = require("child_process").exec;

module.exports = function getData() {
    var results = [];

    return new Promise(function(res, rej) {

        /****************************************
        runs the collection
        ****************************************/

        newman.run({
                reporters: "cli",
                collection: "./SLCM.postman_runner.json"
            })

            /****************************************
            reads the response at every step
            ****************************************/

            .on("request", function(err, args) {
                if (!err) {
                    var rawBody = args.response.stream;
                    var body = rawBody.toString();
                    results.push(body);
                } else rej(err.toString());
            })

            /****************************************
            writes the last response to file
            ****************************************/

            .on("done", function(err, summary) {
                fs.writeFileSync("./src/report.html", results[results.length - 1]);
                const child = exec("cd src && python3 extract_data.py && cd ..", function(err) {
                    if (err) {
                        console.log(err);
                        rej(err.toString());
                    } else {
                        res("completed.");
                    }
                });
            });
    });
}