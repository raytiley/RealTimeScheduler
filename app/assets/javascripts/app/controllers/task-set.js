App.TaskSetController = Ember.ObjectController.extend({
	delete: function(taskID) {
		var task = App.Task.find(taskID);
		task.on('didDelete', function() {
			App.TaskSet.find();
		});

		task.deleteRecord();
		this.get('store').commit();
	},
	newTask: function() {
		var ts = this.get('model');
		var task = App.Task.createRecord({
			taskSet: ts,
			name: this.get('newName'),
			period: this.get('newPeriod'),
			deadline: this.get('newDeadline'),
			worstCaseExecutionTime: this.get('newWCET'),
			offset: this.get('newOffset')
		});
		task.on('didCreate', function() {
			ts.reload();
		})
		task.get('store').commit();
		this.resetNewInputs();
	},
	newName: "",
	newPeriod: "",
	newDeadline: "",
	newWCET: "",
	newOffset: "",
	resetNewInputs: function() {
		this.set('newName', '');
		this.set('newPeriod', '');
		this.set('newDeadline', '');
		this.set('newWCET', '');
		this.set('newOffset', '');
	}
});