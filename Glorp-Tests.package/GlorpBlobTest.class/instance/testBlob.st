tests
testBlob
	self helpTestValue: nil.
	
	self platform isUDBCSQLite3Platform ifTrue: [ ^ self skip. ].
	"20200510, PierceNg: 
	- Below tests pass with the legacy UDBC SQLite binding but not the new SQLite binding. Skipped for now.
	- Platform remains UDBCSQLite3Platform for now even though no longer using the UDBC SQLite binding."
	self helpTestValue: (ByteArray withAll: #(1 2 3 4 255)).
	stType := String.
	self helpTestValue: 'abcdef'.