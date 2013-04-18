class CreateTextMessages < ActiveRecord::Migration
  def change
    create_table :text_messages do |t|
      t.integer :efar_id, :null => false
      t.integer :dispatcher_id
      t.text :content
      t.boolean :viewed_by_dispatcher, :default => false
      t.string :sender_name
      t.string :sender_class_name

      t.timestamps
    end
  end
end
