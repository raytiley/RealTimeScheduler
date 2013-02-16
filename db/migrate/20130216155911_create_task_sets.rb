class CreateTaskSets < ActiveRecord::Migration
  def change
    create_table :task_sets do |t|
      t.string :name

      t.timestamps
    end
  end
end
