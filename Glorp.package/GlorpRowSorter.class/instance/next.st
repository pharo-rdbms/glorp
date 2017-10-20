sorting
next
	queue isEmpty ifTrue: [
		| candidate |
		candidate := items detect: [:each | each status == #notVisited] ifNone: [nil].
		candidate isNil ifTrue: [
			"We're probably at the end, but check again for part-way done nodes, which can happen if there are heavy cycles"
			items reset. 
			candidate := items detect: [:each | each status == #visitedOnce] ifNone: [nil]].
		candidate isNil ifFalse: [queue add: candidate]].
	current := queue isEmpty ifTrue: [nil] ifFalse: [queue removeFirst].