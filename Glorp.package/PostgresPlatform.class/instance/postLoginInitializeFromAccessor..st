conversion-strings
postLoginInitializeFromAccessor: aDatabaseAccessor
	"If we cannot get the standard_conforming_strings state, assume the database is too old to understand it."

	| standardConformingStrings |
	charactersThatNeedEscaping isNil ifFalse: [^self].
	standardConformingStrings :=
		[aDatabaseAccessor executeSQLString: 'SHOW standard_conforming_strings']
			on: Dialect error
			do: [:ex |
				(ex description indexOfSubCollection: 'standard_conforming_strings' startingAt: 1) = 0
					ifFalse: [#(('off'))]
					ifTrue: [ex pass]].
	standardConformingStrings = #(('on'))
		ifTrue: [charactersThatNeedEscaping := #($')]
		ifFalse: [charactersThatNeedEscaping := #($' $\)].