class Group
  include MongoMapper::Document

  key :leader, String
  key :course, String

end
