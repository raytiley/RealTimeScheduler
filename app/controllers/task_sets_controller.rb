class TaskSetsController < ActionController::Base

	respond_to :json

	def index
		respond_with TaskSet.all
	end

	def show
		@task_set = TaskSet.find(params[:id])
		respond_with @task_set
	end

	def create
		@task_set = TaskSet.new(params[:task_set])
		@task_set.save
		respond_with @task_set
	end

	def schedule
		@schedule = TaskSet.find(params[:id]).generate_schedule
		render :json  => {"schedule" =>@schedule}.to_json
	end

	def verify
		@task_set = TaskSet.find(params[:id])
		@schedule = params[:schedule]

		begin
			@task_set.verify @schedule
		rescue Exception => e
			render :json => {"error" => e.message}
			return
		end

		render :json  => "Schedule Verified"

	end
	
end