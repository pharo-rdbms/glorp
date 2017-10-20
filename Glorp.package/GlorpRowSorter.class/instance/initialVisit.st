sorting
initialVisit
	| children |
	children := self currentChildren select: [:each  | each status == #notVisited].
	children do: [:each | each parent: current].
	queue addAll: children.
	current status: #visitedOnce.
	children isEmpty ifTrue: [queue add: current].