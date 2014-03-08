class Campaign < ActiveRecord::Base

  belongs_to :client

  has_many :campaign_items
  accepts_nested_attributes_for :campaign_items, :allow_destroy => true

  has_many :campaign_locations, :dependent => :destroy
  has_many :locations, :through => :campaign_locations, :dependent => :destroy
  accepts_nested_attributes_for :locations
  accepts_nested_attributes_for :campaign_locations

  has_many :campaign_age_ranges, :dependent => :destroy
  has_many :age_ranges, :through => :campaign_age_ranges, :dependent => :destroy
  accepts_nested_attributes_for :age_ranges
  accepts_nested_attributes_for :campaign_age_ranges

  has_many :adv_periods, :dependent => :destroy
  accepts_nested_attributes_for :adv_periods

  has_many :campaign_location_points, :dependent => :destroy
  accepts_nested_attributes_for :campaign_location_points

  before_save :update_items

  FONTS   = [['ArialMT', 0], ['Courier', 1], ['Georgia', 2], ['HelveticaNeue', 3], ['Kailasa', 4]]
  GENDERS = [['Male', 0], ['Female', 1], ['All', 2]]
  DEVICES = [['iPhone', 0], ['iPad', 1], ['iPhone & iPad', 2]]

  def update_items
    items = campaign_items
    new_items = []
    items.each do |item|
      puts item.inspect
      if item.content.blank?
      else
        new_items << item
      end
    end
    self.campaign_items = new_items
  end

  def location_ids=(values)
    if values.count == Location.all.count
      self.campaign_locations.destroy_all
    else
      self.locations = Location.all - Location.where(id: values)
    end
  end

  def as_json
    items = campaign_items.map {|i| {:id => i.id, :text => i.content}}
    { 
      :id => id,
      :caption => caption,
      :items => items,
      :border_color => border_color,
      :title_color => title_color,
      :font => Campaign::FONTS[font].first,
      :font_size => font_size,
    }
  end

end
