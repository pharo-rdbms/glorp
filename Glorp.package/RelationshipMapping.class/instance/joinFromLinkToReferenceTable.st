private/expressions
joinFromLinkToReferenceTable
	"Generate the inverse mapping expression, i.e. the one connecting the link table to the reference table, using the foreign key constraints. We assume that if there's a general part, it applies only to the original join, and not to the reverse join that we're generating."

	| expression generalPart |
	expression := Join new.
	self constraints do: [:eachConstraint | 
		eachConstraint sourceFields with: eachConstraint targetFields do: 
			[:eachSource :eachTarget |
				expression addSource: eachSource target: eachTarget]].
	generalPart := self join generalExpressionPart.
	^generalPart isNil ifTrue: [expression] ifFalse: [generalPart AND: expression].