class App.Emergency extends Spine.Model
  @configure "Emergency", "lat", "lng", "location_type", "input_address",
    "formatted_address"
  
  @extend Spine.Model.Ajax
  @url: "/emergencies"

  @fromStreetAddress: (street) ->
    address = street + ", Cape Town, South Africa"
    input_address = address
    geocoder = new google.maps.Geocoder()
    geocoder.geocode {'address': address}, (results, status) =>
      if (status == google.maps.GeocoderStatus.OK)
        result = results[0]
        App.Emergency.create {
          'input_address': input_address
          'formatted_address': result.formatted_address
          'lat': result.geometry.location.lat()
          'lng': result.geometry.location.lng()
          'location_type': result.geometry.location_type   
        }
      else
        console.log "geocode error:"
        console.log status

  constructor: ->
    super
