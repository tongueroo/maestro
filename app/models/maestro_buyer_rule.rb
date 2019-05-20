# == Schema Information
#
# Table name: maestro_buyer_rules
#
#  created_at       :datetime         not null
#  id               :bigint(8)        not null, primary key
#  left_operand     :string
#  maestro_buyer_id :bigint(8)
#  operator         :string
#  right_operand    :string
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_maestro_buyer_rules_on_maestro_buyer_id  (maestro_buyer_id)
#
# Foreign Keys
#
#  fk_rails_...  (maestro_buyer_id => maestro_buyers.id)
#

class MaestroBuyerRule < ApplicationRecord
  belongs_to :maestro_buyer
end
