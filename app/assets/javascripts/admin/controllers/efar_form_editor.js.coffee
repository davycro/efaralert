class App.EfarFormEditor extends Spine.Controller

  events:
    'click [data-type=create-new-contact-number-field]' : 'createNewContactNumberField'

  elements:
    '.efar-contact-number-fields' : 'efarContactNumberFields'

  constructor: ->
    @el = $('.efar-form-editor')
    super()
    @numEfarContactNumbers = $(@efarContactNumberFields).data('length')

  createNewContactNumberField: (e) =>
    e.preventDefault
    $(@efarContactNumberFields).append @view('efar_form_editor/contact_number_field')({index: @numEfarContactNumbers})
    $('[data-type=contactNumberInput]', @efarContactNumberFields).last().focus()
    @numEfarContactNumbers += 1

