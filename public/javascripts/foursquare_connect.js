
var FoursquareConnect = function(auth_token, loc) {

  var foursquare_host = "https://api.foursquare.com/v2",
      date_str = (new Date()).format("yyyymmdd"),
      that = {};

  // Get all venues near a given latitude and longitude
  that.getNearbyVenues = function(params) {
    if (typeof(params) != "object" || typeof(params['query']) == "undefined")
    {
      return false;
    }

    var request_params = {
      query       : params['query'],
      ll          : loc.lat() + "," + loc.lng(),
      radius      : 500,
      oauth_token : auth_token,
      v           : date_str
    };
     
    // Merge possible options
    $.each(['ne', 'sw', 'radius'], function(i, k) {
      if (params.hasOwnProperty(k)) {
        request_params[k] = params[k];
      }
    });

    var ajax_params = {
      url     : foursquare_host + "/venues/search",
      data    : request_params
    }

    if (typeof(params['success']) == 'function') { 
      ajax_params['success'] = params['success']
    }

    $.ajax(ajax_params);
    
    return true;
  }

  // Get all tips for a venue
  that.getVenueTips = function(venue_id, callback) {
    if (typeof(venue_id) != "string" && typeof(callback) != "function")
    {
      return false;
    }

    // Get all venue and checkin photos
    $.ajax({
      url : foursquare_host + "/venues/" + venue_id + "/tips",
      data : {
        group       : "venue",
        oauth_token : auth_token,
        v           : date_str
      },
      success : callback
    });

    return true;
  }

  // Get all photos for a venue
  that.getVenueImages = function(venue_id, callback) {
    if (typeof(venue_id) != "string" && typeof(callback) != "function")
    {
      return false;
    }

    // Get all venue and checkin photos
    $.ajax({
      url : foursquare + "/venues/" + venue_id + "/photos",
      data : {
        group       : "venue",
        oauth_token : auth_token,
        v           : date_str
      },
      success : callback
    });

    return true;
  }

  return that;
}

