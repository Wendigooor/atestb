class Client < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :campaigns
  has_many :sdkkeys
  has_one :profile

  validates_length_of :username, :minimum => 3, :maximum => 15

  after_create :create_profile


  private
  
  def create_profile
	self.profile = Profile.create
  end

end
