App.TaskSetsController = Ember.ArrayController.extend({
	newTaskName: "",
	save: function() {
		var newTaskSet = App.TaskSet.createRecord({name: this.newTaskName});
		newTaskSet.get('store').commit();
		this.newTaskName = "";
	}
});