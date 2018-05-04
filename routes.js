/************************************************************
Contains all the routes that are supported by the app.
************************************************************/

const fs = require("fs");
const updateData = require("./updateData");
const updateCredentials = require("./updateCredentials");

module.exports = function(app) {

    /************************************************************
    Expects "username" and "password" via a POST request.
    It writes these to "cred.json" using updateCredentials().
    ************************************************************/

    app.post("/setData", function(req, res) {
        fs.writeFile("./src/cred.json", JSON.stringify(req.body), function(err) {
            if (err) throw err;
            console.log("wrote credentials to file.");
            let promise = updateCredentials();
            promise.then(function(x) {
                res.send("Updated data for " + req.body.username);
            });
        });
        res.send("Hello, " + req.body.username);
    });

    /************************************************************
    Updates the data by running the collection again.
    ************************************************************/

    app.post("/updateData", function(req, res) {
        let promise = updateData();
        promise.then(function(x) {
            res.send(x);
        });
    });

    /****************************************
    The following three routes return JSONs.
    ****************************************/

    app.post("/getMarks", function(req, res) {
        fs.readFile("./src/data/marks.json", function(err, data) {
            if (!err) res.type("json").send(data);
            else res.send(err.ToString());
        });
    });

    app.post("/getAttendance", function(req, res) {
        fs.readFile("./src/data/att.json", function(err, data) {
            if (!err) res.type("json").send(data);
            else res.send(err.ToString());
        });
    });

    app.post("/getCourses", function(req, res) {
        fs.readFile("./src/data/courses.json", function(err, data) {
            if (!err) res.type("json").send(data);
            else res.send(err.ToString());
        });
    });
}