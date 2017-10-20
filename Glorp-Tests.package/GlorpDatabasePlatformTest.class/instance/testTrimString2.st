tests
testTrimString2
	"Some special characters"
	| type plat string |

	type := self string20.
	plat := type platform.

	string := self addToString: 'abcdefghi'.
	self assert: (plat trimString: string for: type) = string.
	string := self addToString: 'abcdefghijklmno'.
	self assert: (plat trimString: string for: type) = string.
	string := self addToString: 'abcdefghijklmnop'.
	self assert: (plat trimString: string for: type) = (string copyFrom: 1 to: string size -1).
	string := self addToString: 'abcdefghijklmnopq'.
	self assert: (plat trimString: string for: type) = (string copyFrom: 1 to: string size -1).
	string := (String new: 100000) atAllPut: $a.
	self assert: (plat trimString: string for: type) = 'aaaaaaaaaaaaaaaaaaaa'