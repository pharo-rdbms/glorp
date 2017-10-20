accessing
rootDescriptor
	^rootDescriptor isNil
		ifTrue: [ rootDescriptor := self system descriptorFor: self rootClass ]
		ifFalse: [ rootDescriptor ]