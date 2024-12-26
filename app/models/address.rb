class Address < ApplicationRecord
  belongs_to :user
  belongs_to :country
  belongs_to :state
  belongs_to :city

  validates :first_name, :last_name, :building_name, :street_address, :phone, presence: true
end
