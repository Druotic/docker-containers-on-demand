class Group
  include Mongoid::Document

  field :leader, type: String
  field :course, type: String
  field :participantNumber, type: Integer, default: 1
  field :frequency, type: String
  field :place, type: String
  field :time, type: Time
  field :dayOfWeek, type: String
  field :date, type: Date

end
