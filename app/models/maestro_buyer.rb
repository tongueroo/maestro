# == Schema Information
#
# Table name: maestro_buyers
#
#  active                :boolean
#  call_cap_concurrent   :integer
#  call_cap_daily        :integer
#  call_cap_hourly       :integer
#  call_cap_lifetime     :bigint(8)
#  call_cap_monthly      :integer
#  created_at            :datetime         not null
#  id                    :bigint(8)        not null, primary key
#  name                  :string
#  phone                 :bigint(8)
#  transfer_type         :string
#  updated_at            :datetime         not null
#  web_hook              :string
#  web_hook_trigger_type :string
#

class MaestroBuyer < ApplicationRecord
  has_many :maestro_campaign_buyers
  has_many :maestro_campaigns, through: :maestro_campaign_buyers
  has_many :maestro_buyer_rules
end
