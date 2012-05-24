
var InstagramConnect = function(auth_token, loc) {

  var instagram_host = "https://api.instagram.com/v1",
      request_headers = { 'Access-Control-Allow-Origin' : "*" },
      that = {};

  // Load instagram images from a specific instagram location ID
  that.getPhotos = function(instagram_id, callback) {
    if (typeof(instagram_id) != "string" && typeof(callback) != "function")
    {
      return false;
    }

    $.ajax({
      type     : "GET",
      dataType : "jsonp",
      url      : instagram_host + "/locations/" + instagram_id + "/media/recent",
      data     : { access_token : auth_token, },
      headers  : request_headers,
      success  : callback
    });
  }

  // Use the Foursquare venue ID to find an Instagram location 
  that.getVenueViaFoursquare = function(foursquare_id, callback) {
    if (typeof(foursquare_id) != "string" && typeof(callback) != "function")
    {
      return false;
    }

    $.ajax({
      type     : "GET",
      dataType : "jsonp",
      url      : instagram_host + "/locations/search",
      data     : {  
                   access_token     : auth_token,
                   foursquare_v2_id : foursquare_id
                 },
      headers  : request_headers,
      success  : callback
    });

    return true;
  }

  return that;
}
