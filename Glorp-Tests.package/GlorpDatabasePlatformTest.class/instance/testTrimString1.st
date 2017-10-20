tests
testTrimString1
	"Normal ascii"
	| type plat |
	type := self string20.
	plat := type platform.
	self assert: (plat trimString: 'abcdefghi' for: type) = 'abcdefghi'.
	self assert: (plat trimString: 'abcdefghijklmnopqrst' for: type) = 'abcdefghijklmnopqrst'.
	self assert: (plat trimString: 'abcdefghijklmnopqrstu' for: type) = 'abcdefghijklmnopqrst'.
	self assert: (plat trimString: 'abcdefghijklmnopqrstuvwxy' for: type) = 'abcdefghijklmnopqrst'.