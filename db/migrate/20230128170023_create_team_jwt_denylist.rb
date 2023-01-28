class CreateTeamJwtDenylist < ActiveRecord::Migration[7.0]
  def change
    create_table :team_jwt_denylist do |t|
      t.string :jti, null: false
      t.datetime :exp, null: false
    end
    add_index :team_jwt_denylist, :jti
  end
end
