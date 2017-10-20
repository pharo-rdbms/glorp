fields
addField: aField

	fields add: aField.
	aField isPrimaryKey ifTrue: [
		self addAsPrimaryKeyField: aField].
	aField table: self.
	aField position: fields size.
	^aField.