class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.integer :age
      t.boolean :is_admin

      t.timestamps
    end
  end
end
