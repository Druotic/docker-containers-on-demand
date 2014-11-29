class Group
  include Mongoid::Document
  has_and_belongs_to_many :users
  has_many :group_applications

  field :title
  field :leader_id
  field :course, type: String
  field :frequency, type: String
  field :place, type: String
  field :time, type: Time
  field :date, type: Date
  field :description

  validates :title, :leader_id, :course, :frequency, presence: true
  validates :description, length: { maximum: 600 }


  def leader
    User.find(leader_id)
  end

  def number_of_members
    users.count
  end

  def calendars_string
    combined_s = ""
    users.each do |user|
      combined_s += "src=%s&" % user.google_calendar_id
    end

    combined_s
  end

  def converted_time
      self.time.strftime("%l:%M %P")
  end

  def day_of_week
    self.time.strftime("%A")
  end
end
