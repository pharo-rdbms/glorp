api
unifyField: sourceField key: sourceObject withField: targetField key: targetObject transformationForward: forwardTransformation inverse: inverseTransformation
	| sourceRow targetRow existingWrapper newWrapper |
	sourceRow := self findOrAddRowForTable: sourceField table withKey: sourceObject.
	targetRow := self findOrAddRowForTable: targetField table withKey: targetObject.
	sourceRow unifyField: sourceField withField: targetField inRow: targetRow.
	existingWrapper := targetRow wrapperAt: targetField.
	(existingWrapper class == TransformingFieldValueWrapper and: [
		existingWrapper forwardTransformation == forwardTransformation and: [
			existingWrapper inverseTransformation == inverseTransformation]])
				ifTrue: [^self].
	newWrapper := (TransformingFieldValueWrapper new)
		innerWrapper: existingWrapper;
		forwardTransformation: forwardTransformation;
		inverseTransformation: inverseTransformation.
	targetRow wrapperAt: targetField put: newWrapper