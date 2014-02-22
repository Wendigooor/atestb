class AddCampaignBeforeIdToAudiences < ActiveRecord::Migration
  def change
    add_column :audiences, :campaign_before_id, :integer
  end
end
