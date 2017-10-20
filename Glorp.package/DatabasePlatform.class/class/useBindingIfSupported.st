as yet unclassified
useBindingIfSupported
	"If I am nil (the default), each platform that supportsBinding lazily initializes to its defaultUseBinding value.  If I have a value, I force lazy initialization of each platform that supportsBinding to my value.  Normally, a value is set only for specific testing purposes."

	UseBindingIfSupported isNil ifTrue: [^self useBindingByDefault].
	^UseBindingIfSupported