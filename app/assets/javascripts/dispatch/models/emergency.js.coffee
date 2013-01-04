class App.Emergency extends Spine.Model
  @configure "Emergency", "lat", "lng", "location_type", "input_address",
    "formatted_address", "created_at_pretty", "category",
    "num_dispatch_messages", "num_en_route_dispatch_messages",
    "num_on_scene_dispatch_messages", "num_sent_dispatch_messages", 
    "num_failed_dispatch_messages"
  
  @extend Spine.Model.Ajax
  @url: "/emergencies"

  @fromStreetAddress: (street, category, callbacks) ->
    input_category = category
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
            'category' : input_category   
          }
          callbacks.success(em)
        else
          callbacks.failed('Invalid address please try again or press ESC to cancel')
      else
        console.log(status)
        callbacks.failed('Geocoder error')

  # only fetch records that are recent and need to be polled 
  @fetchForPoll: ->
    params = { 'data' : { 'for_poll': true } }
    @fetch(params)

  @createFromMarker: (marker, input_address, input_category, callbacks) ->
    geocoder = new google.maps.Geocoder()
    geocoder.geocode {'latLng':marker.getPosition()}, (results, status) =>
      if (status == google.maps.GeocoderStatus.OK)
        result = results[0]
        em = App.Emergency.create {
          'input_address': input_address
          'category': input_category
          'formatted_address': result.formatted_address
          'lat': result.geometry.location.lat()
          'lng': result.geometry.location.lng()
          'location_type': result.geometry.location_type
        }, callbacks
        console.log(callbacks)      



  constructor: ->
    super
