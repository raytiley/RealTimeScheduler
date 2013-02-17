require 'test_helper'

class TaskSetTest < ActiveSupport::TestCase
	test "Calculate Hyper Period" do
		ts = TaskSet.create(:name => "Silly Task Set",
     :tasks => [Task.new(:period => 5),
      Task.new(:period => 10),
      Task.new(:period => 15)])

		assert_equal "Silly Task Set", ts.name
		assert_equal 30, ts.hyper_period
  end

  test "Find highest priority task in the queue" do
    medium = Task.new(:period => 5, :deadline => 5)
    low = Task.new(:period => 10, :deadline => 10)
    high = Task.new(:period => 5, :deadline => 3)

    ts = TaskSet.new

  		# the get_highest_priority_task method takes an array of hashes
  		# try different orders to make sure order doesn't matter
  		queue_one = [{:task => high}, {:task => medium}, {:task => low}]
  		queue_two = [{:task => low}, {:task => high}, {:task => medium}]
  		queue_three = [{:task => medium}, {:task => low}, {:task => high}]

  		assert_equal high, ts.get_highest_priorty_task(queue_one)[:task]
  		assert_equal high, ts.get_highest_priorty_task(queue_two)[:task]
  		assert_equal high, ts.get_highest_priorty_task(queue_three)[:task]
  end

	test "Release of tasks" do
		ts = TaskSet.new(:name => "Awesome Task Set")
		low = Task.new(:period => 10, :deadline => 10, :offset => 0)
		medium = Task.new(:period => 5, :deadline => 5, :offset => 0)
		high = Task.new(:period => 5, :deadline => 3, :offset => 0)
		ts.tasks = [low, medium, high]

		ts.save

		# tasks should be rleased at 0 5 10 15 20
		
		# time 0 - all jobs should be released
		released_tasks = ts.get_released_jobs(0)
		tasks = released_tasks.map{|t| t[:task]}
		assert_equal 3, tasks.count
		assert tasks.include?(medium)
		assert tasks.include?(low)
		assert tasks.include?(high)

		# time 2 - Nothing released
		released_tasks = ts.get_released_jobs(2)
		assert_empty(released_tasks)

		#time 5 -medium and high released
		released_tasks = ts.get_released_jobs(5)
		tasks = released_tasks.map{|t| t[:task]}
		assert_equal 2, tasks.count
		assert tasks.include?(medium)
		assert tasks.include?(high)

		# time 7 - Nothing released
		released_tasks = ts.get_released_jobs(7)
		assert_empty(released_tasks)

		# time 10 - all jobs should be released
		released_tasks = ts.get_released_jobs(10)
		tasks = released_tasks.map{|t| t[:task]}
		assert_equal 3, tasks.count
		assert tasks.include?(medium)
		assert tasks.include?(low)
		assert tasks.include?(high)

		# time 12 - Nothing released
		released_tasks = ts.get_released_jobs(12)
		assert_empty(released_tasks)

		#time 15 -medium and high released
		released_tasks = ts.get_released_jobs(15)
		tasks = released_tasks.map{|t| t[:task]}
		assert_equal 2, tasks.count
		assert tasks.include?(medium)
		assert tasks.include?(high)

		# time 17 - Nothing released
		released_tasks = ts.get_released_jobs(17)
		assert_empty(released_tasks)

		# time 20 - all jobs should be released
		released_tasks = ts.get_released_jobs(20)
		tasks = released_tasks.map{|t| t[:task]}
		assert_equal 3, tasks.count
		assert tasks.include?(medium)
		assert tasks.include?(low)
		assert tasks.include?(high)
	end

	test "Release with offset" do
		ts = TaskSet.new(:name => "Awesome Task Set")
		task = Task.new(:period => 10, :deadline => 10, :offset => 3)
		ts.tasks = [task]

		ts.save

		# task should be released at 3, 13, 23

		# time 0 - Nothing released
		released_tasks = ts.get_released_jobs(0)
		assert_empty(released_tasks)

		# time 3
		released_tasks = ts.get_released_jobs(3)
		tasks = released_tasks.map{|t| t[:task]}
		assert_equal 1, tasks.count
		assert tasks.include?(task)

		# time 10 - Nothing released
		released_tasks = ts.get_released_jobs(10)
		assert_empty(released_tasks)

		# time 13
		released_tasks = ts.get_released_jobs(13)
		tasks = released_tasks.map{|t| t[:task]}
		assert_equal 1, tasks.count
		assert tasks.include?(task)

		# time 20 - Nothing released
		released_tasks = ts.get_released_jobs(10)
		assert_empty(released_tasks)

		# time 23
		released_tasks = ts.get_released_jobs(23)
		tasks = released_tasks.map{|t| t[:task]}
		assert_equal 1, tasks.count
		assert tasks.include?(task)
	end

	test "Fail impossible schedule" do
		ts = TaskSet.new(:name => "Awesome Task Set")
		medium = Task.new(:period => 10, :worst_case_execution_time => 5,
     :deadline => 10, :offset => 0,
     :name => "Task Medium")
		high = Task.new(:period => 10, :worst_case_execution_time => 5,
     :deadline => 5, :offset => 0,
     :name => "Task High")
		low = Task.new(:period => 10, :worst_case_execution_time => 1, 
     :deadline => 10, :offset => 0,
     :name => "Task Low")
		ts.tasks = [low, medium, high]

		ts.save

		schedule = ts.generate_schedule

		assert_nil schedule
	end

	test "Schedule simple schedule" do
		ts = TaskSet.new(:name => "Awesome Task Set")
		task_one = Task.new(:period => 10, :worst_case_execution_time => 5,
     :deadline => 10, :offset => 0,
     :name => "Task One")
		task_two = Task.new(:period => 10, :worst_case_execution_time => 5,
     :deadline => 5, :offset => 0,
     :name => "Task Two")
		ts.tasks = [task_one, task_two]

		ts.save

		expected_schedule = ["Task Two", "Task Two", "Task Two", "Task Two", "Task Two",
      "Task One", "Task One", "Task One", "Task One", "Task One"]
      schedule = ts.generate_schedule

      assert_equal expected_schedule, schedule
  end
  
end
