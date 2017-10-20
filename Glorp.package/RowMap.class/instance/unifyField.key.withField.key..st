api
unifyField: eachSourceField key: sourceObject withField: eachTargetField key: targetObject
	| sourceRow targetRow |
	sourceRow := self findOrAddRowForTable: eachSourceField table withKey: sourceObject.
	targetRow := self findOrAddRowForTable: eachTargetField table withKey: targetObject.
	sourceRow unifyField: eachSourceField withField: eachTargetField inRow: targetRow