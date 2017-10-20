fields
findPositionofAliasedField: aField
	1 to: fields size do: [:i |
		| existingField |
		existingField := fields at: i.
		existingField asField isNil
			ifTrue: [
				existingField isSameAliasedFieldAs: aField]
			ifFalse: [		
				(existingField asField isSameAliasedFieldAs: aField)
			ifTrue: [^i]]].
	^0.