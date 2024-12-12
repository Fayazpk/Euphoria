class Category < ApplicationRecord
    has_one_attached :image
    has_many :subcategories, dependent: :destroy

    validates :name, presence: true
    validates :description, presence: true
end
