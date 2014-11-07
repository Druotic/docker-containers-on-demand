class Group
  include MongoMapper::Document

  key :leader, String
  key :course, String
  key :participantNumber, Integer, :default => 1
  key :frequency, String
  key :place, String
  key :time, Time
  key :dayOfWeek, String
  key :date, Date

end
