bound values
bindingTypes
	| all basic size |
	^(self shouldUseGroupWriting)
		ifTrue: [
			basic := self arrayBoundFields collect: [:each | each type].
			size := basic size.
			all := Array new: (allRows size * size).
			0 to: allRows size - 1 do: [:i |
				| index |
				index := i * size.
				all replaceElementsFrom: index + 1 to: index + size withArray: basic startingAt: 1].
			all]
		ifFalse: [self singleRowBoundFields collect: [:each | each type]].