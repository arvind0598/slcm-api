const mysql = require("mysql");

const db = mysql.createConnection({
    host: "localhost",
    user: "root",
    database: "slcm-api"
});

module.exports = function(key, task) {
    return new Promise(function(resolve, reject){
        let sql = "SELECT api_made from clients WHERE api_made = '" + key + "'";
        db.query(sql, function(err, res) {
            if(err) reject(err);
            if(res.length != 1) reject();
            else {
                let log = "INSERT INTO logs (api, task) VALUES ('" + key + "', '" + task + "')";
                db.query(log, function(err, res) {
                    if(err) reject(err);
                    resolve();
                });
            }
        });
    });
}