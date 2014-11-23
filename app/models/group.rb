class Group
  include Mongoid::Document
  has_and_belongs_to_many :users

  field :title
  field :leader_id
  field :course, type: String
  field :frequency, type: String
  field :place, type: String
  field :time, type: Time
  field :dayOfWeek, type: String
  field :date, type: Date

  def leader
    User.find(leader_id)
  end

  def number_of_members
    users.count
  end

end
