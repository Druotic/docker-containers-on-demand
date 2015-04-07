class Reservation
  include Mongoid::Document
  embedded_in :users

  #strings unless specified otherwise
  field :container_name
  field :userid
  field :default_pass
  field :created_at, type: Time
  field :host
  field :port

end
