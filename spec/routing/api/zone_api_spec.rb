require 'rails_helper'

RSpec.describe 'GET Routes', type: :routing do
  let(:domain_name) { 'missiontomars%2Ecom' }

  it 'routes /v1/api/view_zones' do
    expect(get('/v1/api/view_zones')).to route_to(controller: 'api/zones', action: 'index', format: 'json')
  end

  it 'routes /v1/api/view_zone/:domain_name' do
    expect(get("/v1/api/view_zone/#{domain_name}")).to route_to(controller: "api/zones", action: "show", format: "json", domain_name: 'missiontomars.com')
  end
end

RSpec.describe 'POST routes', type: :routing do
  it 'routes /v1/api/create_zone' do
    expect(post('v1/api/create_zone')).to route_to(controller: 'api/zones', action: 'create', format: 'json')
  end
end

RSpec.describe 'PUT routes', type: :routing do
  let(:domain_name) { 'missiontomars%2Ecom' }

  it 'routes /v1/api/update_zone/:domain_name' do
    expect(put("v1/api/update_zone/#{domain_name}")).to route_to(controller: 'api/zones', action: 'update', format: 'json', domain_name: 'missiontomars.com')
  end
end

RSpec.describe 'DELETE routes', type: :routing do
  let(:domain_name) { 'missiontomars%2Ecom' }

  it 'routes /v1/api/delete_zone/:domain_name' do
    expect(delete("v1/api/delete_zone/#{domain_name}")).to route_to(controller: 'api/zones', action: 'delete', format: 'json', domain_name: 'missiontomars.com')
  end
end
