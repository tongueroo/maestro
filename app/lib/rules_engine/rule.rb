module RulesEngine
  class Rule
    def initialize(left_operand, operator, right_operand)
      @left_operand = left_operand
      @operator = operator
      @right_operand = right_operand
    end

    def array_string(operand)
      # build the string representation for the array the grammar parser expects (no commas)
      operand.to_s.split('", "').join('" "')
    end

    def to_s
      [@left_operand, @operator, @right_operand.kind_of?(Array) ? array_string(@right_operand) : @right_operand].join(' ')
    end
  end
end