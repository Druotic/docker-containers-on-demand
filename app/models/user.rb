require 'json'
require 'google/api_client'

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

  # Google calendar ID of user's public "class_schedule" calendar
  field :calendar_id

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

  def google_calendar_id
    return self.calendar_id if !self.calendar_id.blank?
    # Otherwise, go get google calendar ID
    check_update_token

    client = Google::APIClient.new
    client.authorization.access_token = self.access_token
    service = client.discovered_api('calendar', 'v3')
    response = client.execute(
      :api_method => service.calendar_list.list,
      :parameters => {},
      :headers => {'Content-Type' => 'application/json'})

    calendar_id = extract_calendar_id response
    self.calendar_id = calendar_id
    self.save
    return self.calendar_id
  end

  # Check if token is within 1 min of expiring, or already expired.  If so, update
  def check_update_token
    refresh! if Time.at(self.expiration-60) < Time.now
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)

    info = access_token.info
    token_info = access_token.credentials
    user = User.where(email: info.email).first

    unless user # user created if they don't exist
      user = User.create(name: info.name,
        email: info.email,
        password: Devise.friendly_token[0,20], #random password
        name: info.name
      )
    end
    user.access_token = token_info.token
    user.refresh_token = token_info.refresh_token if !token_info.refresh_token.blank?
    user.expiration = token_info.expires_at
    user.save

    user
  end

  private

    def extract_calendar_id response
      response = JSON.parse(response.body)
      response["items"].each do |calendar|
        return calendar["id"] if calendar["summary"] == "class_schedule"
      end
    end

    def to_params
      {refresh_token:   refresh_token,
       client_id:       ENV['GOOGLE_CLIENT_ID'],
       client_secret:   ENV['GOOGLE_CLIENT_SECRET'],
       grant_type:      'refresh_token'}
    end

    def request_token_from_google
      url = URI("https://accounts.google.com/o/oauth2/token")
      Net::HTTP.post_form(url, to_params)
    end

    def refresh!
      response = request_token_from_google
      data = JSON.parse(response.body)
      update_attributes(
          access_token: data['access_token'],
          expiration: (Time.now + data['expires_in']).to_i
      )
    end

end