class Subcategory < ApplicationRecord
  belongs_to :category
  has_many :products
  has_one_attached :image

  validates :name, presence: { message: "is required" }
  validates :category, presence: { message: "must be selected" }
  validates :image, presence: { message: "must have at least one image" }


  
end
