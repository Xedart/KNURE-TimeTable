//
//  NotificationSender.js
//  NureTimeTableBackend
//
//  Created by Shkil Artur on 9/06/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

	//MARK: - Modules:

var apn = require('apn');

function sendNotificationsTo(recepients, message) {

	var options = {
		cert: __dirname + '/Certificates/cert.pem',
		key: __dirname + '/Certificates/key.pem',
		production: false
 	};

 	 var apnConnection = new apn.Connection(options);

 	 //TODO: perform all checks:

 	 //

 	  //Configure note:
 	  var note = new apn.Notification();
	  note.expiry = Math.floor(Date.now() / 1000) + 3600; // Expires 1 hour from now.
	  note.sound = "ping.aiff";
	  note.alert = message;
	  note.payload = {'messageFrom': 'Caroline'};


	  //Send push notifications:
	  apnConnection.pushNotification(note, recepients);
}

module.exports.sendNotificationsTo = sendNotificationsTo;









