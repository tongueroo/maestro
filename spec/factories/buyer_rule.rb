FactoryBot.define do
  factory :maestro_buyer_rule do
    left_operand  {'age'}
    operator {'<'}
    right_operand {70}
  end
end
