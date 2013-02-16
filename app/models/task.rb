class Task < ActiveRecord::Base
  attr_accessible :deadline, :name, :offset, :period, :worst_case_execution_time

  belongs_to :task_set
end
