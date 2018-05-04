const express = require("express");
const http = require("http");
const url = require("url");
const bodyParser = require("body-parser");

const app = express();
const port = 8080;

app.use(bodyParser.urlencoded({ 
	extended: true 
}));

require("./routes")(app);

app.listen(port, function(){
	console.log("Live on " + port);
});
