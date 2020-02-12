class Zone < ApplicationRecord
  belongs_to :user
  has_many :records, dependent: :destroy

  validates :name, :user_id, presence: true

  def public_records
    records.where(soa: false)
  end

  def build_zone(user, params)
    self.user_id = user.id
    self.name = params[:domain_name].gsub('www.', '') # standard domain_name
    self.records.build( # <-- Build SOA required record
      name: "ns1.#{params[:domain_name].gsub('www.', '')}", # standardize domain_name
      record_type: 'SOA',
      data: params[:domain_name],
      ttl: 300,
      soa: true,
      revised_at: Time.now.to_i,
      refresh_time: 300,
      retry_time: 300,
      expires_at: (Time.now + 21.days).to_i,
      domain_email: user.email,
    )
    self.records.build( # <-- Build naked domain record
      name: '@',
      record_type: 'A',
      data: params[:ip_address],
    )
    self.records.build( # <-- Build non-naked domain record
      name: 'www',
      record_type: 'A',
      data: params[:ip_address],
    )
  end

  def view_records
    arr = []
    public_records.each do |record|
      arr << {
        name: record.name,
        record_type: record.record_type,
        data: record.data,
        ttl: record.ttl
      }
    end
    arr
  end

  def update_records(params)
    if params[:add_records] && !params[:add_records].empty?
      params[:add_records].each do |record|
        if existing_record = records.find_by_name(record[:name].gsub('www.', '')) # if record already exists, update it.
          next if existing_record.record_type == 'SOA' # user cannot modify this required record
          existing_record.name = record[:name].gsub('www.', '')
          existing_record.record_type = record[:record_type]
          existing_record.data = record[:data]
          existing_record.save
        else
          records.build(
            name: record[:name].gsub('www.', ''),
            record_type: record[:record_type],
            data: record[:data]
          )
        end
      end
    end

    if params[:remove_records] && !params[:remove_records].empty?
      params[:remove_records].each do |record|
        zone_record = records.find_by_name(record[:name].gsub('www.', ''))
        next if zone_record.record_type == 'SOA' # user cannot modify this required record
        zone_record.destroy
      end
    end
  end
end
