class User < ApplicationRecord
  has_many :zones, dependent: :destroy

  def view_zones
    arr = []
    zones.each do |zone|
      arr << {
        domain_name: zone.name,
        records: zone.view_records,
      }
    end
    arr
  end
end
