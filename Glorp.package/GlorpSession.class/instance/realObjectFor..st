private
realObjectFor: anObject 
	"If this is a proxy, return the contents (if available). Otherwise, return nil"
	
	^self realObjectFor: anObject ifNone: [nil]