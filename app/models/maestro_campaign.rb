# == Schema Information
#
# Table name: maestro_campaigns
#
#  active     :boolean
#  created_at :datetime         not null
#  id         :bigint(8)        not null, primary key
#  name       :string
#  updated_at :datetime         not null
#

class MaestroCampaign < ApplicationRecord
  has_many :maestro_campaign_buyers
  has_many :maestro_buyers, through: :maestro_campaign_buyers
  has_many :maestro_phone_campaigns
end
