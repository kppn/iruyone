class User < ActiveRecord::Base
  has_many :microposts
  has_secure_password

  attr_accessor :oauth_token

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,  format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 1 }

  before_save do
    if email
      self.email = email.downcase 
    end
  end

  before_create :create_remember_token

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def User.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      
      unless auth.info.blank?
        user.name = auth.info.name
        # user.screen_name = auth.info.screen_name
        # user.image = auth.info.image
	
	puts '---------------------'
	puts auth
	puts '---------------------'
	puts user
	puts '---------------------'
	puts auth.credentials.token
	puts '---------------------'
      end

      user.oauth_token = auth.credentials.token
      #user.oauth_expires_at = Time.at(auth.credentials.expires_at) unless auth.credentials.expires_at.nil? 
      #user.save!
    end
  end


  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
