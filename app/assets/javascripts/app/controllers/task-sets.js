App.TaskSetsController = Ember.ArrayController.extend({
	newTaskName: "",
	save: function() {
		if(this.get('newTaskName')) {
			var newTaskSet = App.TaskSet.createRecord({name: this.newTaskName});
			newTaskSet.get('store').commit();
			this.set('newTaskName', '');
		}
	}
});