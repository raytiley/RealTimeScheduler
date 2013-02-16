class AddTaskSetIdToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :task_set_id, :integer
  end
end
