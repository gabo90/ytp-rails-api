class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.references :user, foreign_key: true
      t.integer :type
      t.decimal :balance, precision: 13, scale: 2
      t.string :clabe

      t.timestamps
    end
  end
end
