class Reservation
  include Mongoid::Document
  embedded_in :users

  #strings
  field :container_name
  field :userid
  field :default_pass
  field :created_at, type: Time

end
