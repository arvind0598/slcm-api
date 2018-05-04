const fs = require("fs");

function readData() {
	return new Promise(function(resolve, reject) {
		fs.readFile("SLCM.postman_collection.json", function(err, data) {
			if(err) {
				reject(err.toString);
				throw err;
			}
			else resolve(JSON.parse(data));
		});
	});
}

function readCred() {
	return new Promise(function(resolve, reject) {
		fs.readFile("./src/cred.json", function(err, data) {
			if(err) {
				reject(err.toString);
				throw err;
			}
			else resolve(JSON.parse(data));
		});
	});
}

module.exports = function updateCredentials() {
	return new Promise(function(res, rej) {
		var dataPromise = readData();
		var credPromise = readCred();

		var postman = null;
		var cred = null;

		dataPromise.then(function(x){
			postman = x;
			let req = postman.item[1].request.body.raw.split("&");
			credPromise.then(function(cred) {
				let user = req[6].split("=")[0] + "=" + cred.username;
				let pass = req[7].split("=")[0] + "=" + cred.password;
				req[6] = user;
				req[7] = pass;
				postman.item[1].request.body.raw = req.join("&");
				fs.writeFile("SLCM.postman_collection.json", JSON.stringify(postman), function(err) {
					if(err) throw err;
				});
			});
		});
	});
}