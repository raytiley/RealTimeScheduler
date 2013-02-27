App.Task = DS.Model.extend({
  name: DS.attr('string'),
  period: DS.attr('number'),
  worstCaseExecutionTime: DS.attr('number'),
  offset: DS.attr('number'),
  deadline: DS.attr('number'),
  taskSet: DS.belongsTo('App.TaskSet')
});