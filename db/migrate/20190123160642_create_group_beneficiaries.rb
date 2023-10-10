class CreateGroupBeneficiaries < ActiveRecord::Migration[5.2]
  def change
    create_table :group_beneficiaries do |t|
      t.references :group, foreign_key: true
      t.references :beneficiary

      t.timestamps
    end
    add_foreign_key :group_beneficiaries, :user_accesses, column: :beneficiary_id, primary_key: :id
    add_index :group_beneficiaries, [:group_id, :beneficiary_id], unique: true
  end
end
