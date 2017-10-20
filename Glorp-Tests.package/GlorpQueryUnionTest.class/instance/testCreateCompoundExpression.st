tests-unit
testCreateCompoundExpression
	| platform compoundString expectedString |
	expectedString := 'SELECT DISTINCT * FROM (SELECT t1.ID, t1.STREET, t1.HOUSE_NUM
 FROM GR_ADDRESS t1 UNION ALL SELECT t1.ID, t1.STREET, t1.HOUSE_NUM
 FROM GR_ADDRESS t1) t1'.
	platform := PostgreSQLPlatform new.
	compoundString := self helpTestCompoundExpressionOnPlatform: platform.
	self assert: compoundString equals: expectedString.
	platform := SQLServerPlatform new.
	compoundString := self helpTestCompoundExpressionOnPlatform: platform.
	self assert: compoundString equals: expectedString.
	platform := SQLite3Platform new.
	compoundString := self helpTestCompoundExpressionOnPlatform: platform.
	self assert: compoundString equals: expectedString.
