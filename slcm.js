// https required to send requests to the server
const http = require("https");

// querystring is used to convert a query JSON to a string
const qs = require("querystring");

// node-html-parser parses the html to get useful data
const parser = require("node-html-parser");

// fs may be used later to write responses to file
// const fs = require("fs");

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

// DATA

let get_login_options = {
	"method": "GET",
	"hostname": "52.172.210.152",
	"path": "/loginForm.aspx",
	"headers": {
		"Host": "slcm.manipal.edu",
		"User-Agent": "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0",
		"Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
		"Accept-Language": "en-GB,en;q=0.5",
		"Accept-Encoding": "gzip, deflate, br",
		"Connection": "keep-alive",
		"Upgrade-Insecure-Requests": "1",
		"Pragma": "no-cache",
		"Cache-Control": "no-cache"
	}
};

let post_login_options = {
	"method": "POST",
	"hostname": "52.172.210.152",
	"path": "/loginForm.aspx",
	"headers": {
		"Host": "slcm.manipal.edu",
		"User-Agent": "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0",
		"Accept": "*/*",
		"Accept-Language": "en-GB,en;q=0.5",
		"Accept-Encoding": "gzip, deflate, br",
		"Referer": "https://slcm.manipal.edu/loginForm.aspx",
		"X-Requested-With": "XMLHttpRequest",
		"X-MicrosoftAjax": "Delta=true",
		"Cache-Control": "no-cache",
		"Content-Type": "application/x-www-form-urlencoded",
		"Content-Length": 487,
		"Cookie": null,
		"Connection": "keep-alive",
		"Pragma": "no-cache"
	}	
};

let get_data_options = {
	"method": "GET",
	"hostname": "52.172.210.152",
	"path": "/Academics.aspx",
	"headers": {
		"Host": "slcm.manipal.edu",
		"User-Agent": "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0",
		"Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
		"Accept-Language": "en-GB,en;q=0.5",
		"Accept-Encoding": "gzip, deflate, br",
		"Referer": "https://slcm.manipal.edu/studenthomepage.aspx",
		"Cookie": null,
		"Connection": "keep-alive",
		"Upgrade-Insecure-Requests": "1",
		"Pragma": "no-cache",
		"Cache-Control": "no-cache"
	}
};

// helper functions

const is_empty = str => !str || 0 === str.length;

const parse_html = body => (new Promise((resolve, reject) => {
	let html = null;
	try {
		html = parser.parse(body);
	}
	catch (err) {
		reject(err);
	}
	resolve(html);
}));

const fetch_courses = html => (new Promise((resolve, reject) => {
	let courses = {};
	let course_table = null;

	try {
		course_table = html.querySelector("#2").querySelector("tbody").removeWhitespace();
		for(let item in course_table.childNodes) {
			let code = course_table.childNodes[item].childNodes[0].rawText.split(" ").join("");
			let name = course_table.childNodes[item].childNodes[1].rawText;
			let sem = course_table.childNodes[item].childNodes[4].rawText;
			let cred = course_table.childNodes[item].childNodes[5].rawText;
			courses[code] = {
				"name" : name,
				"sem" : sem,
				"cred" : cred
			};
		}
		// console.log(courses);
	}
	catch (err) {
		reject(err);
	}
	resolve(courses);
}));

const fetch_attendance = html => (new Promise((resolve, reject) => {
	let attendance = {};
	let att_table = null;

	try {
		att_table = html.querySelector("#tblAttendancePercentage").removeWhitespace().childNodes[1].childNodes;
		for(let item in att_table) {
			let name = att_table[item].childNodes[2].rawText.split(" ").join("");
			attendance[name] = {
				"present" : att_table[item].childNodes[5].rawText,
				"total" : att_table[item].childNodes[4].rawText
			}
		}
		// console.log(attendance);
	}

	catch(err) {
		reject(err);
	}
	resolve(attendance);					
}));

const fetch_marks = html => (new Promise((resolve, reject) => {
	let marks = [];
	// console.log(marks);
	resolve(marks);
}));

const fetch_name = html => (new Promise((resolve, reject) => {
	let name = null;
	try {
		name = html.querySelector("#lblUserName").removeWhitespace().rawText;
		console.log(name);
	}
	catch(err) {
		reject(err);
	}
	resolve(name);
}));

const fetch_courses_attendance_name_marks = html => (new Promise((resolve, reject) => {
	let result = null;
	Promise.all([fetch_name(html), fetch_marks(html), fetch_attendance(html), fetch_courses(html)]).then(result => {
		resolve(result);
	}).catch(err => {
		console.log(err);
		reject(err);
	});	
}));

// REQUESTS

app.get("/", (request, response) => {
	response.send("api works");
});

app.get("/api", (request, response) => {
	response.send("send POST");
});

app.post("/api", (request, response) => {

	console.time("req");

	let username = request.body.username;
	let password = request.body.password;

	if(is_empty(username) || is_empty(password)) {
		response.json({
			error : true,
			error_reason : "details empty."
		});
		return;
	}

	// LOGIN BODY FOR THE POST

	let post_login_body = qs.stringify({ 
		__ASYNCPOST: 'true',
		__EVENTARGUMENT: '',
		__EVENTTARGET: '',
		__EVENTVALIDATION: '/wEdAAbdzkkY3m2QukSc6Qo1ZHjQdR78oILfrSzgm87C/a1IYZxpWckI3qdmfEJVCu2f5cEJlsYldsTO6iyyyy0NDvcAop4oRunf14dz2Zt2+QKDEIHFert2MhVDDgiZPfTqiMme8dYSy24aMNCGMYN2F8ckIbO3nw==',
		__VIEWSTATE: '/wEPDwULLTE4NTA1MzM2ODIPZBYCAgMPZBYCAgMPZBYCZg9kFgICAw8PFgIeB1Zpc2libGVoZGRkZQeElbA4UBZ/sIRqcKZDYpcgTP0=',
		__VIEWSTATEGENERATOR: '6ED0046F',
		btnLogin: 'Sign in',
		ScriptManager1: 'updpnl|btnLogin',
		txtpassword: password,
		txtUserid: username 
	});

	// INSERT TESTS HERE

	let get_login_req = http.request(get_login_options, res => {
		let chunks = [];
		let cookie = res.headers["set-cookie"][0];
		cookie = cookie.slice(0,cookie.indexOf(";"));

		post_login_options["headers"]["Cookie"] = cookie;
		get_data_options["headers"]["Cookie"] = cookie;

		res.on("data", chunk => chunks.push(chunk));
		res.on("end", () => {
			let body = Buffer.concat(chunks);
			
			let post_login_req = http.request(post_login_options, res => {
				let chunks = [];

				res.on("data", chunk => chunks.push(chunk));

				res.on("end", () => {
					let body = Buffer.concat(chunks);
					if(body.length > 100) {
						response.json({
							error : true,
							error_reason : "details incorrect."
						});
						return;
					}
				});

				let get_data_req = http.request(get_data_options, res => {
					let chunks = [];
					res.on("data", chunk => chunks.push(chunk));
					res.on("end", () => {
						let body = Buffer.concat(chunks).toString();
						
						parse_html(body)
						.then(html => fetch_courses_attendance_name_marks(html))
						.then(result => {
							response.json({
								"error" : false,
								"name" : result[0],
								"marks" : result[1],
								"att" : result[2],
								"courses" :  result[3]
							});
							console.timeEnd("req");
						});
					});
				});

				get_data_req.end();
			});

			post_login_req.write(post_login_body);
			post_login_req.end();
		});
	});

	get_login_req.end();
});
