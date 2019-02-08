class CreateAccountTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :account_transactions do |t|
      t.references :account, foreign_key: true
      t.integer :type
      t.decimal :amount, precision: 8, scale: 2

      t.timestamps
    end
  end
end
