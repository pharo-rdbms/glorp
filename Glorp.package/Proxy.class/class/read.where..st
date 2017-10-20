*Glorp
read: aClass where: aBlock
	^self new query: (Query read: aClass where: aBlock)