setup
writeAccountRows
	| accountRow1 accountRow2 |

	accountRow1 := session system exampleAccountRow1. 
	accountRow2 := session system exampleAccountRow2.
	session writeRow: accountRow1.
	session writeRow: accountRow2.