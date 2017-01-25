var MongoClient = require('mongodb').MongoClient, assert = require('assert');

var start = Date.now();

MongoClient.connect("mongodb://localhost:27017/compare", {}, function (error, db) {
    var users = db.collection("users");

    var documents = [];
    var otherDocuments = [];

    for(var i = 0; i < 10000; i++) {
        documents.push({
            "name_first": "Joannis",
            "name_last": "Orlandos",
            "age": 20,
            "programmer": true,
            "likes": [
                "mongodb", "swift", "programming", "swimming"
            ]
        });

        otherDocuments.push({
            "name_first": "Harriebob",
            "name_last": "Narwhal",
            "age": 42,
            "programmer": false,
            "likes": [
                "facebook", "golfing", "cooking", "reading"
            ]
        });
    }

    var amount = 0;
    var amount2 = 0;

    users.insertMany(documents, function (error, result) {
        users.find({
            "age": {
                "$gt": 18
            }
        }).toArray(function (error, array) {
            amount += array.length;

            users.find({
                "name_first": {
                    "$eq": "Joannis"
                }
            }).toArray(function (error, array2) {
                amount2 += array2.length;

                users.remove({}, function(error, result2) {
                    var end = Date.now();

                    console.log((end - start) / 1000);

                    db.close();
                });
            });
        });
    });
});


// var express = require('express');
// var path = require('path');
// var favicon = require('serve-favicon');
// var logger = require('morgan');
// var cookieParser = require('cookie-parser');
// var bodyParser = require('body-parser');
//
// var index = require('./routes/index');
// var users = require('./routes/users');
//
// var app = express();
//
// // view engine setup
// app.set('views', path.join(__dirname, 'views'));
// app.set('view engine', 'jade');
//
// // uncomment after placing your favicon in /public
// //app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
// app.use(logger('dev'));
// app.use(bodyParser.json());
// app.use(bodyParser.urlencoded({ extended: false }));
// app.use(cookieParser());
// app.use(express.static(path.join(__dirname, 'public')));
//
// app.use('/', index);
// app.use('/users', users);
//
// // catch 404 and forward to error handler
// app.use(function(req, res, next) {
//   var err = new Error('Not Found');
//   err.status = 404;
//   next(err);
// });
//
// // error handler
// app.use(function(err, req, res, next) {
//   // set locals, only providing error in development
//   res.locals.message = err.message;
//   res.locals.error = req.app.get('env') === 'development' ? err : {};
//
//   // render the error page
//   res.status(err.status || 500);
//   res.render('error');
// });
//
// module.exports = app;
