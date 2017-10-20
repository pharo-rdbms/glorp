printing
printOn: aStream
	"I hate the printing with namespaces in vw"
      | title |
        title := self class name.
        aStream nextPutAll:
                ((title at: 1) isVowel ifTrue: ['an '] ifFalse: ['a ']).
        aStream nextPutAll: title