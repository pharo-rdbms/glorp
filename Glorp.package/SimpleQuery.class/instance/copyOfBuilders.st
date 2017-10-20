preparing
copyOfBuilders 
	"Copy the builders, but make sure that subBuilders also get matched up"
	| newBuilders |
	newBuilders := builders collect: [:each | each copy].
	newBuilders do: [:each | each reconcileWithBuilders: builders andCopy: newBuilders].
	^newBuilders