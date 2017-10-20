validation
validateDescriptorSystem
	"Subclasses can define this to do other things, and add their own behavior to do things like only first time, never, etc."

	validateDescriptorSystem isNil ifTrue: [self validateDescriptorSystem: self defaultValidateValue].
	^validateDescriptorSystem == #always