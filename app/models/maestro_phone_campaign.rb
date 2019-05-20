# == Schema Information
#
# Table name: maestro_phone_campaigns
#
#  created_at          :datetime         not null
#  maestro_campaign_id :bigint(8)
#  phone               :bigint(8)        primary key
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_maestro_phone_campaigns_on_maestro_campaign_id  (maestro_campaign_id)
#  index_maestro_phone_campaigns_on_phone                (phone) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (maestro_campaign_id => maestro_campaigns.id)
#

class MaestroPhoneCampaign < ApplicationRecord
  belongs_to :maestro_campaign
  self.primary_key = 'phone'
end
