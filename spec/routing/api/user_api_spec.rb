require 'rails_helper'

RSpec.describe 'POST Create User', type: :routing do
  it 'routes /v1/api/create_user' do
    expect(post('/v1/api/create_user')).to route_to(controller: 'api/users', action: 'create', format: 'json')
  end
end
