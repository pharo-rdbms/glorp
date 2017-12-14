types
decimal: precision scale: scale

	^self typeNamed: #numeric ifAbsentPut:
			[GlorpDecimalType new
				selector: #decimal;
				precision: precision;
				scale: scale;
				yourself].