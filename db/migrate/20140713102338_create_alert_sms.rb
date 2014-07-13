class CreateAlertSms < ActiveRecord::Migration
  def change
    create_table :alert_sms do |t|
      t.integer :efar_id, :null => false
      t.integer :alert_id, :null => false
      t.timestamps
    end
  end
end
