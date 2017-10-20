tests
string20
	| platform |
	platform := PostgresPlatform new.
	platform characterEncoding: #'utf-8'.
	^platform varchar: 20.