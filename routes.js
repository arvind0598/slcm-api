/************************************************************
Contains all the routes that are supported by the app.
************************************************************/

const fs = require("fs");
const updateData = require("./updateData");
const updateCredentials = require("./updateCredentials");
const registerClient = require("./src/mysql/register.js");
const verifyKey = require("./src/mysql/verifyKey.js");

module.exports = function(app) {

    app.get("/", function(req, res) {
        res.send("Server running.");
    });

    app.get("/registerClient", function(req, res) {
        let promise = registerClient();
        promise.then(function(x){
            res.send(x);
        }, function(x){
            res.send("failure");
        });
    });

    /************************************************************
    Expects "key", "username" and "password" via a POST request.
    It writes these to "cred.json" using updateCredentials().
    ************************************************************/

    app.post("/setData", function(req, res) {
        let checkValid = verifyKey(req.body.key, "setData");
        checkValid.then(function(){
            console.log("validated key " + req.body.key);
            fs.writeFile("./src/cred.json", JSON.stringify(req.body), function(err) {
                if (err) throw err;
                console.log("wrote credentials to file.");
                let promise = updateCredentials();
                promise.then(function(x) {
                    res.send("Updated data for " + req.body.username);
                }, function(x){
                    res.send("failure");
                    throw x;
                });
            });
            res.send("Hello, " + req.body.username);
        }, function(){
            console.log("invalid key " + req.body.key);
            res.send("invalid key");
        });
    });

    /************************************************************
    Updates the data by running the collection again.
    ************************************************************/

    app.post("/updateData", function(req, res) {
        let checkValid = verifyKey(req.body.key, "updateData");
        checkValid.then(function(){
            console.log("validated key " + req.body.key);
            let promise = updateData();
            promise.then(function(x) {
                res.send("data updated");
            }, function(x){
                res.send("failure");
                throw x;
            });
        }, function(){
            console.log("invalid key " + req.body.key);
            res.send("invalid key");
        });
    });

    /****************************************
    The following three routes return JSONs.
    ****************************************/

    app.post("/getMarks", function(req, res) {
        let checkValid = verifyKey(req.body.key, "getMarks");
        checkValid.then(function(){
            console.log("validated key " + req.body.key);
            fs.readFile("./src/data/marks.json", function(err, data) {
                if (!err) res.type("json").send(data);
                else res.send(err.ToString());
            });
        }, function(){
            console.log("invalid key " + req.body.key);
            res.send("invalid key");
        });
    });

    app.post("/getAttendance", function(req, res) {
        let checkValid = verifyKey(req.body.key, "getAttendance");
        checkValid.then(function(){
            console.log("validated key " + req.body.key);
            fs.readFile("./src/data/att.json", function(err, data) {
                if (!err) res.type("json").send(data);
                else res.send(err.ToString());
            });
        }, function(){
            console.log("invalid key " + req.body.key);
            res.send("invalid key");
        });
    });

    app.post("/getCourses", function(req, res) {
        let checkValid = verifyKey(req.body.key, "getCourses");
        checkValid.then(function(){
            console.log("validated key " + req.body.key);
            fs.readFile("./src/data/courses.json", function(err, data) {
                if (!err) res.type("json").send(data);
                else res.send(err.ToString());
            });
        }, function(){
            console.log("invalid key " + req.body.key);
            res.send("invalid key");
        });
    });
}