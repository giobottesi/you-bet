class Simulation < ApplicationRecord
  validates :visitor_id, presence: true
  validates :bet_type_keys, presence: true
  validates :weekly_amount_cents, presence: true, numericality: { greater_than: 0 }
  validates :timeframe_weeks, presence: true, numericality: { greater_than: 0 }
  validate :bet_type_keys_are_known

  # Permalinks address the Simulation by its opaque UUID, never the sequential PK.
  def to_param
    uuid
  end

  def create
    self.uuid = SecureRandom.uuid
    save
  end

  private

  def bet_type_keys_are_known
    unknown = bet_type_keys - BetType::BETTING_TYPES
    errors.add(:bet_type_keys, :invalid) if unknown.any?
  end
end
