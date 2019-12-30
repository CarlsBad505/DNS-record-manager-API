require 'rails_helper'

RSpec.describe "Zone Requests", type: :request do
  let(:api_key) {
    SecureRandom.alphanumeric(15)
  }

  let(:email) {
    'natalie@yahoo.com'
  }

  let(:headers) {
    {
      'Content-Type' => 'application/json',
      'User-Email' => "#{email}",
      'API-KEY' => "#{api_key}"
    }
  }

  let(:missing_user_email_headers) {
    {
      'Content-Type' => 'application/json',
      'API-KEY' => "#{api_key}"
    }
  }

  let(:invalid_user_email_headers) {
    {
      'Content-Type' => 'application/json',
      'User-Email' => 'nobody@yahoo.com',
      'API-KEY' => "#{api_key}"
    }
  }

  let(:missing_api_key_headers) {
    {
      'Content-Type' => 'application/json',
      'User-Email' => "#{email}"
    }
  }

  let(:invalid_api_key_headers) {
    {
      'Content-Type' => 'application/json',
      'User-Email' => "#{email}",
      'API-KEY' => 'aaaaaa0000000'
    }
  }

  let(:malformed_domain_name) {
    'mission'
  }

  let(:post_params) {
    {
      domain_name: 'missiontopluto.com',
      ip_address: '127.0.0.1'
    }
  }

  let(:missing_domain_name_params) {
    {
      ip_address: '127.0.0.1'
    }
  }

  let(:invalid_domain_name_params) {
    {
      domain_name: 'missiontopluto',
      ip_address: '127.0.0.1'
    }
  }

  let(:missing_ip_address_params) {
    {
      domain_name: 'missiontopluto.com'
    }
  }

  let(:invalid_ip_address_params) {
    {
      domain_name: 'missiontopluto.com',
      ip_address: '127:0001'
    }
  }

  let(:put_params) do
    {
      add_records: [
    	   {
    			name: 'www',
    			record_type: 'A',
    			data: '204.120.0.15'
    		},
    		{
    			name: 'volunteers.missiontomars.com',
    			record_type: 'CNAME',
    			data: 'volunteers.missiontomars.com'
    		}
	    ],
	    remove_records: [
    		{
    			name: 'blog.missiontomars.com'
    		}
      ]
    }
  end

  let(:no_put_requests) {
    {}
  }

  let(:malformed_add_records_params) do
    {
      add_records: [
    	   {
    			name: 'www',
    			record_type: 'Z',
    			data: '204:0001'
    		},
    		{
    			name: 'volunteers.missiontomars.com',
    			record_type: 'CNAME',
    			data: 'volunteers.missiontomars.com'
    		}
	    ],
	    remove_records: [
    		{
    			name: 'blog.missiontomars.com'
    		}
      ]
    }
  end

  let(:malformed_remove_records_params) do
    {
      add_records: [
    	   {
    			name: 'www',
          record_type: 'A',
          data: '204.120.0.15'
    		},
    		{
    			name: 'volunteers.missiontomars.com',
    			record_type: 'CNAME',
    			data: 'volunteers.missiontomars.com'
    		}
	    ],
	    remove_records: [
    		{
    			name: 'doesnotexist.missiontomars.com'
    		}
      ]
    }
  end


  before(:each) do
    hashed = BCrypt::Password.create(api_key)
    user = User.create(
      email: email,
      hashed_token: hashed
    )

    zone = user.zones.create(
      name: 'missiontomars.com',
    )

    zone.records.create(
      name: '@',
      record_type: 'A',
      data: '127.0.0.1'
    )

    zone.records.create(
      name: 'www',
      record_type: 'A',
      data: '127.0.0.1'
    )

    zone.records.create(
      name: 'blog.missiontomars.com',
      record_type: 'CNAME',
      data: 'blog.missiontomars.com'
    )
  end

  # GET '/v1/api/view_zones'
  # ------------------------------------------------------------------
  it 'returns 401 for view all zones if User-Email header missing' do
    get('/v1/api/view_zones', headers: missing_user_email_headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(401)
    expect(response).to have_http_status(401)
    expect(response_body).to have_key(:error)
    expect(response_body[:error]).to include('header required')
  end

  it 'returns 401 for view all zones if User-Email header invalid' do
    get('/v1/api/view_zones', headers: invalid_user_email_headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(401)
    expect(response).to have_http_status(401)
    expect(response_body).to have_key(:error)
    expect(response_body[:error]).to include('header invalid')
  end

  it 'returns 401 for view all zones if API-KEY header missing' do
    get('/v1/api/view_zones', headers: missing_api_key_headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(401)
    expect(response).to have_http_status(401)
    expect(response_body).to have_key(:error)
    expect(response_body[:error]).to include('header required')
  end

  it 'returns 401 for view all zones if API-KEY header invalid' do
    get('/v1/api/view_zones', headers: invalid_api_key_headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(401)
    expect(response).to have_http_status(401)
    expect(response_body).to have_key(:error)
    expect(response_body[:error]).to include('header invalid')
  end

  it 'returns 200 for view all zones if valid credentials' do
    get('/v1/api/view_zones', headers: headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(200)
    expect(response).to have_http_status(200)
    expect(response_body).to have_key(:zones)
  end

  # GET '/v1/api/view_zone/:domain_name'
  # ------------------------------------------------------------------
  it 'returns 401 for view a zone if User-Email header missing' do
    get('/v1/api/view_zone/missiontomars%2Ecom', headers: missing_user_email_headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(401)
    expect(response).to have_http_status(401)
    expect(response_body).to have_key(:error)
    expect(response_body[:error]).to include('header required')
  end

  it 'returns 401 for view a zone if User-Email header invalid' do
    get('/v1/api/view_zone/missiontomars%2Ecom', headers: invalid_user_email_headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(401)
    expect(response).to have_http_status(401)
    expect(response_body).to have_key(:error)
    expect(response_body[:error]).to include('header invalid')
  end

  it 'returns 401 for view a zone if API-KEY header missing' do
    get('/v1/api/view_zone/missiontomars%2Ecom', headers: missing_api_key_headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(401)
    expect(response).to have_http_status(401)
    expect(response_body).to have_key(:error)
    expect(response_body[:error]).to include('header required')
  end

  it 'returns 401 for view a zone if API-KEY header invalid' do
    get('/v1/api/view_zone/missiontomars%2Ecom', headers: invalid_api_key_headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(401)
    expect(response).to have_http_status(401)
    expect(response_body).to have_key(:error)
    expect(response_body[:error]).to include('header invalid')
  end

  it 'returns 200 for view a zone if valid credentials' do
    get('/v1/api/view_zone/missiontomars%2Ecom', headers: headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(200)
    expect(response).to have_http_status(200)
    expect(response_body).to have_key(:records)
    expect(response_body).to have_key(:domain_name)
  end

  # POST '/v1/api/create_zone'
  # ------------------------------------------------------------------
  it 'returns 401 for create a zone if User-Email header missing' do
    post('/v1/api/create_zone', params: post_params.to_json, headers: missing_user_email_headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(401)
    expect(response).to have_http_status(401)
    expect(response_body).to have_key(:error)
    expect(response_body[:error]).to include('header required')
  end

  it 'returns 401 for create a zone if User-Email header invalid' do
    post('/v1/api/create_zone', params: post_params.to_json, headers: invalid_user_email_headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(401)
    expect(response).to have_http_status(401)
    expect(response_body).to have_key(:error)
    expect(response_body[:error]).to include('header invalid')
  end

  it 'returns 401 for create a zone if API-KEY header missing' do
    post('/v1/api/create_zone', params: post_params.to_json, headers: missing_api_key_headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(401)
    expect(response).to have_http_status(401)
    expect(response_body).to have_key(:error)
    expect(response_body[:error]).to include('header required')
  end

  it 'returns 401 for create a zone if API-KEY header invalid' do
    post('/v1/api/create_zone', params: post_params.to_json, headers: invalid_api_key_headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(401)
    expect(response).to have_http_status(401)
    expect(response_body).to have_key(:error)
    expect(response_body[:error]).to include('header invalid')
  end

  it 'returns 422 for create a zone if domain_name param missing' do
    post('/v1/api/create_zone', params: missing_domain_name_params.to_json, headers: headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(422)
    expect(response).to have_http_status(422)
    expect(response_body).to have_key(:error)
    expect(response_body[:error]).to include('param required')
  end

  it 'returns 422 for create a zone if domain_name param invalid' do
    post('/v1/api/create_zone', params: invalid_domain_name_params.to_json, headers: headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(422)
    expect(response).to have_http_status(422)
    expect(response_body).to have_key(:error)
    expect(response_body[:error]).to include('param invalid')
  end

  it 'returns 422 for create a zone if ip_address param missing' do
    post('/v1/api/create_zone', params: missing_ip_address_params.to_json, headers: headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(422)
    expect(response).to have_http_status(422)
    expect(response_body).to have_key(:error)
    expect(response_body[:error]).to include('param required')
  end

  it 'returns 422 for create a zone if ip_address param invalid' do
    post('/v1/api/create_zone', params: invalid_ip_address_params.to_json, headers: headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(422)
    expect(response).to have_http_status(422)
    expect(response_body).to have_key(:error)
    expect(response_body[:error]).to include('param invalid')
  end

  it 'returns 201 for create a zone if valid headers and params' do
    post('/v1/api/create_zone', params: post_params.to_json, headers: headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(201)
    expect(response).to have_http_status(201)
    expect(response_body).to have_key(:records)
    expect(response_body).to have_key(:domain_name)
  end

  # PUT '/v1/api/update_zone/:domain_name'
  # ------------------------------------------------------------------
  it 'returns 401 for edit a zone if User-Email header missing' do
    put('/v1/api/update_zone/missiontomars%2Ecom', params: put_params.to_json, headers: missing_user_email_headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(401)
    expect(response).to have_http_status(401)
    expect(response_body).to have_key(:error)
    expect(response_body[:error]).to include('header required')
  end

  it 'returns 401 for edit a zone if User-Email header invalid' do
    put('/v1/api/update_zone/missiontomars%2Ecom', params: put_params.to_json, headers: invalid_user_email_headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(401)
    expect(response).to have_http_status(401)
    expect(response_body).to have_key(:error)
    expect(response_body[:error]).to include('header invalid')
  end

  it 'returns 401 for edit a zone if API-KEY header missing' do
    put('/v1/api/update_zone/missiontomars%2Ecom', params: put_params.to_json, headers: missing_api_key_headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(401)
    expect(response).to have_http_status(401)
    expect(response_body).to have_key(:error)
    expect(response_body[:error]).to include('header required')
  end

  it 'returns 401 for edit a zone if API-KEY header invalid' do
    put('/v1/api/update_zone/missiontomars%2Ecom', params: put_params.to_json, headers: invalid_api_key_headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(401)
    expect(response).to have_http_status(401)
    expect(response_body).to have_key(:error)
    expect(response_body[:error]).to include('header invalid')
  end

  it 'returns 422 for edit a zone if domain_name param invalid' do
    put("/v1/api/update_zone/#{malformed_domain_name}", params: put_params.to_json, headers: headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(422)
    expect(response).to have_http_status(422)
    expect(response_body).to have_key(:error)
    expect(response_body[:error]).to include('param invalid')
  end

  it 'returns 422 for edit a zone if no edit requests params' do
    put('/v1/api/update_zone/missiontomars%2Ecom', params: no_put_requests.to_json, headers: headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(422)
    expect(response).to have_http_status(422)
    expect(response_body).to have_key(:error)
    expect(response_body[:error]).to include('no update requests found')
  end

  it 'returns 422 for edit a zone if add_record params invalid' do
    put('/v1/api/update_zone/missiontomars%2Ecom', params: malformed_add_records_params.to_json, headers: headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(422)
    expect(response).to have_http_status(422)
    expect(response_body).to have_key(:add_record_errors)
    expect(response_body[:add_record_errors]).to include('invalid or missing data')
  end

  it 'returns 422 for edit a zone if remove_records params invalid' do
    put('/v1/api/update_zone/missiontomars%2Ecom', params: malformed_remove_records_params.to_json, headers: headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(422)
    expect(response).to have_http_status(422)
    expect(response_body).to have_key(:remove_record_errors)
    expect(response_body[:remove_record_errors]).to include('invalid or missing data')
  end

  it 'returns 200 for edit a zone if valid headers and params' do
    put('/v1/api/update_zone/missiontomars%2Ecom', params: put_params.to_json, headers: headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(200)
    expect(response).to have_http_status(200)
    expect(response_body).to have_key(:domain_name)
    expect(response_body).to have_key(:records)
  end

  # DELETE '/v1/api/delete_zone/:domain_name'
  # ------------------------------------------------------------------
  it 'returns 401 for delete a zone if User-Email header missing' do
    delete('/v1/api/delete_zone/missiontomars%2Ecom', headers: missing_user_email_headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(401)
    expect(response).to have_http_status(401)
    expect(response_body).to have_key(:error)
    expect(response_body[:error]).to include('header required')
  end

  it 'returns 401 for delete a zone if User-Email header invalid' do
    delete('/v1/api/delete_zone/missiontomars%2Ecom', headers: invalid_user_email_headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(401)
    expect(response).to have_http_status(401)
    expect(response_body).to have_key(:error)
    expect(response_body[:error]).to include('header invalid')
  end

  it 'returns 401 for delete a zone if API-KEY header missing' do
    delete('/v1/api/delete_zone/missiontomars%2Ecom', headers: missing_api_key_headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(401)
    expect(response).to have_http_status(401)
    expect(response_body).to have_key(:error)
    expect(response_body[:error]).to include('header required')
  end

  it 'returns 401 for delete a zone if API-KEY header invalid' do
    delete('/v1/api/delete_zone/missiontomars%2Ecom', headers: invalid_api_key_headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(401)
    expect(response).to have_http_status(401)
    expect(response_body).to have_key(:error)
    expect(response_body[:error]).to include('header invalid')
  end

  it 'returns 422 for delete a zone if domain_name param invalid' do
    delete("/v1/api/delete_zone/#{malformed_domain_name}", headers: headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(422)
    expect(response).to have_http_status(422)
    expect(response_body).to have_key(:error)
    expect(response_body[:error]).to include('param invalid')
  end

  it 'returns 200 for delete a zone if valid headers and params' do
    delete('/v1/api/delete_zone/missiontomars%2Ecom', headers: headers)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to include('application/json')
    expect(response_body[:code]).to eq(200)
    expect(response).to have_http_status(200)
    expect(response_body).to have_key(:domain_name)
  end
end
