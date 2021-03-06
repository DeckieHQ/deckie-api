class CreateSubmissions < ActiveRecord::Migration[5.0]
  def up
    create_table(:submissions) do |t|
      t.belongs_to :event,   index: true
      t.belongs_to :profile, index: true

      t.integer :status, null: false

      t.index [:event_id, :profile_id], unique: true, where: 'deleted_at IS NULL'

      t.timestamps null: false

      t.datetime :deleted_at

      t.index :deleted_at
    end
  end

  def down
    drop_table :submissions
  end
end
