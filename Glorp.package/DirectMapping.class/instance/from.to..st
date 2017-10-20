initialize-release
from: anAttributeName to: aField

	| type |
	self attributeName: anAttributeName.
	self field: (descriptor fieldFor: aField).
	type := self attribute type isNil ifTrue: [field impliedSmalltalkType] ifFalse: [self attribute type].
	self type: type