class TaskSet < ActiveRecord::Base
  attr_accessible :name, :tasks
  has_many :tasks

  validates_uniqueness_of :name

  def hyper_period
  	#check for tasks
    return 0 unless self.tasks.count > 0

    # hyper perid = lowest common multiple of all periods in task set
  	periods = self.tasks.pluck(:period)
  	periods.inject(:lcm)
  end

  def get_released_jobs(time)
  	# find all the tasks releaed at given time
  	tasks = self.tasks.select {|task| (time - task.offset) % task.period == 0}

  	# return array of  hashes containing task and deadline
  	tasks.map do |task|
  		{:task => task, :deadline => time + (task.deadline - task.offset)}
  	end
  end

  def get_highest_priorty_task(jobs)
  	#sort tasks by deadline and then return first task
  	jobs.sort!{|a, b| a[:task].deadline <=> b[:task].deadline }
  	jobs[0];
  end

  # return's an array the size of the hyper period
  # each slot ether has nil for idle or the name of the task executing
  def generate_schedule
  	schedule = Array.new
  	queue = Array.new
  	current_job = nil
  	current_job_execution_time = 0

  	for time in 0...hyper_period
  		# add released tasks to queue
  		queue += get_released_jobs time

  		# give the current job credit for execution in last step
  		current_job_execution_time += 1 unless current_job.nil?

  		#check if current task is finished
  		if !!current_job and current_job[:task].worst_case_execution_time == current_job_execution_time
  			#task is finished
  			current_job = nil
  			current_job_execution_time = 0
  		end

  		#find a task to execute
  		if current_job.nil?
  			current_job = get_highest_priorty_task(queue)
  			queue.delete(current_job)
  		end

  		# if we are missing a deadline task set is not schedulable
  		if !!current_job and time >= current_job[:deadline]
  			return nil
  		end

  		# add current job to schedule
  		schedule.push(current_job.nil? ? nil : current_job[:task].name)

  		#log whats executing in this slot
  		#puts "Slot #{time + 1} " + (current_job.nil? ? "Idle" : current_job[:task].name)
  	end

  	# if queue isn't empty, then return nil
  	return nil unless queue.empty?

  	#return schedule
  	schedule
  end

  def verify(schedule)
  	# basic sanity check. does the provided schedule equal the hyperperiod?
  	if(schedule.count != hyper_period)
  		raise "Provided schedule not equal to hyper-period of #{hyper_period}"
  	end

  	#verify each task in the set
  	self.tasks.each do |task|
  		verify_task(schedule, task)
  	end
  end

  def verify_task(schedule, task)
  	#slice the schedule into periods for the task
  	schedule.each_slice(task.period) do |period|

  		# get all occurence of task in period
  		tasks = period.select{|t| t == task.name}
  		
  		# make sure schedule has given task enough time to complete (WCET)
  		unless tasks.count == task.worst_case_execution_time
  			raise "Task #{task.name} not given enough execution time" 
  		end

  		# make sure last occurence of task in period is before deadline
  		unless period.rindex(task.name) <= task.deadline
  			raise "Task #{task.name} missed deadline"
  		end
  	end
  end

end
