accessing
nonGeneratedFields
	"Return a list of our fields that are not generated"
	| result |
	result := OrderedCollection new: contents size.
	self table fields do: [:field | 
		field isGenerated not ifTrue: [result add: field]].
	^result.