FactoryBot.define do
  factory :maestro_campaign_buyer do
    priority { 1 }
    maestro_campaign
    maestro_buyer
  end
end
