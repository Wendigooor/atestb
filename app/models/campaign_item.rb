class CampaignItem < ActiveRecord::Base
	
	require 'securerandom'

	#attr_accessible :textUrl
	belongs_to :campaign
	before_save :set_text_url, if: -> { self.image.present? }

	attr_accessor :image
	#attr_accessible :image

	has_many :campaign_before_items, dependent: :destroy
  	has_many :campaign_items_qwe, class_name: 'CampaignItem', through: :campaign_before_items, uniq: true, source: :campaign_items_qwe
  	has_many :before_items, through: :campaign_items_qwe
  	accepts_nested_attributes_for :before_items
  	accepts_nested_attributes_for :campaign_before_items

	def set_text_url
		file_name = SecureRandom.hex + ".jpg"
		File.open("#{Rails.root}/public/images/#{file_name}", 'wb') do |f|
			f.write image.read
		end
 		self.textUrl = file_name
	end

	def image=(value)
		self.textUrl = nil
		@image = value
	end
end
