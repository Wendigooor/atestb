class Client < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :balance, :admin, :developer

  has_many :campaigns
  has_many :sdkkeys
  has_one :profile

  validates :username, :presence => true, length: {minimum: 3, maximum: 20}

end
