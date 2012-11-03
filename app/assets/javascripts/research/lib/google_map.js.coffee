$ = jQuery.sub()

class App.GoogleMap

  @render:(el)->
    options = {
      zoom: 13
      center: new google.maps.LatLng(-33.9838663, 18.5552215)
      mapTypeId: google.maps.MapTypeId.ROADMAP
      streetViewControl: false
      mapTypeControl: false
    }
    console.log(el)
    @map = new google.maps.Map(el[0], options) 
