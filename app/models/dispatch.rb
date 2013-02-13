class Dispatch < ActiveRecord::Base
  attr_accessible :dispatcher_id, :emergency_category, :geolocation_id, 
    :landmarks, :township_id

  EMERGENCY_CATEGORIES = [
    'General emergency',
    'Uncontrolled bleed',
    'Motor vehicle accident',
    'Broken bone',
    'Unconscious person',
    'Fall from a height',
    'Seizure',
    'Burn',
    'Impaled object',
    'Shortness of breath',
    'Abdominal pain',
    'Confused person'
  ]
  
  validates :dispatcher_id, :presence => true
end
