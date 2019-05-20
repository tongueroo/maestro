module Maestro
  class Evaluator
    def convert_operand_to_correct_type(operand)
      op = operand.strip
      if (op[0] == '[' && op[-1] == ']') #array
        arr = op[1..-2].split(',')
        # remove extra quotes for strings in array, others are numbers so convert to number
        arr.map {|d|
          token = d.strip
          if token[0] == '"' && token[-1] == '"'
            token[1..-2]
          else
            token.to_f
          end
        }
      elsif (op[0] == '"' && op[-1] == '"') #string
        op[1..-2]
      else #number
        op.to_f
      end
    end

    def object_rule_from(rule)
      # given a rule from the database, return an object rule that the parser understands
      RulesEngine::RuleFromObject.new(rule.left_operand, rule.operator, convert_operand_to_correct_type(rule.right_operand))
    end

    def buyer_from_rules(rules)
      rules.map(&:maestro_buyer_id).to_set.first
    end

    def evaluate_lead_filters(lead, rules)
      # given rules from the database, evaluate them on the given lead
      object_rules = rules.map {|rule| object_rule_from(rule)}
      eng = RulesEngine::ObjectRulesAndParser.new(object_rules)
      res = eng.evaluate(lead)
      Maestro::Logger.log({:message => "Evaluating lead with ID #{lead.id} for buyer #{buyer_from_rules(rules)} resulted in #{res}"})
      res
    end

    def evaluate_lead_filters_for_buyer(lead, buyer)
      # apply the filters for the buyer on the lead and return true/false
      Maestro::Logger.log({:message => "Evaluating lead with ID #{lead.id} against rules for Maestro Buyer #{buyer.id} : #{buyer.name}"})
      rules = MaestroBuyerRule.where(maestro_buyer_id: buyer.id)
      puts ("rules: #{rules.inspect}")
      evaluate_lead_filters(lead, rules)
    end

    def interested_buyers(lead, campaign)
      # return the sorted list of buyers who are willing to accept this lead
      Maestro::Logger.log({:message => "Evaluating lead with ID #{lead.id} against Maestro Campaign #{campaign.id} : #{campaign.name}"})
      campaign.maestro_campaign_buyers.includes(:maestro_buyer).sort_by(&:priority).select { |campaign_buyer|
        buyer = campaign_buyer.maestro_buyer
        Maestro::Logger.log({:message => "Evaluating lead with ID #{lead.id} against Maestro Buyer #{buyer.id} : #{buyer.name}"})
        buyer.active && evaluate_lead_filters_for_buyer(lead, buyer)
      }.map(&:maestro_buyer)
    end
  end
end