class GroupApplication
  include Mongoid::Document
  belongs_to :group
  belongs_to :user
end
