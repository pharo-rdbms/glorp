actions
removeTaskAtKey: aString
	tasks removeKey: aString ifAbsent: [self error: 'Task not found.']