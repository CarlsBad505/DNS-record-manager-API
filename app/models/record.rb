class Record < ApplicationRecord
  belongs_to :zone

  validates :name, presence: true
  validates :record_type, presence: true
  validates :data, presence: true
end
