App.TaskSetController = Ember.ObjectController.extend({
	drawSchedule: function() {
		console.log("Drawwing Schedule");
	},
	delete: function(taskID) {
		console.log('deleting task id: ' + taskID);
		var task = App.Task.find(taskID);
		task.deleteRecord();
		this.get('store').commit();
		this.get('model').reload();
	},
	new: function() {
		console.log('new task');
		var ts = this.get('model');
		var task = App.Task.createRecord({taskSet: ts});
		ts.get('tasks').addObject(task);
	},
	save: function() {
		this.get('model').get('store').commit();
		this.get('model').reload();
	}
});