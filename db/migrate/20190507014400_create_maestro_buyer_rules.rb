class CreateMaestroBuyerRules < ActiveRecord::Migration[5.2]
  def change
    create_table :maestro_buyer_rules do |t|
      t.references :maestro_buyer, foreign_key: true
      t.string :left_operand
      t.string :operator
      t.string :right_operand

      t.timestamps
    end
  end
end
