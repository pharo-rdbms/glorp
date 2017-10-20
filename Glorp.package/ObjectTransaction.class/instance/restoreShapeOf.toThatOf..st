private/restoring
restoreShapeOf: original toThatOf: copy

	| newOriginal |
	(copy class isBits or: [copy class isVariable])
		ifTrue: [newOriginal := copy class basicNew: copy glorpBasicSize]
		ifFalse: [newOriginal := copy class basicNew].
	original become: newOriginal