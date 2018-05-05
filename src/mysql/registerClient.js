const mysql = require("mysql");
const uuid = require("uuid/v4")

const db = mysql.createConnection({
    host: "localhost",
    user: "root",
    database: "slcm-api"
});

db.connect(function(err) {
    if(err) throw err;
    console.log("connected.");
});

module.exports = function() {
    return new Promise(function(resolve, reject){
        let key = uuid();
        let sql = "INSERT INTO clients (api_made) VALUES ('" + key + "');";
        let query = db.query(sql, function(err, res) {
            if(err) reject(err);
            resolve(key);
        });
    });
}