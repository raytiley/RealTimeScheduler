class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :period
      t.integer :worst_case_execution_time
      t.integer :offset
      t.integer :deadline
      t.string :name

      t.timestamps
    end
  end
end
