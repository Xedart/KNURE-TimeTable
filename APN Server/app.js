//
//  Main.js
//  NureTimeTableBackend
//
//  Created by Shkil Artur on 9/05/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
////


  //MARK: - Modules:

const http         = require('http'),
      fs           = require('fs'),
      path         = require('path'),
      contentTypes = require('./utils/content-types'),
      sysInfo      = require('./utils/sys-info'),
      env          = process.env;


var express      = require('express');
var bodyParser   = require('body-parser');
var utilities    = require('./Utilities.js');
var observer     = require('./Obsever.js');


  //MARK: - Configuration:

var app = express();

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

utilities.setDBConnection();
var scheduleModel = utilities.scheduleModel;

//start the observer loop:


setInterval(function() {
  observer.startObserver(scheduleModel);
}, 1000 * 60); ////


var apiRoutes = express.Router();

  //MARK: - API methods:

  apiRoutes.get('/getDB', function(req, res) {
    scheduleModel.find(function(error, schedules) {
        utilities.tools.responceWithSuccess(responce);
        console.log(String(schedules));
    })
  })

apiRoutes.get('/removeRecepient', function(request, responce) {

  var scheduleID = request.query.scheduleID;
  var deviceToken = request.query.deviceToken;

  if(!scheduleID || !deviceToken) {
    utilities.tools.responceWithError(responce);
    return;
  }

  scheduleModel.findOne({scheduleID: scheduleID}, function(error, schedule) {

    if(error) {
      utilities.tools.responceWithError(responce);
      return;
    }

    if(!schedule) {
      utilities.tools.responceWithSuccess(responce);
      return;
    }

    if(schedule.recepients.length <= 0) {

      //remove schedule:
      scheduleModel.remove({scheduleID: scheduleID}, function(error) {

        if(error) {
          utilities.tools.responceWithError(responce);
          return;
        } else {
          utilities.tools.responceWithSuccess(responce);
          return;
        }

      });
    }

    var index = 0;
    index = utilities.tools.getIndexOfElementIn(schedule.recepients, deviceToken);

    if(index > -1) {

      schedule.recepients.splice(index, 1);

      if(schedule.recepients.length <= 0) {

        //remove schedule:
        scheduleModel.remove({scheduleID: scheduleID}, function(error) {

          if(error) {
            utilities.tools.responceWithError(responce);
            return;
          } else {
            utilities.tools.responceWithSuccess(responce);
            return;
          }

        });
      } else {
        schedule.save(function(error) {

          if(error) {
            utilities.tools.responceWithError(responce);
            return;
          } else {
            utilities.tools.responceWithSuccess(responce);
            return;
          }
        });
      }
    } else {
      utilities.tools.responceWithSuccess(responce);
      return;
    }

  });
});


apiRoutes.post('/addRecepient', function(request, responce) {

  var scheduleID = request.body.scheduleID;
  var deviceToken = request.body.deviceToken;
  var scheduleTitle = request.body.scheduleTitle;

  if(!scheduleID || !deviceToken || !scheduleTitle) {
    utilities.tools.responceWithError(responce);
    return;
  }

  scheduleModel.findOne({scheduleID: scheduleID}, function(error, schedule) {

    if(error) {
      utilities.tools.responceWithError(responce);
      return;
    }

    if(!schedule) {

      //download schedule from cist api and save:
      utilities.tools.loadSclhedule(scheduleID, function(error, schedule) {

        if(error) {
          utilities.tools.responceWithError(responce);
          return;
        }

        var newScheduleObject = new scheduleModel({
          scheduleID: scheduleID,
          scheduleTitle: scheduleTitle,
          recepients: [String(deviceToken)],
          scheduleObject: schedule
        });

        newScheduleObject.save(function(error) {

          if(error) {
            utilities.tools.responceWithError(responce);
            return;
          } else {
            utilities.tools.responceWithSuccess(responce);
            return;
          }
        });
      });

    } else {

      //add new recepient:
      schedule.recepients.push(String(deviceToken));
      schedule.save(function(error) {
        if(error) {
          utilities.tools.responceWithError(responce);
          return;
        } else {
          utilities.tools.responceWithSuccess(responce);
          return;
        }
      });
    }
  });
});



apiRoutes.get('/health', function(req, res) {
    res.writeHead(200);
    res.end();
});

apiRoutes.get('/ex', function(req, res) {
  console.log('HERE');
  utilities.tools.responceWithSuccess(res);
  return;
})



app.use('',apiRoutes);

//
var server = app.listen(env.NODE_PORT || 3000, env.NODE_IP || 'localhost', function () {
console.log(`Application worker ${process.pid} started...`);
  var host = server.address().address
  var port = server.address().port
});









