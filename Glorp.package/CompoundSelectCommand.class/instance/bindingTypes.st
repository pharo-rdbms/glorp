accessing
bindingTypes
	^self commands inject: #() into: [:sum :each | sum, each bindingTypes].