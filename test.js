// https required to send requests to the server
const http = require("https");

// querystring is used to convert a query JSON to a string
const qs = require("querystring");

// node-html-parser parses the html to get useful data
const parser = require("node-html-parser");

// fs may be used later to write responses to file
const fs = require("fs");

// TO DO : use sqlite to store responses

let username = "";
let password = "";

// Express Server
const express = require("express");
const app = express();
const port = process.env.PORT || 8080;

app.use(express.urlencoded({
	extended : true
}));

app.listen(port, () => console.log("API is ready."));

// enabling CORS

app.all("/*", (req, res, next) => {
	res.header("Access-Control-Allow-Origin", "*");
	res.header("Access-Control-Allow-Headers", "X-Requested-With");
	next();
});

const is_empty = str => !str || 0 === str.length;

// REQUESTS

app.get("/", (request, response) => {
	response.send("api works");
});

app.get("/api", (request, response) => {
	console.time("req");

	let username = request.body.username;
	let password = request.body.password;

	let body = fs.readFileSync("test.html").toString('utf-8');
	console.log(body);
	const html = parser.parse(body);

	const course = html.querySelector("#2").querySelector("tbody").removeWhitespace();
	let course_list = {};


	for(let item in course.childNodes) {
		let code = course.childNodes[item].childNodes[0].rawText.split(" ").join("");
		let name = course.childNodes[item].childNodes[1].rawText;
		let sem = course.childNodes[item].childNodes[4].rawText;
		let cred = course.childNodes[item].childNodes[5].rawText;
		course_list[code] = {
			"name" : name,
			"sem" : sem,
			"cred" : cred
		};

	}

	let attendance = {};

	const att_table = html.querySelector("#tblAttendancePercentage").removeWhitespace().childNodes[1].childNodes;
	for(let item in att_table) {
		let name = att_table[item].childNodes[2].rawText.split(" ").join("");
		attendance[name] = {
			"present" : att_table[item].childNodes[5].rawText,
			"total" : att_table[item].childNodes[4].rawText
		}
	}

	let marks = {};

	response.json({
		"error" : false,
		"name" : html.querySelector("#lblUserName").removeWhitespace().rawText,
		"courses" : course_list,
		"marks" : marks,
		"att" : attendance
	});

	console.timeEnd("req");
});