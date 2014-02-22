class Campaign < ActiveRecord::Base

  include Rails.application.routes.url_helpers

  require 'securerandom'

  attr_accessible :caption, :campaign_items_attributes, :type, :purchased, :showed, :approved, :image_url,
    :title_color, :border_color, :background_url, :image_question_link, :target_device, :font, :font_size, :campaign_before_id, :campaign_age_ranges_attributes,
    :gender, :multiple, :locations, :campaign_locations, :location_ids, :age_range_ids, :before_answers, :update_before_answers, :campaign_location_points_attributes, :static_key

  attr_accessor :image
  attr_accessible :image
  before_save :set_image_url, if: -> { self.image.present? }

  attr_accessor :background_image
  attr_accessible :background_image
  before_save :set_background_url, if: -> { self.background_image.present? }

  belongs_to :client
  has_many :campaign_items

  has_many :campaign_locations, :dependent => :destroy
  has_many :locations, :through => :campaign_locations, :dependent => :destroy
  accepts_nested_attributes_for :locations
  accepts_nested_attributes_for :campaign_locations

  has_many :campaign_age_ranges, :dependent => :destroy
  has_many :age_ranges, :through => :campaign_age_ranges, :dependent => :destroy
  accepts_nested_attributes_for :age_ranges
  accepts_nested_attributes_for :campaign_age_ranges

  has_many :campaign_before_items, dependent: :destroy
  has_many :before_answers, class_name: 'CampaignItem', through: :campaign_before_items, uniq: true, source: :campaign_item
  accepts_nested_attributes_for :before_answers
  accepts_nested_attributes_for :campaign_before_items

  has_many :adv_periods, :dependent => :destroy
  accepts_nested_attributes_for :adv_periods

  has_many :campaign_location_points, :dependent => :destroy
  accepts_nested_attributes_for :campaign_location_points

  before_save :update_items

  accepts_nested_attributes_for :campaign_items, :reject_if => :reject_items, :allow_destroy => true

  FONTS   = [['ArialMT', 0], ['Courier', 1], ['Georgia', 2], ['HelveticaNeue', 3], ['Kailasa', 4]]
  GENDERS = [['Male', 0], ['Female', 1], ['All', 2]]
  DEVICES = [['iPhone', 0], ['iPad', 1], ['iPhone & iPad', 2]]

  def reject_items(attributes)
  end

  def update_items
    items = campaign_items
    new_items = []
    items.each do |item|
      puts item.inspect
      if item.textUrl.blank?
        if item.image
          new_items << item
        end
      else
        new_items << item
      end
    end
    self.campaign_items = new_items
  end

  def update_before_answers=(values)
    items = CampaignItem.find_all_by_id(values)
    self.before_answers = items
  end

  def set_image_url
    file_name = SecureRandom.hex + ".jpg"
    File.open("#{Rails.root}/public/images/#{file_name}",'wb') do |f|
      f.write image.read
    end
    self.image_url = file_name
  end

  def image=(value)
    self.image_url = nil
    @image = value
  end

  def set_background_url
    file_name = SecureRandom.hex + ".jpg"
    File.open("#{Rails.root}/public/images/#{file_name}",'wb') do |f|
      f.write background_image.read
    end
    self.background_url = file_name
  end

  def background_image=(value)
    self.background_url = nil
    @background_image = value
  end

  def location_ids=(values)
    if values.count == Location.all.count
      self.campaign_locations.destroy_all
    else
      self.locations = Location.all - Location.find_all_by_id(values)
    end
  end

  def as_json(root_path)
    if type_ad == 0
      items = campaign_items.map {|i| {:id => i.id, :text => i.textUrl}}
    else
      items = campaign_items.map {|i| {:id => i.id, :text => "http://#{root_path}/images/" + i.textUrl}}
    end
    puts items.inspect
    campaign_image_url = image_url ? ("http://#{root_path}images/" + image_url) : ""
    campaign_background_url = background_url ? ("http://#{root_path}/images/" + background_url) : ""
    { 
      :id => id,
      :caption => caption,
      :image_url => campaign_image_url,
      :items => items,
      :type => type_ad,
      :border_color => border_color,
      :title_color => title_color,
      :image_question_link => image_question_link,
      :background_url => campaign_background_url,
      :font => Campaign::FONTS[font].first,
      :font_size => font_size,
    }
  end

end
