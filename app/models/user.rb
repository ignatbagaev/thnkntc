class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :answers
  has_many :questions
  has_many :votes
  has_many :comments
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  def author_of?(obj)
    obj.user_id == id
  end

  def self.find_for_oauth(auth)
    if auth.info.try(:email)
      User.find_or_create_user_and_authorization(auth)
    else
      Authorization.find_by(provider: auth[:provider], uid: auth[:uid]).try(:user)
    end
  end

  private_class_method

  def self.find_or_create_user_and_authorization(auth)
    user = User.where(email: auth.info[:email]).first_or_create do |u|
      u.password = Devise.friendly_token[0, 10]
    end
    user.authorizations.where(provider: auth[:provider], uid: auth[:uid]).first_or_create
    user
  end
end
