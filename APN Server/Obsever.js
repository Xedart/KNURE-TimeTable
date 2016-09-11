//
//  Obseerver.js
//  NureTimeTableBackend
//
//  Created by Shkil Artur on 9/03/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
////

	//MARK: - Modules:

var request   = require('request');
var utilities = require('./Utilities.js');
var sender    = require('./NotificationSender.js');
var _ 		  = require('underscore');
var moment 	  = require('moment');

	//MARK: - Observer loop:

function startObserver(dataModel) {

	dataModel.find(function(error, schedules) { 

		if(error) {
			return;
		}

		if(!schedules || schedules.length <= 0) {
			return;
		}

		//iterate over schedules array and compare each scheduleObject with loaded schedule.
		//if distinctions will be detected, call to notification block.
		for(var index = 0; index < schedules.length; index++) {

			utilities.tools.loadSclhedule(schedules[index].scheduleID, (function() {

				var fixedIndex = index;

				// return the callback:
				return function(error, schedule) {

					if(error) {
						return;
					}

					//compare schedules data:
					if(schedules[fixedIndex].scheduleObject !== schedule) {

						searchDistionctionInSchedules(schedules[fixedIndex], schedule);

						schedules[fixedIndex].scheduleObject = schedule;

						schedules[fixedIndex].save(function(error) {
							if(error) {
								return;
							}	
						});
					} 
				}
			})() );
		}
	});
}

function getDateOfChange(oldScheduleObject, newScheduleObject) {

	var oldEvents = oldScheduleObject.events;
	var newEvents = newScheduleObject.events;

	if(oldEvents.length == 0 || newEvents.length == 0) {
		throw 'Error 1';
	}

	for(var i = 0; i < oldEvents.length; i++) {

		if(!newEvents[i]) {
			throw 'Error 2';
		}

		if(!(_.isEqual(oldEvents[i], newEvents[i]))) {

			//if event was remove or changed, get date change from old schedule:
			if(oldEvents.length >= newEvents) {
				return oldEvents[i].start_time
			} 

			//if event was added, get change date from new schedule:
			return newEvents[i].start_time;
		}

	}
	throw 'Error 3';
}

function searchDistionctionInSchedules(oldSchedule, newScheduleObject) {

	var oldParsedSchedule;
	var newParsedSchedule;

	try {
		oldParsedSchedule = JSON.parse(oldSchedule.scheduleObject);
		newParsedSchedule = JSON.parse(newScheduleObject);
		
		var dateOfCgange = getDateOfChange(oldParsedSchedule, newParsedSchedule);

		var day = moment.unix(dateOfCgange);

		var message = oldSchedule.scheduleTitle + ': расписание на ' + day.format('D.MM.YY') + ' было изменено';
		sender.sendNotificationsTo(oldSchedule.recepients, message);

	} catch(error) {

		//if schedule can't be parsed and thus date of cganging 
		//can't be defined, just notify about changes using following pattern
		// [Group]: расписание было изменено
		var message = oldSchedule.scheduleTitle + ': расписание было изменено';
		sender.sendNotificationsTo(oldSchedule.recepients, message);
	}

}

module.exports.startObserver = startObserver;

















