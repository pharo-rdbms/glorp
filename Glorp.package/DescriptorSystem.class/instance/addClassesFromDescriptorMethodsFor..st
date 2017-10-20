initialize-release
addClassesFromDescriptorMethodsFor: aClass
	| match |
	match := 'descriptorFor'.
	Dialect selectorsFor: aClass do: 
			[:each | 
			(each copyFrom: 1 to: (match size min: each size)) = match
				ifTrue:
					[| className actualClass |
					className := each copyFrom: match size + 1 to: each size - 1.
					actualClass := Dialect
						lookupClassNamed: className
						inContextOf: self class
						ifAbsent: [nil].
					actualClass isNil ifFalse: [allClasses add: actualClass]]]