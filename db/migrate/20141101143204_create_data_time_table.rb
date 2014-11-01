class CreateDataTimeTable < ActiveRecord::Migration
  def change
    create_table :data_times do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.integer :collection_id
      t.float :seconds
    end
  end
end
