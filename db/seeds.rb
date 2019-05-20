campaign =
  MaestroCampaign.find_or_create_by(name: 'Auto') do |campaign|
    campaign.active = true
  end

MaestroPhoneCampaign.find_or_create_by(phone: '17459873245', maestro_campaign: campaign)

buyer1 =
  MaestroBuyer.find_or_create_by(name: 'Marchex') do |buyer|
    buyer.active = true
    buyer.phone = 2067894567
    buyer.transfer_type = 'warm'
    buyer.web_hook = 'http://super.bitly?kk=#{kk}&ll=#{ll}'
    buyer.web_hook_trigger_type = 'postcall'
    buyer.call_cap_concurrent = 5
    buyer.call_cap_daily = 100
    buyer.call_cap_hourly = 10
    buyer.call_cap_monthly = 2000
    buyer.call_cap_lifetime = 100000
  end

MaestroCampaignBuyer.find_or_create_by(maestro_campaign_id: campaign.id, maestro_buyer_id: buyer1.id) do |jointable|
  jointable.priority = 1
  jointable.weight = 100
  jointable.web_hook = nil
  jointable.web_hook_trigger_type = nil
end

MaestroBuyerRule.find_or_create_by(maestro_buyer_id: buyer1.id, left_operand: 'age', operator: '<', right_operand: 70)
MaestroBuyerRule.find_or_create_by(maestro_buyer_id: buyer1.id, left_operand: 'state', operator: 'in', right_operand: ['WA', 'OR'])

buyer2 =
  MaestroBuyer.find_or_create_by(name: 'Avenge') do |buyer|
    buyer.active = true
    buyer.phone = 4256789378
    buyer.transfer_type = 'cold'
    buyer.web_hook = 'http://update_flow?aa=#{aa}&bb=#{bb}'
    buyer.web_hook_trigger_type = 'precall'
    buyer.call_cap_concurrent = 10
    buyer.call_cap_daily = 200
    buyer.call_cap_hourly = 30
    buyer.call_cap_monthly = 1000
    buyer.call_cap_lifetime = 400000
  end

MaestroBuyerRule.find_or_create_by(maestro_buyer_id: buyer2.id, left_operand: 'age', operator: '<', right_operand: 70)
MaestroBuyerRule.find_or_create_by(maestro_buyer_id: buyer2.id, left_operand: 'state', operator: 'in', right_operand: ['CA', 'OR'])

MaestroCampaignBuyer.find_or_create_by(maestro_campaign_id: campaign.id, maestro_buyer_id: buyer2.id) do |jointable|
  jointable.priority = 1
  jointable.weight = 100
  jointable.web_hook = nil
  jointable.web_hook_trigger_type = nil
end
