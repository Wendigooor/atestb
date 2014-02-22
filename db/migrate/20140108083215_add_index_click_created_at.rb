class AddIndexClickCreatedAt < ActiveRecord::Migration
  def up
  	add_index(:clicks, :created_at)
  end

  def down
  end
end
