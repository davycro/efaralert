initialize = ->
  myOptions =
    center: new google.maps.LatLng -34.397, 150.644
    zoom: 8,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  map = new google.maps.Map $('#map_canvas')[0], myOptions

$ ->
  # initialize()
  # load all efars
  # efars = 
  # loop through every efar and check for a lat long
  # those w/o lat longs need to be updated