transformations
defaultTransformationExpressionFor: aDescriptor 
	"If there's no transformation, get all the mapped fields from the other descriptor and construct a transformation of each onto itself. This lets us unify the fields in my row with the fields in its row"

	| fields transform |
	fields := IdentitySet new.
	aDescriptor mappings do: [:each | fields addAll: each mappedFields].
	transform := Join new.
	fields do: [:each | transform addSource: each target: each].
	^transform