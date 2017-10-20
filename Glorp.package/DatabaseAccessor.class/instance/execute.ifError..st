executing
execute: aBlock ifError: errorBlock

	^aBlock on: self errorsToCatch do: errorBlock.