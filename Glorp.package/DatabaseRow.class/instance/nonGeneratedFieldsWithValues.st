accessing
nonGeneratedFieldsWithValues
	"Return a list of our fields that a) are not generated or b) have values. That is, exclude values we expect the database to generate"
	| result |
	result := OrderedCollection new: contents size.
	self fieldsAndValidValuesDo: [:field :value | 
		(value notNil or: [field isGenerated not]) ifTrue: [result add: field]].
	^result.