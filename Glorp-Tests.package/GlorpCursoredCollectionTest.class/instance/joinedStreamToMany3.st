support
joinedStreamToMany3
	| rows |
	rows := #( 
			(1 'Alan' 1 '001' '001'  '123' 1 1 #CDN 1.5 'stuff' #CDN 1)  
			(1 'Alan' 1 '001' '001'  '123' 2 1  #USD 1.5 'stuff' #USD 1)
 			(1 'Alan' 2 '002' '002'  '234' 3 1  #CHF 1.5 'stuff' #CHF 1)
			(1 'Alan' 2 '002' '002'  '234' 4 1  #EUR 1.5 'stuff' #EUR 1)
 ).
	^ReadStream on: rows.