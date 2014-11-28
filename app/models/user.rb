class User
  include Mongoid::Document
  has_and_belongs_to_many :groups
  has_many :group_applications

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  field :name,               type: String, default: ""

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## OAuth tokens from Google API
  field :access_token
  field :refresh_token
  field :expiration

  def is_leader group
    group.leader == self
  end

  def is_member group
    group.users.include? self
  end

  def is_pending_applicant? group
    self.group_applications.each do |ga|
      return true if ga.group == group && ga.status.to_sym == :pending
    end
    false
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)

    info = access_token.info
    token_info = access_token.credentials
    user = User.where(:email => info["email"]).first

    unless user # user created if they don't exist
      user = User.create(name: info["name"],
        email: info[:email],
        password: Devise.friendly_token[0,20], #random password
        name: info[:name]
      )
    end
    user.access_token = token_info.access_token
    user.refresh_token = token_info.refresh_token if !token_info.refresh_token.blank?
    user.expiration = token_info.expires_at
    user.save

    user
  end

end
