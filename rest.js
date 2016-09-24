var express = require('express');
var expressRest = require('express-rest');
var randomWords = require('random-words');
var authHeader = require('auth-header');

var allowedUsername = "admin";
var allowedPassword = "admin";

// CORS middleware
var allowCrossDomain = function(req, res, next) {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE');
  res.header('Access-Control-Allow-Headers', 'authorization, Access-Control-Allow-Headers, Origin, Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers');
  next();
}

var app = express();
app.use(allowCrossDomain);
var rest = expressRest(app);

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
  var isSoup = false
  var description = randomWords({
    min: 3,
    max: 10,
    join: ' '
  });

  var lunchBaseId = id - BASE_LUNCH;
  var lunchNum = lunchBaseId % 7;
  var dayNum = Math.floor(lunchBaseId / 7);

  // First 2 lunches are always soups
  if (lunchNum <= 1) {
    isSoup = true;
  }

  var date = lastRequestedDate.slice();
  date[2] = date[2] + dayNum;

  return {
    "id": id,
    "soup": isSoup,
    "date": date,
    "description": description
  };
}

rest.get('/user', function(req, rest) {
  // Something messed up. 
  function fail() {
    rest.unauthorized();
  }

  // Get authorization header. 
  var auth = authHeader.parse(req.get('authorization'));

  // No basic authentication provided. 
  if (auth.scheme !== 'Basic') {
    return fail();
  }

  // Get the basic auth component. 
  var auth = Buffer(auth.token, 'base64').toString().split(':', 2);

  // Verify authentication. 
  if (auth[0] == allowedUsername && auth[1] == allowedPassword) {
    rest.ok({
      id: 1,
      user: {
        id: 76,
        role: "*"
      }
    });
  } else {
    fail();
  }
});

rest.post('/logout', function(req, rest) {
  rest.ok({
    success: true
  });
});

rest.get('/lunches/id/:id', function(req, rest) {
  rest.ok(generateLunch(req.params.id));
});

rest.get('/orders/date/:date/user/:user', function(req, rest) {
  var user = req.params.user;
  lastRequestedDate = parseDate(req.params.date);

  rest.ok([{
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
    "changeable": false
  }, {
    "user": user,
    "lunch": 3015,
    "ordered": true,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3016,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3017,
    "ordered": true,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3018,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3019,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3020,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3021,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3022,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3023,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3024,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3025,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3026,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3027,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3028,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3029,
    "ordered": true,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3030,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3031,
    "ordered": true,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3032,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3033,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3034,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3035,
    "ordered": true,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3036,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3037,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3038,
    "ordered": true,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3039,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3040,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3041,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3042,
    "ordered": true,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3043,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3044,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3045,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3046,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3047,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3048,
    "ordered": true,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3049,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3050,
    "ordered": true,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3051,
    "ordered": true,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3052,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3053,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3054,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3055,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3063,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3064,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3065,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3066,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3067,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3068,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3069,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3056,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3057,
    "ordered": true,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3058,
    "ordered": true,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3059,
    "ordered": true,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3060,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3061,
    "ordered": false,
    "changeable": false
  }, {
    "user": user,
    "lunch": 3062,
    "ordered": false,
    "changeable": false
  }]);
});

console.log("Server started");
app.listen(3000);