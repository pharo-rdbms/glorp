initialize-release
fromPseudoVariable: anAttributeName to: aField

	^self fromPseudoVariable: anAttributeName
		type: aField impliedSmalltalkType
		to: aField