# frozen_string_literal: true

class AddColumnsToFlavors < ActiveRecord::Migration[5.2]
  def change
    add_column :flavors, :user_id, :integer
  end
end
