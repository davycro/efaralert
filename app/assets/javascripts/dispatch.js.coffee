#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require spine/spine
#= require spine/ajax
#= require jquery.timeago
#= require_tree ./lib
#= require_self
#= require_tree ./dispatch/models
#= require_tree ./dispatch/lib
#= require_tree ./dispatch/views

class ShowController
  constructor:->
    @dispatchMessages = $('[data-type=dispatch-messages]')
    @notice = $('.notice', @dispatchMessages)
    @emergencyId = $(@dispatchMessages).data('emergency-id')
    App.DispatchMessage.bind 'refresh', @change
    @doPoll()

  change: =>
    messages = App.DispatchMessage.all()
    if messages.length == 0
      @notice.html "No nearby efars"
    else
      @dispatchMessages.html ''
      @dispatchMessages.append(JST["dispatch/views/dispatch-message"](m)) for m in messages
    jQuery(".timeago").timeago();

  doPoll: =>
    App.DispatchMessage.fetchForEmergency(@emergencyId)
    setTimeout @doPoll, 6*1000


class IndexController
  constructor:->
    App.Emergency.bind 'refresh change', @change
    @doPoll()

  change: =>
    emergencies = App.Emergency.all()
    @updateStats(em) for em in emergencies

  updateStats: (emergency) ->
    elem = $("[data-emergency-id=#{emergency.id}]")
    @updateStat $('[data-type=emergency-sent-messages-count]', elem), 
      emergency.num_sent_dispatch_messages 
    @updateStat $('[data-type=emergency-en-route-messages-count]', elem), 
      emergency.num_en_route_dispatch_messages 
    @updateStat $('[data-type=emergency-on-scene-messages-count]', elem), 
      emergency.num_on_scene_dispatch_messages 
    @updateStat $('[data-type=emergency-failed-messages-count]', elem), 
      emergency.num_failed_dispatch_messages 

  updateStat: (elem, number) ->
    if number==0
      $(elem).hide()
    if number>0
      $('span', elem).html(number)  
      $(elem).show()

  doPoll: =>
    App.Emergency.fetchForPoll()
    setTimeout(@doPoll, 5*1000)


class NewDispatchController
  constructor: ->
    @setElements()
    @setEvents()
    @setupModal()

  setElements: ->
    @modal = $('#newDispatchModal')
    @form = $('form', @modal)
    @inputAddress = $('[name=address]', @modal)
    @inputCategory = $('[name=category]', @modal)
    @alertBox = $('.alert', @modal)

  setEvents: ->
    $('[data-type=new-dispatch]').bind 'click', =>
      @modal.modal()

    @form.bind 'submit', (e) =>
      @submit(e)

  submit: (e) ->
    e.preventDefault()
    App.Emergency.fromStreetAddress @inputAddress.val(), @inputCategory.val(), {
      success: @success
      failed: @failed }

  success: (em) =>
    window.location = '/emergencies'

  failed: (msg) =>
    @alertBox.show()
    @alertBox.html(msg)
    @inputAddress.focus()

  setupModal: ->
    @modal.on 'shown', =>
      @inputAddress.focus()
    @modal.on 'hide', =>
      @closeModal()

  closeModal: ->
    @inputAddress.val ''
    @inputCategory.prop('selectedIndex', 0)
    @alertBox.hide()


class MapController extends Spine.Controller
  elements:
    '#map-results' : 'mapEl'
    'input[name=searchAddress]' : 'searchInput'
    'select[name=category]' : 'selectCategory'
    'ul[data-type=searchResults]' : 'searchResultsNav'
    '[data-type=geocodeResult]' : 'geocodeResult'
    'button[data-type=submitDispatch]' : 'submitDispatchButton'
    '#submitDispatchModal' : 'submitDispatchModal'

  events:
    'click [data-type=geocodeResult]' : 'clickGeocodeResult'
    'submit form[data-type=search]' : 'submitSearch'
    'click [data-type=submitDispatch]' : 'submitDispatch'

  constructor: ->
    @el = $('.emergencies-new')
    @markers = []
    super()
    @selectCategory.focus()
    @setMap()


  setMap:->
    options = {
      zoom: 15
      center: new google.maps.LatLng(-33.9838663, 18.5552215)
      mapTypeId: google.maps.MapTypeId.ROADMAP
      streetViewControl: false
      mapTypeControl: false
    }
    @map = new google.maps.Map(@mapEl[0], options)

  submitSearch: (e) =>
    e.preventDefault()
    searchAddress = @searchInput.val() + ", Cape Town, South Africa"
    geocoder = new google.maps.Geocoder()
    geocoder.geocode {'address': searchAddress}, (results, status) =>
      if (status == google.maps.GeocoderStatus.OK)
        @searchResultsNav.html ''
        @clearMarkers()
        @addSearchResult(result) for result in results
        @geocodeResult.first().click()
      else
        console.log(status)

  addSearchResult: (result) ->
    console.log(result)
    @searchResultsNav.append JST["dispatch/views/map-search-result-nav"](result)
    marker = new google.maps.Marker(
        position: result.geometry.location
      )
    marker.setMap(@map)
    $('[data-type=geocodeResult]', @searchResultsNav).last().data('marker', marker)
    @markers.push(marker)
    @refreshElements()

  clickGeocodeResult: (e) =>
    el = $(e.currentTarget)
    $('li', @searchResultsNav).removeClass('active')
    el.parent().addClass('active')
    @activeMarker = el.data('marker')
    @map.panTo(@activeMarker.getPosition())
    @enableSubmitDispatchButton()
    @submitDispatchButton.focus()

  clearMarkers: =>
    @disableSubmitDispatchButton()
    marker.setMap(null) for marker in @markers
    @markers = [ ]

  enableSubmitDispatchButton: =>
    @submitDispatchButton.removeClass 'disabled'
  disableSubmitDispatchButton: =>
    @submitDispatchButton.addClass 'disabled'

  submitDispatch: =>
    @submitDispatchModal.modal({keyboard: false})
    input_address = @searchInput.val()
    input_category = @selectCategory.val()
    App.Emergency.createFromMarker(@activeMarker, input_address, input_category, {success: @dispatchCreated, fail: @dispatchFailed})

  dispatchCreated: ->
    # scope is a spine js model instance
    window.location = "/emergencies/#{@id}"

  dispatchFailed: ->
    console.log('failed to create dispatch')





class App
  constructor: (actionName) ->
    @modalController = new NewDispatchController
    if actionName=='index'
      @emergencyIndexController = new IndexController
    if actionName=='show'
      @showController = new ShowController
    if actionName=='new'
      @mapController = new MapController

    


window.App = App