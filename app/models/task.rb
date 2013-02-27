class Task < ActiveRecord::Base
  attr_accessible :deadline, :name, :offset, :period, :worst_case_execution_time, :task_set_id

  belongs_to :task_set

  def self.idle
  	t = Task.new(:name => "Idle", :period =>1)
  	t.id = 0
  	t
  end
end
