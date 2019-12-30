require 'rails_helper'

RSpec.describe 'POST Create User', type: :request do
  before(:each) do
    token = SecureRandom.alphanumeric(15)
    hashed = BCrypt::Password.create(token)
    User.create(
      email: 'natalie@yahoo.com',
      hashed_token: hashed
    )
  end

  let(:valid_body) do
    { email: 'mitch@yahoo.com' }
  end

  let(:malformed_key) do
    { emailll: 'mitch@yahoo.com' }
  end

  let(:malformed_email) do
    { email: 'mitch@yahoo' }
  end

  let(:existing_email) do
    { email: 'natalie@yahoo.com' }
  end

  it 'returns 422 if email key missing' do
    post('/v1/api/create_user', params: malformed_key)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(422)
    expect(response).to have_http_status(422)
  end

  it 'returns 422 if email invalid' do
    post('/v1/api/create_user', params: malformed_email)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(422)
    expect(response).to have_http_status(422)
  end

  it 'returns 400 if email already exists' do
    post('/v1/api/create_user', params: existing_email)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(400)
    expect(response).to have_http_status(400)
  end

  it 'returns 201 if user created' do
    post('/v1/api/create_user', params: valid_body)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(201)
    expect(response).to have_http_status(201)
    expect(response_body).to have_key(:email)
    expect(response_body).to have_key(:api_key)
  end

end
