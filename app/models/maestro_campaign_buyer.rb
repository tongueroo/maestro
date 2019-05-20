# == Schema Information
#
# Table name: maestro_campaign_buyers
#
#  created_at            :datetime         not null
#  id                    :bigint(8)        not null, primary key
#  maestro_buyer_id      :bigint(8)
#  maestro_campaign_id   :bigint(8)
#  priority              :integer
#  updated_at            :datetime         not null
#  web_hook              :string
#  web_hook_trigger_type :string
#  weight                :integer
#
# Indexes
#
#  index_maestro_campaign_buyers_on_maestro_buyer_id     (maestro_buyer_id)
#  index_maestro_campaign_buyers_on_maestro_campaign_id  (maestro_campaign_id)
#
# Foreign Keys
#
#  fk_rails_...  (maestro_buyer_id => maestro_buyers.id)
#  fk_rails_...  (maestro_campaign_id => maestro_campaigns.id)
#

class MaestroCampaignBuyer < ApplicationRecord
  belongs_to :maestro_campaign
  belongs_to :maestro_buyer
end
