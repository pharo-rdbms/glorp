initialize-release
initResultClass: aClass whereClause: theCriteria singleObject: aBoolean 
	resultClass := aClass.
	self whereClause: ((theCriteria isNil or: [theCriteria = true or: [theCriteria = false]]) ifTrue: [EmptyExpression on: theCriteria] ifFalse: [theCriteria]).
	readsOneObject := aBoolean.
	aBoolean ifTrue: [self limit: 1]