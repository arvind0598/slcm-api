const fs = require("fs");
const updateData = require("./updateData");
const updateCredentials = require("./updateCredentials");

module.exports = function(app) {
	app.post("/setdata", function(req, res) {
		fs.writeFile("./src/cred.json", JSON.stringify(req.body), function(err) {
			if(err) throw err;
			console.log("wrote credentials to file.");
			let promise = updateCredentials();
			promise.then(function(x){
				res.send("Updated data for " + req.body.username);
			});
		});
		res.send("Hello, " + req.body.username);
	});

	app.post("/data/update", function(req, res) {
		let promise = updateData();
		promise.then(function(x) {
			res.send(x);
		});
	});

	app.post("/data/getMarks", function(req, res) {
		fs.readFile("./src/data/marks.json", function(err, data) {
			if(!err) res.type("json").send(data);
			else res.send(err.ToString());
		});
	});

	app.post("/data/getAttendance", function(req, res) {
		fs.readFile("./src/data/att.json", function(err, data) {
			if(!err) res.type("json").send(data);
			else res.send(err.ToString());
		});
	});

	app.post("/data/getCourses", function(req, res) {
		fs.readFile("./src/data/courses.json", function(err, data) {
			if(!err) res.type("json").send(data);
			else res.send(err.ToString());
		});
	});
}