class TasksController < ActionController::Base
	
	respond_to :json

	def index
		@tasks = Task.all.to_a
		@tasks << Task.idle
		respond_with @tasks
	end
	def show
		@task = Task.find(params[:id])
		respond_with @task
    end

    def create
    	@task = Task.create(params[:task])
    	respond_with @task
    end

    def update
    	@task = Task.find(params[:id])
    	@task.update_attributes(params[:task])
    	respond_with @task
    end

    def destroy
    	@task = Task.find(params[:id])
    	@task.delete
    	respond_to do |format|
    		format.json {head :no_content}
    	end
    end
end