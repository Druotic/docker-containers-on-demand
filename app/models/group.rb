class Group
  include Mongoid::Document
  has_and_belongs_to_many :users

  field :leader_id
  field :course, type: String
  field :participantNumber, type: Integer, default: 1
  field :frequency, type: String
  field :place, type: String
  field :time, type: Time
  field :dayOfWeek, type: String
  field :date, type: Date

  def leader
    User.find(leader_id)
  end

end
