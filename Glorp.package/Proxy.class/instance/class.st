accessing
class

	^Proxy
	"self isInstantiated ifTrue: [^value class].
	query isNil ifTrue: [^Proxy].
	query resultClass isNil ifTrue: [^Proxy].
	^query resultClass."