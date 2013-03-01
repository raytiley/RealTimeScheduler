App.TaskSet = DS.Model.extend({
  name: DS.attr('string'),
  tasks: DS.hasMany('App.Task'),
  schedule: DS.hasMany('App.Task'),
  graph: function() {
  	var element = document.createElement("div");

  	var lanes = this.get('tasks').map(function(task){return task.get('name');}),
			laneLength = lanes.length,
			items = this.get('graphItems'),
			timeBegin = 0,
			timeEnd = this.get('schedule').get('length');

		var m = [0, 5, 0, 50], //top right bottom left
			w = 900 - m[1] - m[3],
			h = laneLength * 20 + 50,
			miniHeight =h;

		//scales
		var x = d3.scale.linear()
				.domain([timeBegin, timeEnd])
				.range([0, w]);
		var x1 = d3.scale.linear()
				.range([0, w]);
		var y2 = d3.scale.linear()
				.domain([0, laneLength])
				.range([0, miniHeight]);

		var chart = d3.select(element)
					.append("svg")
					.attr("width", w + m[1] + m[3])
					.attr("height", h + m[0] + m[2])
					.attr("class", "chart");
		
		chart.append("defs").append("clipPath")
			.attr("id", "clip")
			.append("rect")
			.attr("width", w)
			.attr("height", miniHeight);

		var mini = chart.append("g")
					.attr("transform", "translate(" + m[3] + "," + (m[0]) + ")")
					.attr("width", w)
					.attr("height", miniHeight)
					.attr("class", "mini");
		
		//mini lanes and texts
		mini.append("g").selectAll(".laneLines")
			.data(items)
			.enter().append("line")
			.attr("x1", 0)
			.attr("y1", function(d) {return y2(d.lane);})
			.attr("x2", w)
			.attr("y2", function(d) {return y2(d.lane);})
			.attr("stroke", "lightgray");


		mini.append("g").selectAll(".laneText")
			.data(lanes)
			.enter().append("text")
			.text(function(d) {return d;})
			.attr("x", -m[1])
			.attr("y", function(d, i) {return y2(i + .5);})
			.attr("dy", ".5ex")
			.attr("text-anchor", "end")
			.attr("class", "laneText");

		
		//mini item rects
		mini.append("g").selectAll("miniItems")
			.data(items)
			.enter().append("rect")
			.attr("class", function(d) {return "miniItem" + d.lane;})
			.attr("x", function(d) {return x(d.start);})
			.attr("y", function(d) {return y2(d.lane + .5) - 5;})
			.attr("width", function(d) {return x(d.end - d.start);})
			.attr("height", 15);

			return $(element).html();

  }.property('schedule.@each'),
  graphItems: function() {
  	var items = new Array;
  	var start = 0,
  		current = this.get('schedule').get('firstObject');

  	this.get('schedule').forEach(function(item, index) {
  		if(item.get('id') !== current.get('id') || index === (this.get('schedule').get('length') -1)) {
  			//We've switched tasks push the finishing task
  			items.push({lane: this.get('tasks').indexOf(current), id: current.get('name'), start: start, end: index});
  			start = index;
  			current = item;
  		}
  	}, this);
  	return items;
  }.property('schedule.@each')
});