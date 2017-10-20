executing
execute: aBlock

	^self execute: aBlock ifError: [:ex | ex pass].