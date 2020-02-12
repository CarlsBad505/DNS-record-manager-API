class Record < ApplicationRecord
  belongs_to :zone

  validates :name, :record_type, :data, presence: true

  scope :query_soa, ->(condition) { where(soa: condition) }


end
