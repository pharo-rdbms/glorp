mapping
valueOfField: aField fromObject: anObject ifNone: aBlock
	"Return the value of a given field in our target object. Used in extracting primary keys when they are mapped via relationships"
	| targetField target |
	targetField := self referenceTableFieldFor: aField.
	targetField isNil ifTrue: [^aBlock value].
	target := self getValueFrom: anObject.
	"If it's a proxy and uninstantiated, we have to get the value from the proxy"
	(target isGlorpProxy and: [target isInstantiated not])
		ifTrue: [^target parameters at: aField].
	"If the object is instantiated, then we prefer to get the value from the object, because if it's non-primary key then the proxy may not know it, or it may vary from what the proxy has. Well, that seems unlikely, but try this anyway"
	self attribute 	
		loopOver: target 
		doing: [:index :eachTarget | | value |
			value := self referenceDescriptor valueOfField: targetField fromObject: eachTarget ifNone: [self].
			value == self ifFalse: [^value]].
	"We couldn't get it from the object, probably because it's unmapped. See if the proxy has it after all"
	target isGlorpProxy ifTrue: [^target parameters at: aField].
	"We couldn't get the value at all. This may mean that the object is new, so it has no proxies holding the value. Return nil and hope it's new and that it will all get figured out"
	^aBlock value.