class AddImageQuestionLinkToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :image_question_link, :string
  end
end
