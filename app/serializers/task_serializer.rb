class TaskSerializer < ActiveModel::Serializer
  embed :ids

  attributes :id, :name, :period, :worst_case_execution_time, :offset, :deadline
  has_one :task_set
end
