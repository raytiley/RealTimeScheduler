class HomeController < ApplicationController
	def index
		@task_sets = TaskSet.all
	end
end
