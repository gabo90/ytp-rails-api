class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.integer :role, default: 1
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end
