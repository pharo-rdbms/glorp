descriptors/employees
polymorphicJoinToItemFromField: aField
	"Return a polymorphic join to the GlorpInventoryItem subclasses from the given field."
	| polymorphicJoin |
	polymorphicJoin := VariableJoin new.
	(Array with: GlorpNonperishableItem with: GlorpPerishableItem with: GlorpUnassembledItem)
		do:
			[:eachClass | 
			polymorphicJoin
				addJoinFor: eachClass
				as:
					(Join
						from: aField
						to: ((self descriptorFor: eachClass) primaryTable fieldNamed: 'ID'))].
	^polymorphicJoin