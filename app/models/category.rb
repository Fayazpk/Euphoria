class Category < ApplicationRecord
    has_one_attached :image
    has_many :subcategories, dependent: :destroy
    has_many :products

    validates :name, presence: true
    validates :description, presence: true
    validates :image, presence: true
end
