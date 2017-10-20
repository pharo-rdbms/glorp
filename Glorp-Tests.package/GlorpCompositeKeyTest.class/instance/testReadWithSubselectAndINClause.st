tests- basic reading
testReadWithSubselectAndINClause
	| users |
	self should: [
		users := session read: GlorpUser where: [:each | 
			each folders anySatisfyExists: [:eachFolder |
				| q |
				q := Query read: GlorpFolder.
				eachFolder in: q]]]
		raise: GlorpInvalidExpressionError.