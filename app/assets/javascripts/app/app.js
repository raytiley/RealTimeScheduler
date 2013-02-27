App = Ember.Application.create({
	ready: function() {
		setInterval(function() {
			App.TaskSet.find();
			console.log("polling...");
		}, 5000);
	}
});

App.Store = DS.Store.extend({
  revision: 11
});

App.Router.map(function() {
  this.resource('taskSets', function() {
  	this.resource('taskSet', {path:':taskSet_id'});
  });
});

App.TaskSetsRoute = Ember.Route.extend({
	model: function() {
		return App.TaskSet.find();
	}
});

App.TaskSetRoute = Ember.Route.extend({
	model: function(params) {
		return App.TaskSet.find(params.taskSet_id);
	},
	renderTemplate: function(controller, model) {
		this.render('taskSet');
		this.render('graph', {outlet:'graph'});
	}
});

App.IndexRoute = Ember.Route.extend({
	redirect: function() {
		this.transitionTo('taskSets');
	}
});

Ember.Handlebars.registerBoundHelper('emptyText', function(taskSet) {
  if(taskSet.get('schedule').get('length') === 0 && taskSet.get('tasks').get('length') === 0) {
  	return "Schedule some tasks to get a schedule.";
  }

  return ":( Your Task Set Is Not Scheduleable By Me";
});