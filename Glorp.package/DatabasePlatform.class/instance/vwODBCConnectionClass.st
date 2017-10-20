accessing
vwODBCConnectionClass
	"Prefer Threaded over not if nothing is loaded, but use whatever is loaded if there is anything"

	'ODBCThreadedConnection' asQualifiedReference ifDefinedDo:
		[:class | ^class].
	'ODBCConnection' asQualifiedReference ifDefinedDo:
		[:class | ^class].		
	^'ODBCThreadedConnection' asQualifiedReference valueIfUndefinedLoadFrom: 'ODBCThapiEXDI'