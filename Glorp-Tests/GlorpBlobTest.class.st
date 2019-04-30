Class {
	#name : #GlorpBlobTest,
	#superclass : #AbstractLOBTest,
	#category : 'Glorp-Tests-DatabaseTypes'
}

{ #category : #tests }
GlorpBlobTest >> adjustForMaximumSize: anObject [
	^anObject.
]

{ #category : #tests }
GlorpBlobTest >> blob255 [
	^ByteArray withAll: #(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255)
]

{ #category : #types }
GlorpBlobTest >> defaultDatabaseType [
	^self platform blob.
]

{ #category : #tests }
GlorpBlobTest >> largeBlob [
	"Make a significant sized blob. 64k+ a bit should do"
	| blobStream |
	blobStream := WriteStream on: (ByteArray new: 10000).
	(((2 raisedTo: 16) + 100.0) / 255.0) ceiling timesRepeat: [
		blobStream nextPutAll: self blob255].
	^blobStream contents.
]

{ #category : #tests }
GlorpBlobTest >> mediumlargeBlob [
	"Make a Blob just under 32K in size"
	"self new mediumlargeBlob"
	| blobStream |
	blobStream := WriteStream on: (ByteArray new: 10000).
	(((2 raisedTo: 15) - 600.0) / 255.0) ceiling timesRepeat: [
		blobStream nextPutAll: self blob255].
	^blobStream contents.
]

{ #category : #tests }
GlorpBlobTest >> testBlob [
	self helpTestValue: nil.
	self helpTestValue: (ByteArray withAll: #(1 2 3 4 255)).
	stType := String.
	self helpTestValue: 'abcdef'.
]

{ #category : #tests }
GlorpBlobTest >> testBlobWithSubstring [
	"Test our ability to query with substring against a blob. This is severely limited in Postgresql, and may be limited in others.
	The compare blocks once looked clean, like this:
		[:each | (each test copyFrom: 1 to: 3) = 'hgf'].
	but the DB2 compare blocks would need to look like this:
		[:each | (each test copyFrom: 1 to: 3) like: 'hgf'].
	Rather than duplicate the blocks, the operator was switched to:
		[:each | (each test copyFrom: 1 to: 3) perform: compare with: 'hgf'].
	which results in the desired SQL, although in code it looks unpleasant."

	| result system compare |
	session platform supportsStringQueryOnBlobs ifFalse: [^self knownFailure].
	compare := session platform isDB2Platform
		ifTrue: [ #like: ]
		ifFalse: [ #= ].
	stType := String.
	self inTransactionDo: [
		system := self systemFor: table.
		session system: system.
		session inUnitOfWorkDo: [
			| model |
			model := GlorpTypeTestsModelClass new test: 'hgfedcbazyx'.
			session register: model].
		session reset.
		result := session read: GlorpTypeTestsModelClass where: [:each | (each test copyFrom: 1 to: 3) perform: compare with: 'hgf'].
		self assert: result size = 1.
		result := session read: GlorpTypeTestsModelClass where: [:each | (each test copyFrom: 1 to: 3) perform: compare with: 'abc'].
		self assert: result size = 0.
		result := session read: GlorpTypeTestsModelClass where: [:each | (each test copyFrom: 4 to: 6) perform: compare with: 'edc'].
		self assert: result size = 1.
		result := session read: GlorpTypeTestsModelClass where: [:each | (each test copyFrom: 7 to: 9) perform: compare with: 'baz'].
		self assert: result size = 1.

		result := session read: GlorpTypeTestsModelClass where: [:each | (each test copyFrom: 1 to: 6) perform: compare with: 'hgfedc'].
		self assert: result size = 1].
]

{ #category : #tests }
GlorpBlobTest >> testDefaultBlobPrinting [
	"Test out default (SQL-92 syntax) byte array printing"
	| stream |
	stream := WriteStream on: String new.
	type := type copy.
	type platform: DatabasePlatform new.
	type print: (ByteArray with: 0) on: stream.
	self assert: stream contents = 'X''00'''.
	stream reset.
	type print: (ByteArray with: 16rFF) on: stream.
	self assert: stream contents = 'X''FF'''.
	stream reset.
	type print: (ByteArray with: 16r47) on: stream.
	self assert: stream contents = 'X''47'''.
	stream reset.
	type print: (ByteArray withAll: #(1 2 16rFE)) asByteArray on: stream.
	self assert: stream contents = 'X''0102FE'''.
]

{ #category : #tests }
GlorpBlobTest >> testLargeBlob [
	| blob |
	self platform isSQLite3Platform ifTrue: [ ^ self skip. ].
	self platform isUDBCSQLite3Platform ifTrue: [ ^ self skip. ].
	blob := self mediumlargeBlob.
	(session platform useBinding not and: [blob size > session platform maximumQueryValueSize])
		ifTrue: [Transcript cr; show: '******* Skipping large unbound blob test']
		ifFalse: [self helpTestValue: blob].
	blob := self largeBlob.
	(session platform useBinding not and: [blob size > session platform maximumQueryValueSize])
		ifFalse: [self helpTestValue: blob]
]
