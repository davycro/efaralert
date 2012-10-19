class App.Efar extends Spine.Model
  @configure "Efar", "address", "suburb", "postal_code", "city", "country", "lat", "long", "invalid_address", "formatted_address", "location_type"
  @extend Spine.Model.Ajax

  constructor: ->
    super
    if @location_type=="NO_LOCATION"
      @geocode()
    @gmarker = new google.maps.Marker(
      position: new google.maps.LatLng(@lat, @long)
      icon: '/assets/firstaid.png'
    )

  setMap: (map) -> @gmarker.setMap(map)

  geocode: ->
    @gcoder = new google.maps.Geocoder()
    @gcoder.geocode({'address': @geocodeSearchAddress()}, (results, status) => @geocodeResponse(results, status))

  geocodeSearchAddress: ->
    if @geocode_search_address
      return @geocode_search_address
    location = "#{@address}"
    if @suburb
      location += ", #{@suburb} #{@postal_code}"
    else if @postal_code
      location += ", #{@postal_code}"
    location += ", #{@city} #{@country}"
    @geocode_search_address = location
    return @geocode_search_address
  
  geocodeResponse: (results, status) ->
    console.log(status)
    if status=="ZERO_RESULTS"
      console.log("Address invalid")
      @location_type="BAD_LOCATION"
      @save()
    else
      result = results[0]
      @formatted_address = result.formatted_address
      @lat = result.geometry.location.lat()
      @long = result.geometry.location.lng()
      @location_type = result.geometry.location_type
      @save()
    # console.log({lat: @lat, long: @long, location_type: @location_type, formatted_address: @formatted_address, search_address: @geocodeSearchAddress()})



