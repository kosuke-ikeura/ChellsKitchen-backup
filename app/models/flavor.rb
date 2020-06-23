# frozen_string_literal: true

class Flavor < ApplicationRecord
  belongs_to :user
  mount_uploader :image, ImageUploader

  def self.search(search)
    return Flavor.all unless search

    Flavor.where(['name LIKE ?', "%#{search}%"]).where(id: 2..25).limit(10)
  end
end
