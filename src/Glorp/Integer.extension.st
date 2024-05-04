Extension { #name : 'Integer' }

{ #category : '*Glorp-Core' }
Integer >> printOn: aStream paddedWith: aCharacter to: anInteger base: aRadix [
        "Append a string representation of the receiver in base <aRadix>
        digits to <aStream>, padded on the left with <aCharacter> to be at least
         <anInteger> characters."

	| digitStream padding digits |

	digitStream := WriteStream on: (String new: 10).
	self printOn: digitStream base: aRadix.
	digits := digitStream contents.

	padding := anInteger - digits size.
	padding > 0
		ifTrue: [
			padding := ( String new: padding )
				atAllPut: aCharacter ;
				yourself.
			aStream nextPutAll: padding ].
	aStream nextPutAll: digits.
]
