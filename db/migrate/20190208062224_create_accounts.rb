class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.references :user, foreign_key: true, null: false, index: true
      t.integer :account_type, index: true, default: 0
      t.decimal :balance, precision: 13, scale: 2, default: 0.0
      t.string :clabe, null: false

      t.timestamps
    end
  end
end
