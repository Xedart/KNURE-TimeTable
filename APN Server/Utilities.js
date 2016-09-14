//
//  Utilities.js
//  NureTimeTableBackend
//
//  Created by Shkil Artur on 9/02/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

	// MARK: - Modules:

var mongoose = require('mongoose');
var iconv    = require('iconv-lite');
var request  = require('request');

	//MARK: - Set Database connection://

function setDBConnection() {

	var url = '127.0.0.1:27017/' + process.env.OPENSHIFT_APP_NAME;

	var options = {
		user: 'hiden',
        pass: 'hiden'
	}

// if OPENSHIFT env variables are present, use the available connection info:
if (process.env.OPENSHIFT_MONGODB_DB_URL) {
    url = process.env.OPENSHIFT_MONGODB_DB_URL +
    process.env.OPENSHIFT_APP_NAME;
}

// Connect to mongodb
var connect = function () {
    mongoose.connect(url, options);
};
connect();

var db = mongoose.connection;

db.on('error', function(error){
    console.log("Error loading the db - "+ error);
});

db.on('disconnected', connect);

}

	//MARK: - Define shcedule schema:

var Schema = mongoose.Schema;

var Schedule = new Schema({
	scheduleID: String,
	scheduleTitle: String,
	recepients: [String],
	scheduleObject: String
});

var scheduleModel = mongoose.model('Schedule', Schedule);

	//MARK: - Utilities object:

function encodeToWin1251(buffer) {
	var encodedString = iconv.decode(buffer, 'windows-1251');
	return encodedString;
}

var Tools = {

	responceWithError: function(responce) {
		responce.setHeader('Content-Type', 'application/json');
        responce.send(JSON.stringify({ result: 'error' }));
	},

	responceWithSuccess: function(responce) {
		responce.setHeader('Content-Type', 'application/json');
		responce.json({result: 'success'});
	},

	getIndexOfElementIn: function(array, title) {
		for (var i = 0, len = array.length; i < len; i++) {
			if (array[i] === title) {
				return i;
			}
		}
		return -1;
	},

	loadSclhedule: function(identifier, callback) {

		var schedule;

		//load schedule from the cist api:
		//var url = 'http://cist.nure.ua/ias/app/tt/' + 'P_API_EVEN_JSON?' + 'timetable_id=' + identifier;
		var url = 'http://xedartbackend-xedart.rhcloud.com/getSchedule';
		var requestOptions = {
			uri: url,
			encoding: null
		}
		request(requestOptions, function (error, response, data) {

			if(error) {
				callback(error, null);
				return;
			}

			var encodedSchedule = encodeToWin1251(data);

			callback(null, encodedSchedule);
		});
	}
};

	//MARK: - Exporting:

module.exports.scheduleModel   = scheduleModel;
module.exports.setDBConnection = setDBConnection;
module.exports.tools = Tools;











