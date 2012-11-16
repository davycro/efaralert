class App.Emergency extends Spine.Model
  @configure "Emergency", "lat", "lng", "location_type", "input_address",
    "formatted_address", "created_at", "created_at"
  
  @extend Spine.Model.Ajax
  @url: "/emergencies"

  @fromStreetAddress: (street, callbacks) ->
    address = street + ", Cape Town, South Africa"
    input_address = address
    geocoder = new google.maps.Geocoder()
    geocoder.geocode {'address': address}, (results, status) =>
      if (status == google.maps.GeocoderStatus.OK)
        result = results[0]
        if result.geometry.location_type != google.maps.GeocoderLocationType.APPROXIMATE
          em = App.Emergency.create {
            'input_address': input_address
            'formatted_address': result.formatted_address
            'lat': result.geometry.location.lat()
            'lng': result.geometry.location.lng()
            'location_type': result.geometry.location_type   
          }
          callbacks.success(em)
        else
          callbacks.failed('Invalid address please try again or press ESC to cancel')
      else
        console.log(status)
        callbacks.failed('Geocoder error')

  constructor: ->
    super
