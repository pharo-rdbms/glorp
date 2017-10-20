private/mapping
readBackNewRowInformation
	| changedObjects |
	changedObjects := rowMap objects.
	changedObjects
		do: 
			[:each | 
			| descriptor |
			descriptor := session descriptorFor: each.
			descriptor isNil ifFalse: [descriptor readBackNewRowInformationFor: each in: rowMap]]