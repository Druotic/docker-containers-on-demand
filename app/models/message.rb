class Message
  include Mongoid::Document
  belongs_to :user
  belongs_to :group

  field :content
  validates :content, length: { minimum: 1, maximum: 600 }
end
