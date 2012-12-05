class LiveFeed.Emergency extends Spine.Model
  @configure "Emergency", "lat", "lng", "location_type", "input_address",
    "formatted_address", "created_at", "created_at", "state", 
    "num_sent_dispatch_messages", "num_en_route_dispatch_messages",
    "num_on_scene_dispatch_messages", "num_failed_dispatch_messages"
  @extend Spine.Model.Ajax
  @url: "/api/emergencies"