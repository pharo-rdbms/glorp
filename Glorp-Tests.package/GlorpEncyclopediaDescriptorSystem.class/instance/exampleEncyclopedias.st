examples
exampleEncyclopedias
	"self new exampleEncyclopedias"
	| encyc1 entry1 entry2 entry3 encyc2 encyc3 |
	encyc1 := GlorpEncyclopedia new id: 3; name: 'The Canadian Encyclopedia'.
	entry1 := self exampleEntry1.
	entry2 := self exampleEntry2.
	entry3 := self exampleEntry3.
	encyc1 articleAt: '12345' put: entry1.
	encyc1 articleAt: 'abcde' put: entry2.
	encyc1 articleAt: 'unique' put: entry3.
	encyc2 := GlorpEncyclopedia new id: 4; name: 'The Plagiarists Compendium'.
	encyc2 articleAt: '54321' put: entry1.
	encyc2 articleAt: 'edcba' put: entry2.
	encyc3 := GlorpEncyclopedia new id: 5; name: 'The Very Frugal Dictionary'.
	^Array with: encyc1 with: encyc2 with: encyc3.