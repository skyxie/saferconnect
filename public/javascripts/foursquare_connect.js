
var FoursquareConnect = function(auth_token, loc) {

  var date_str = (new Date()).format("yyyymmdd"),
      venues = {}, photos = {},
      that = {};

  that.getVenues = function() { return venues; }
  that.getPhotos = function() { return photos; }

  // Get all venues near a given latitude and longitude
  that.getNearbyVenues = function(params) {
    if (typeof(params) != "object" || typeof(params['query']) == "undefined")
    {
      return false;
    }

    request_params = {
      query       : params['query'],
      ll          : loc.lat() + "," + loc.lng(),
      radius      : 100,
      oauth_token : auth_token,
      v           : date_str
    };
     
    // Merge possible options
    $.each(['ne', 'sw', 'radius'], function(i, k) {
      if (params.hasOwnProperty(k)) {
        data[k] = params[k];
      }
    });

    // Request nearby venues
    $.ajax({
      url     : "https://api.foursquare.com/v2/venues/search",
      data    : request_params,
      success : function(data, textStatus, jqXHR) { 
        $.each(data.response.venues, function(index, venue) { venues[venue.id] = venue; });
      }
    });

    return true;
  }

  // Get all photos for a venue
  that.getVenueImages = function(params) {
    if (typeof(params) == "undefined" || typeof(params['venue_id']) == "undefined")
    {
      return false;
    }

    // Get all venue and checkin photos
    $.each(["venue", "checkin"], function(i, group) {
      $.ajax({
        url : "https://api.foursquare.com/v2/venues/" + venue_id + "/photos",
        data : {
          group       : group,
          oauth_token : auth_token,
          v           : date_str
        },
        success : function(data) {
          $.each(data.response.photos.items, function(i, photo) { photos[photo.id] = photo; });
        }
      });
    });

    return true;
  }

  return that;
}

