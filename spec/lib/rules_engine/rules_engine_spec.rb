describe RulesEngine do

  let(:lead) {
    lead_hash = { 'first_name' => 'Jane', 'last_name' => 'Doe', 'city' => 'seattle', 'state' => 'WA', 'zip' => '98004', 'age' => 30, 'weight' => 150, 'tcpa_accepted' => true }
    JSON.parse(lead_hash.to_json, object_class: OpenStruct)
  }

  context 'basic rules' do

    it 'should initialize a single inequality rule' do
      rule = RulesEngine::Rule.new(80, '>', 40)
      expect(rule.to_s).to eq '80 > 40'
    end

    it 'should evaluate a single inequality rule' do
      rule = RulesEngine::Rule.new(80, '>', 40)
      eng = RulesEngine::AndExpressionParser.new([rule])
      expect(eng.value).to be(true)
    end

    it 'should evaluate a single contains rule' do
      rule = RulesEngine::Rule.new('"vodka"', 'in', ['tequila', 'gin', 'vodka'])
      eng = RulesEngine::AndExpressionParser.new([rule])
      expect(eng.value).to be(true)
    end

    it 'should evaluate multiple rules' do
      rule1 = RulesEngine::Rule.new(80, '>', 40)
      rule2 = RulesEngine::Rule.new(80, '==', 80)
      rule3 = RulesEngine::Rule.new('"football"', '==', '"football"')
      rule4 = RulesEngine::Rule.new('"vodka"', 'in', ['tequila', 'gin', 'vodka'])
      rule5 = RulesEngine::Rule.new(false, '==', false)
      rule6 = RulesEngine::Rule.new(true, '==', true)
      eng = RulesEngine::AndExpressionParser.new([rule1, rule2, rule3, rule4, rule5, rule6])
      expect(eng.value).to be(true)
    end

  end

  context 'object rules' do

    it 'should make a basic rule from a lead rule' do
      lR = RulesEngine::RuleFromObject.new('city', '==', 'seattle')
      rule = lR.make_rule(lead)
      expect(rule.to_s).to eq '"seattle" == "seattle"'
    end

    it 'should evaluate a basic rule' do
      lR = RulesEngine::RuleFromObject.new('city', '==', 'seattle')
      rule = lR.make_rule(lead)
      eng = RulesEngine::AndExpressionParser.new([rule])
      expect(eng.value).to be(true)
    end

    it 'should evaluate a single less than lead rule' do
      lR = RulesEngine::RuleFromObject.new('age', '<', 70)
      eng = RulesEngine::ObjectRulesAndParser.new([lR])
      expect(eng.evaluate(lead)).to be(true)
    end

    it 'should evaluate a single less than or equal lead rule' do
      lR = RulesEngine::RuleFromObject.new('age', '<=', 70)
      eng = RulesEngine::ObjectRulesAndParser.new([lR])
      expect(eng.evaluate(lead)).to be(true)
    end

    it 'should evaluate a single greater than lead rule' do
      lR = RulesEngine::RuleFromObject.new('age', '>', 20)
      eng = RulesEngine::ObjectRulesAndParser.new([lR])
      expect(eng.evaluate(lead)).to be(true)
    end

    it 'should evaluate a single greater than or equal lead rule' do
      lR = RulesEngine::RuleFromObject.new('age', '>=', 20)
      eng = RulesEngine::ObjectRulesAndParser.new([lR])
      expect(eng.evaluate(lead)).to be(true)
    end

    it 'should evaluate a single inequality lead rule' do
      lR = RulesEngine::RuleFromObject.new('age', '!=', 10)
      eng = RulesEngine::ObjectRulesAndParser.new([lR])
      expect(eng.evaluate(lead)).to be(true)
    end

    it 'should evaluate a AND conjunction of 2 lead rules' do
      lR1 = RulesEngine::RuleFromObject.new('age', '<', 70)
      lR2 = RulesEngine::RuleFromObject.new('age', '>', 20)
      eng = RulesEngine::ObjectRulesAndParser.new([lR1, lR2])
      expect(eng.evaluate(lead)).to be(true)
    end

    it 'should evaluate true if two strings are the same' do
      lR = RulesEngine::RuleFromObject.new('city', '==', 'seattle')
      eng = RulesEngine::ObjectRulesAndParser.new([lR])
      expect(eng.evaluate(lead)).to be(true)
    end

    it 'should evaluate false if two strings are different' do
      lR = RulesEngine::RuleFromObject.new('city', '==', 'bellevue')
      eng = RulesEngine::ObjectRulesAndParser.new([lR])
      expect(eng.evaluate(lead)).to be(false)
    end

    it 'should evaluate string equality AND numeric inequality' do
      lR1 = RulesEngine::RuleFromObject.new('city', '==', 'seattle')
      lR2 = RulesEngine::RuleFromObject.new('age', '>', 20)
      eng = RulesEngine::ObjectRulesAndParser.new([lR1, lR2])
      expect(eng.evaluate(lead)).to be(true)
    end

    it 'should evaluate numeric equality' do
      lR = RulesEngine::RuleFromObject.new('weight', '==', 150)
      eng = RulesEngine::ObjectRulesAndParser.new([lR])
      expect(eng.evaluate(lead)).to be(true)
    end

    it 'should evaluate booleans' do
      lR = RulesEngine::RuleFromObject.new('tcpa_accepted', '==', true)
      eng = RulesEngine::ObjectRulesAndParser.new([lR])
      expect(eng.evaluate(lead)).to be(true)
    end

    it 'should combine rules for booleans, strings and integers' do
      lR1 = RulesEngine::RuleFromObject.new('city', '==', 'seattle')
      lR2 = RulesEngine::RuleFromObject.new('age', '>', 20)
      lR3 = RulesEngine::RuleFromObject.new('tcpa_accepted', '==', true)
      eng = RulesEngine::ObjectRulesAndParser.new([lR1, lR2, lR3])
      expect(eng.evaluate(lead)).to be(true)
    end

    it 'should evaluate true if a string exists in a list' do
      lR = RulesEngine::RuleFromObject.new('city', 'in', ['bellevue', 'seattle'])
      eng = RulesEngine::ObjectRulesAndParser.new([lR])
      expect(eng.evaluate(lead)).to be(true)
    end

    it 'should evaluate false if a string does not exist in a list' do
      lR = RulesEngine::RuleFromObject.new('city', 'in', ['bellevue', 'kirkland'])
      eng = RulesEngine::ObjectRulesAndParser.new([lR])
      expect(eng.evaluate(lead)).to be(false)
    end

    it 'should be able to combine contains with inequality' do
      lR1 = RulesEngine::RuleFromObject.new('city', 'in', ['bellevue', 'seattle'])
      lR2 = RulesEngine::RuleFromObject.new('age', '>', 20)
      eng = RulesEngine::ObjectRulesAndParser.new([lR1, lR2])
      expect(eng.evaluate(lead)).to be(true)
    end

  end

end