require 'citrus'

module RulesEngine
  Citrus.load 'rules/logic'

  class AndExpressionParser
    def initialize(and_clauses)
      # initialize with [] of Rule objects to be ANDed
      @and_clauses = and_clauses
    end

    def and_conjunction
      @and_clauses.map {|clause| clause.to_s}.join(' AND ')
    end

    def value
      Logic.parse(and_conjunction).value
    end
  end

end