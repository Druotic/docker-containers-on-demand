class Message
  include Mongoid::Document
  belongs_to :user
  belongs_to :group

  field :content
  field :created_at
  validates :content, :created_at, presence: true
  validates :content, length: { minimum: 1, maximum: 600 }
end
