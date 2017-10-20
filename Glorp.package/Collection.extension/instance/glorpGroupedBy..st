*Glorp
glorpGroupedBy: aBlock
	"Same as VW groupedBy:. This is too useful not to be able to use, but we don't want to conflict with other dialects/extensions that might implement, so make our own prefixed version"

	"Return a dictionary whose keys are the result of evaluating aBlock for all elements in
	 the collection, and the value for each key is the collection of elements that evaluated
	 to that key. e.g.
	     #(1 2 3 4 5) groupedBy: [:each | each odd]
	   a Dictionary  
	     true ---> #( 1 3 5)
	     false --> #(2 4)"

	| result |
	result := Dictionary new.
	self do:
		[:each | | key collection |
		key := aBlock value: each.
		collection := result at: key ifAbsentPut: [OrderedCollection new].
		collection add: each].
	self species ~~ OrderedCollection ifTrue:
		["Convert the result collections to be the right type.
		  Note that it should be safe to modify the dictionary
		  while iterating because we only replace values for existing keys"
		result keysAndValuesDo:
			[:key :value | result at: key put: (self species withAll: value)]].

	^result