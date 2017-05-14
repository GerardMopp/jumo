class CreateLoans < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.string :input
      t.string :output

      t.timestamps
    end
  end
end
