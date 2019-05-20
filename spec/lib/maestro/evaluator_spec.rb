describe 'Maestro Evaluator' do

  let(:lead) {
    lead_hash = { 'first_name' => 'Jane', 'last_name' => 'Doe', 'city' => 'seattle', 'state' => 'WA', 'zip' => '98004', 'age' => 30, 'weight' => 150, 'tcpa_accepted' => true }
    JSON.parse(lead_hash.to_json, object_class: OpenStruct)
  }

  let(:buyer) {
    create(:maestro_buyer, {name: 'Marchex'}) do |byer|
      create(:maestro_buyer_rule, {left_operand: 'age', operator: '<', right_operand: 70 }) do |rule|
        byer.maestro_buyer_rules = [rule]
      end
    end
  }

  let(:buyer2) {
    create(:maestro_buyer, {name: 'Avenge'}) do |byer|
      create(:maestro_buyer_rule, {left_operand: 'weight', operator: '<', right_operand: 140 }) do |rule|
        byer.maestro_buyer_rules = [rule]
      end
    end
  }

  let(:buyer3) {
    create(:maestro_buyer, {name: 'Pinnacle'}) do |byer|
      create(:maestro_buyer_rule, {left_operand: 'weight', operator: '<', right_operand: 160 }) do |rule|
        byer.maestro_buyer_rules = [rule]
      end
      create(:maestro_buyer_rule, {left_operand: 'age', operator: '<', right_operand: 70 }) do |rule|
        byer.maestro_buyer_rules << rule
      end
    end
  }

  let(:campaign) {
    create(:maestro_campaign, {name: 'Health'}) do |cmpgn|
      create(:maestro_campaign_buyer, { priority: 6, maestro_buyer: buyer, maestro_campaign: cmpgn } ) do |campaign_buyer|
        cmpgn.maestro_campaign_buyers = [campaign_buyer]
      end
      create(:maestro_campaign_buyer, { priority: 4, maestro_buyer: buyer2, maestro_campaign: cmpgn } ) do |campaign_buyer|
        cmpgn.maestro_campaign_buyers << campaign_buyer
      end
      create(:maestro_campaign_buyer, { priority: 7, maestro_buyer: buyer3, maestro_campaign: cmpgn } ) do |campaign_buyer|
        cmpgn.maestro_campaign_buyers << campaign_buyer
      end
    end
  }

  let(:new_campaign) {
    create(:maestro_campaign, {name: 'Nuevo'})
  }

  context 'evaluating leads for maestro campaigns' do

    maestro = Maestro::Evaluator.new

    it 'lead should be selected by two buyers' do
      buyers = maestro.interested_buyers(lead, campaign)
      expect(buyers.count).to eq 2
      expect(buyers.map(&:name)).to include ('Marchex')
      expect(buyers.map(&:name)).to include ('Pinnacle')
    end

    it 'the returned list of buyers should be ordered by priority' do
      buyers = maestro.interested_buyers(lead, campaign)
      expect(buyers[0].name).to eq 'Marchex'
      expect(buyers[1].name).to eq 'Pinnacle'
    end

  end

  context 'deserializing rules from the database' do
    maestro = Maestro::Evaluator.new

    it 'should deserialize a string' do
      str = maestro.convert_operand_to_correct_type('"Quick brown fox"')
      expect(str).to eq "Quick brown fox"
    end

    it 'should deserialize an integer' do
      num = maestro.convert_operand_to_correct_type('12000')
      expect(num).to eq 12000
    end

    it 'should deserialize a float' do
      num = maestro.convert_operand_to_correct_type('120.79')
      expect(num).to eq 120.79
    end

    it 'should deserialize an array' do
      arr = maestro.convert_operand_to_correct_type('["WA", "OR"]')
      expect(arr).to eq ["WA", "OR"]
    end

  end
end