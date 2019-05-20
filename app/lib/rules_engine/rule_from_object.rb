module RulesEngine
  class RuleFromObject
    def initialize(attribute, operator, expected_value)
      # initialize the rule with the attribute name of the object being tested, the operator used for the test and the expected value
      # ex: RuleFromObject.new('age', '<', 70)
      @attribute = attribute
      @operator = operator
      @expected_value = expected_value
    end

    def make_rule(obj)
      # given an object of the right form, return a rule object, plugging in values from the attribute
      Rule.new(quote_attribute(obj, @attribute), @operator, quote(@expected_value))
    end

    def quote_attribute(obj, attrib)
      quote(obj.send(attrib))
    end

    def quote(val)
      val.is_a?(String) ? '"' + val + '"' : val
    end
  end
end