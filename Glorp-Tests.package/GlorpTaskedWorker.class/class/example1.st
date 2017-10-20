as yet unclassified
example1
	"GlorpTaskedWorker example1"

	| workers tasks keys names |
	tasks := GlorpWorkerTask exampleTasks.
	keys := GlorpWorkerTask exampleTaskKeys.
	names := #('Jim' 'Tom' 'Lori' 'George' 'Jenny').
	workers := OrderedCollection new.
	1 to: 5 do: [:i|
		workers add: ((GlorpTaskedWorker new)
				id: i;
				name: (names at: i);
				addTask: (tasks at: i) key: (keys at: i);
				yourself)].
	^workers