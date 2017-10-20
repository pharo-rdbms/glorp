bound values
bindingTypes
	^super bindingTypes, (row lockKeyFields collect: [:each | each type]).