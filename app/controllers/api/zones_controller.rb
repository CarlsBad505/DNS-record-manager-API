class Api::ZonesController < ApplicationController
  before_action :find_user

  def index
    validate_headers

    if @valid_headers
      render json: {
        code: 200,
        zones: @user.view_zones
      }, status: 200
    end
  rescue
    render_server_error
  end

  def show
    validate_headers

    if @valid_headers
      return invalid_param('domain_name') unless zone = find_zone(params[:domain_name])

      render json: {
        code: 200,
        domain_name: zone.name,
        records: zone.view_records,
      }, status: 200
    end
  rescue
    render_server_error
  end

  def create
    validate_headers

    if @valid_headers
      return missing_param('domain_name') unless params[:domain_name].present?
      return invalid_param('domain_name') unless validate_domain_name(params[:domain_name])
      return zone_already_exists unless check_zones(params[:domain_name])
      return missing_param('ip_address') unless params[:ip_address].present?
      return invalid_param('ip_address') unless validate_ip_address(params[:ip_address])

      zone = Zone.new
      zone.build_zone(@user, params)
      return action_failed unless zone.save

      render json: {
        code: 201,
        domain_name: zone.name,
        records: zone.view_records,
        message: "your zone was successfully created"
      }, status: 201
    end
  rescue
    render_server_error
  end

  def update
    validate_headers

    if @valid_headers
      return invalid_param('domain_name') unless zone = find_zone(params[:domain_name])

      validation_msg = validate_update_requests(zone, params)
      return invalid_update_params(validation_msg) if validation_msg[:add_record_errors].present? || validation_msg[:remove_record_errors].present? || validation_msg[:error].present?

      zone.update_records(params)
      return action_failed unless zone.save

      render json: {
        code: 200,
        domain_name: zone.name,
        records: zone.view_records,
        message: "your zone was successfully updated"
      }, status: 200
    end
  rescue
    render_server_error
  end

  def delete
    validate_headers

    if @valid_headers
      return invalid_param('domain_name') unless zone = find_zone(params[:domain_name])
      return action_failed unless zone.destroy

      render json: {
        code: 200,
        domain_name: params[:domain_name],
        message: "your zone was successfully deleted"
      }, status: 200
    end
  rescue
    render_server_error
  end

  private

  def zone_already_exists
    render json: {
      code: 422,
      error: 'domain_name already has a zone'
    }, status: 422
  end

  def invalid_update_params(msg)
    render json: msg, status: 422
  end

  def check_zones(domain_name)
    Zone.find_by(user_id: @user.id, name: domain_name.gsub('www.', '')).nil? # standardize domain_name
  end

  def find_zone(domain_name)
    Zone.find_by(user_id: @user.id, name: domain_name.gsub('www.', '')) # standardize domain_name
  end

  def find_user
    @user = User.find_by_email(request.headers['User-Email'])
  end

  def validate_domain_name(domain_name)
    # Unknown/not-listed TLD domains are not valid
    # Private domains are not valid
    PublicSuffix.valid?(domain_name, default_rule: nil)
  end

  def validate_ip_address(ip_address)
    IPAddress::valid_ipv4?(ip_address)
  end

  def validate_update_requests(zone, params)
    data_errors_msg = {code: 422}
    add_record_errors = false
    remove_record_errors = false
    return {code: 422, error: 'no update requests found'} if (!params[:add_records] || params[:add_records].empty?) && (!params[:remove_records] || params[:remove_records].empty?)

    if params[:add_records] && !params[:add_records].empty?
      params[:add_records].each do |record|
        add_record_errors = true unless record[:name].present? && record[:record_type].present? && record[:data].present? && validate_record_type(record[:record_type]) && validate_record_data(record[:record_type], record[:data])
      end
    end

    if params[:remove_records] && !params[:remove_records].empty?
      params[:remove_records].each do |record|
        remove_record_errors = true unless record[:name].present? && Record.find_by(zone_id: zone.id, name: record[:name].gsub('www.', ''))
      end
    end

    data_errors_msg[:add_record_errors] = 'invalid or missing data' if add_record_errors
    data_errors_msg[:remove_record_errors] = 'invalid or missing data' if remove_record_errors
    data_errors_msg
  end

  def validate_record_type(type)
    (type == 'A' || type == 'CNAME') ? true : false
  end

  def validate_record_data(type, data)
    if type == 'A'
      return validate_ip_address(data)
    elsif type == 'CNAME'
      return validate_domain_name(data)
    else
      return false
    end
  end

end
