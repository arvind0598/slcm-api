const fs = require("fs");
const newman = require("newman");
const exec = require("child_process").exec;

module.exports = function getData(){
	var results = [];

	return new Promise(function(res, rej) {

		newman.run({
			reporters: "cli",
			collection: "./SLCM.postman_collection.json"
		})

		.on("request", function(err, args) {
			if(!err) {
				var rawBody = args.response.stream;
				var body = rawBody.toString();
				results.push(body);
			}
			else rej(err.toString());
		})

		.on("done", function(err, summary) {
			fs.writeFileSync("./src/report.html", results[results.length - 1]);
			const child = exec("cd src && python3 extract_data.py && cd ..", function(err) {
				if(err) {
					console.log(err);
					rej(err.toString());
				}
				else {
					res("completed.");
				}
			});
		});
	})
}