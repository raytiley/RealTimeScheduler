class TaskSetsController < ActionController::Base

	respond_to :json

	def index
		respond_with TaskSet.all
	end

	def create
		@task_set = TaskSet.new(params[:task_set])
		@task_set.save
		respond_with @task_set
	end

	def schedule
		@task_set = TaskSet.find(params[:id])
		render :json => @task_set.generate_schedule.to_json
	end
	
end