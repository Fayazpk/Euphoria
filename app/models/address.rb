class Address < ApplicationRecord
  belongs_to :user
  belongs_to :country, dependent: :destroy
  belongs_to :state, dependent: :destroy
  belongs_to :city, dependent: :destroy
  def full_address
    [
      "#{first_name} #{last_name}",
      building_name,
      street_address,
      city&.name,
      state&.name,
      country&.name,
      phone
    ].compact.join(", ")
  end
  validates :first_name, :last_name, :building_name, :street_address, :phone, presence: true
end
