# frozen_string_literal: true

class CreateFlavors < ActiveRecord::Migration[5.2]
  def change
    create_table :flavors do |t|
      t.string :name
      t.integer :purchase_price
      t.integer :status
      t.text :image

      t.timestamps
    end
  end
end
