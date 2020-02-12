class User < ApplicationRecord
  has_many :zones, dependent: :destroy

  def view_zones
    zones.map do |zone|
      {
        domain_name: zone.name,
        records: zone.view_records
      }
    end
  end
end
