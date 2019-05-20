class MaestroController < ApplicationController
  before_action :validate_api_key

  def execution_plan
    delta_phone = params[:delta_phone]
    lead_phone = params[:lead_phone]

    lead = lead_by_phone(lead_phone, secret)
    unless lead
      render json: {data: 'lead not found'}, status: :not_found
      return
    end

    puts "we have a lead #{lead}"

    pc = MaestroPhoneCampaign.find(delta_phone.to_i)
    unless pc
      render json: {data: 'campaign not found'}, status: :not_found
      return
    end

    campaign = pc.maestro_campaign
    maestro = Maestro::Evaluator.new
    resp = maestro.interested_buyers(lead, campaign)
    render json: {data: resp}, status: :ok
  end

  private

  def secret
    client = Aws::SecretsManager::Client.new(region: 'us-east-1')
    creds = JSON.parse(client.get_secret_value(secret_id: 'maestro/nonprod/dbcreds').secret_string)
    JSON.parse(client.get_secret_value(secret_id: 'maestro/nonprod/dbcreds').secret_string)
  end

  def lead_by_phone(phone, creds)
    # The lead is queried from the main app using a REST call
    resp = HTTParty.post("#{assurance_endpoint(creds)}?lead_phone=#{phone}", :headers => { 'Api-Key' => creds['api_key'] })
    if resp.success?
      hash = resp.parsed_response['data']
      JSON.parse(hash.to_json, object_class: OpenStruct)
    else
      nil
    end
  end

  def assurance_endpoint(creds)
    "http://#{creds['assurance_host']}:#{creds['assurance_port']}/api/maestro/lead_by_phone"
  end

  def validate_api_key
    client = Aws::SecretsManager::Client.new(region: 'us-east-1')
    creds = JSON.parse(client.get_secret_value(secret_id: 'maestro/nonprod/dbcreds').secret_string)
    puts "BEGIN: request headers"
    puts request.headers
    puts "END: request headers"
    unless request.headers['api-key'] == creds['api_key']
      render json: { error: 'Invalid api key' }, status: :unauthorized
    end
  end

end
