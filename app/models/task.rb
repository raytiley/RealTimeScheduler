class Task < ActiveRecord::Base
  attr_accessible :deadline, :name, :offset, :period, :worst_case_execution_time, :task_set_id
  belongs_to :task_set
  before_save :massage_data

  def self.idle
  	t = Task.new(:name => "Idle", :period =>1)
  	t.id = 0
  	t
  end

  def massage_data
  	self.offset ||= 0
  	self.period ||= 0
  	self.worst_case_execution_time ||=0
  	self.worst_case_execution_time = self.period if self.worst_case_execution_time > self.period
  	self.deadline ||= self.period
  	self.deadline = self.period if self.deadline > self.period || self.deadline = 0
  end
end
