private/mapping
writeRowsForTable: aTable

	| rows rowsByOperation |

	rows := rowsByTable at: aTable ifAbsent: [#()].
	^rows isEmpty ifFalse: [
		rowsByOperation := rows glorpGroupedBy: [:eachRow | session shouldInsert: eachRow].
		rowsByOperation do: [:eachListOfHomogeneousRows | 
			succeeded := succeeded & (session writeHomogeneousRows: eachListOfHomogeneousRows)]]