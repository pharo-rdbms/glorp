private
findMapping: aMapping in: aVirtualCollection
	
	aMapping hasAttribute not ifTrue: [^aVirtualCollection].
	aMapping attribute name = #session ifTrue: [^aVirtualCollection].
	^(aMapping attribute getValueFrom: self)
		ifNil: [aVirtualCollection]
		ifNotNil: [:value | aVirtualCollection select: [:each | self matchAttribute: (each get: aMapping attribute name) to: value]].