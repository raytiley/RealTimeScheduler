App.TaskSetController = Ember.ObjectController.extend({
	delete: function(taskID) {
		var task = App.Task.find(taskID);
		task.deleteRecord();
		this.get('store').commit();
		this.get('model').reload();
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
		task.get('store').commit();
		this.resetNewInputs();
		ts.reload();
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