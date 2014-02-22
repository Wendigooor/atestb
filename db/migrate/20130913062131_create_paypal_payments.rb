class CreatePaypalPayments < ActiveRecord::Migration
  def change
    create_table :paypal_payments do |t|
      t.string :track_id

      t.timestamps
    end
  end
end
