module RulesEngine
  class ObjectRulesAndParser
    def initialize(and_clauses)
      # initialize with [] of RuleFromObject objects to be ANDed
      @and_clauses = and_clauses
    end

    def evaluate(obj)
      rules = @and_clauses.map {|rule| rule.make_rule(obj)}
      AndExpressionParser.new(rules).value
    end
  end
end