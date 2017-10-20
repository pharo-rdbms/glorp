enumerating
fieldsDo: aBlock 
	1 to: contents size do: [:i |
		| value |
		value := contents at: i.
		(value == self class emptySlot) ifFalse: [aBlock value: (self table fields at: i)]].