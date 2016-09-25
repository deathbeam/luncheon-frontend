var express = require('express');
var randomWords = require('random-words');
var authHeader = require('auth-header');
var bodyParser = require('body-parser');

var app = express();
var allowedUsername = "admin";
var allowedPassword = "admin";
var loggedIn = false;

// Middleware that will allow us to actually do something
var allowCrossDomain = function(req, res, next) {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE');
  res.header('Access-Control-Allow-Headers', 'authorization, Access-Control-Allow-Headers, Origin, Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers');
  next();
}

// Authorization middleware
var authorization = function(req, res, next) {
  // Something messed up. 
  function fail() {
    res.set('WWW-Authenticate', authHeader.format('Basic'));
    res.status(401).send();
  }

  // Get authorization header. 
  var header = req.get('authorization');

  if (header == null) {
    // We are already logged in and we are not trying to relog
    if (loggedIn) {
      return next();
    } else {
      return fail();
    }
  }

  var auth = authHeader.parse(header);

  // No basic authentication provided. 
  if (auth.scheme !== 'Basic') {
    return fail();
  }

  // Log authorization events
  console.log("Authorization");
  console.log(auth);

  // Get the basic auth component. 
  var auth = Buffer(auth.token, 'base64').toString().split(':', 2);

  // Verify authentication. 
  if (auth[0] == allowedUsername && auth[1] == allowedPassword) {
    // Preserve our session in very lazy and ugly way
    loggedIn = true;
    next();
  } else {
    fail();
  }
};

app.use(allowCrossDomain);
app.use(bodyParser.urlencoded({
  extended: true
}));
app.use(bodyParser.json());

// Parse date string from REST to year, month, day array
function parseDate(date) {
  return [
    date.substring(0, 4), // Year
    date.substring(5, 6), // Month
    date.substring(6, 7) // Day
  ];
}

// Function for generating sane random lunches
var BASE_LUNCH = 3000;
var lastRequestedDate = [0, 0, 0];
var lastDayNum = 0;

function generateLunch(id) {
  var lunchBaseId = id - BASE_LUNCH;
  var lunchNum = lunchBaseId % 7; // Reset lunch number after 7 entries (2 soups, 5 meals)
  var dayNum = Math.floor(lunchBaseId / 7); // Increase day number after 7 entries
  var date = lastRequestedDate.slice();
  date[2] = date[2] + dayNum;

  return {
    "id": id,
    "soup": lunchNum <= 1, // First 2 lunches are always soups
    "date": date,
    "description": randomWords({
      min: 3,
      max: 15,
      join: ' '
    })
  };
}

app.get('/authenticate', authorization, function(req, res) {
  console.log("GET /authenticate");
  console.log(req.get('authorization'));

  res.json({
    "id": 76,
    "pid": "533",
    "barCode": "0003369000",
    "firstName": "Ľubomír",
    "lastName": "Repiský",
    "relation": "EMPLOYEE",
    "longName": "Ľubomír Repiský",
    "authorities": [{
      name: "user"
    }, {
      name: "admin"
    }]
  });
});

app.post('/logout', authorization, function(req, res) {
  console.log("GET /logout");
  // "Destroy" our session in very lazy and ugly way
  loggedIn = false;

  res.json({
    success: true
  });
});

app.post('/orders/orders', authorization, function(req, res) {
  console.log('POST /orders/orders');
  console.log(req.body);

  res.json({
    success: true
  });
});

app.get('/lunches/id/:id', authorization, function(req, res) {
  console.log("GET /lunches/id/" + req.params.id);
  res.json(generateLunch(req.params.id));
});

app.get('/orders/date/:date/user/:user', authorization, function(req, res) {
  var user = req.params.user;
  lastRequestedDate = parseDate(req.params.date);
  console.log("GET /orders/date/" + req.params.date + "/user/" + user);

  res.json([{
    "user": user,
    "lunch": 3000,
    "ordered": true,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3001,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3002,
    "ordered": true,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3003,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3004,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3005,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3006,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3007,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3008,
    "ordered": true,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3009,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3010,
    "ordered": true,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3011,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3012,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3013,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3014,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3015,
    "ordered": true,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3016,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3017,
    "ordered": true,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3018,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3019,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3020,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3021,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3022,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3023,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3024,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3025,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3026,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3027,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3028,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3029,
    "ordered": true,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3030,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3031,
    "ordered": true,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3032,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3033,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3034,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3035,
    "ordered": true,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3036,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3037,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3038,
    "ordered": true,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3039,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3040,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3041,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3042,
    "ordered": true,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3043,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3044,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3045,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3046,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3047,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3048,
    "ordered": true,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3049,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3050,
    "ordered": true,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3051,
    "ordered": true,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3052,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3053,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3054,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3055,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3063,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3064,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3065,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3066,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3067,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3068,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3069,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3056,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3057,
    "ordered": true,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3058,
    "ordered": true,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3059,
    "ordered": true,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3060,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3061,
    "ordered": false,
    "changeable": true
  }, {
    "user": user,
    "lunch": 3062,
    "ordered": false,
    "changeable": true
  }]);
});

// Start our application
console.log("Server started");
app.listen(3000);