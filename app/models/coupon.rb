class Coupon < ApplicationRecord
  has_many :checkouts
  validates :code, presence: true, uniqueness: true
  validates :discount, presence: true, numericality: { greater_than: 0 }
  validates :valid_from, :valid_until, presence: true
  validates :max_usage, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validate :validity_dates

  scope :active, -> { where(status: true).where("valid_until >= ?", Date.current) }

  private

  def validity_dates
    if valid_from && valid_until && valid_from > valid_until
      errors.add(:valid_until, "must be after the valid from date")
    end
  end
end
