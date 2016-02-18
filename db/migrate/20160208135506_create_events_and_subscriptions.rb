class CreateEventsAndSubscriptions < ActiveRecord::Migration[5.0]
  def up
    create_table(:events) do |t|
      t.string :title,    null: false
      t.string :category, null: false
      t.string :ambiance, null: false
      t.string :level,    null: false

      t.integer :capacity, null: false

      t.boolean :invite_only, null: false, default: false

      t.text :description

      t.datetime :begin_at, null: false
      t.datetime :end_at,   null: false

      t.decimal :latitude,  precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6

      t.string :street,   null: false
      t.string :postcode, null: false
      t.string :city,     null: false
      t.string :state
      t.string :country,  null: false

      t.timestamps null: false

      t.belongs_to :profile, index: true
    end

    create_table(:subscriptions) do |t|
      t.belongs_to :event,   index: true
      t.belongs_to :profile, index: true

      t.timestamps null: false
    end
  end

  def down
    drop_table :subscriptions
    drop_table :events
  end
end
