conversion-strings
encodeAsBase64String: aByteArray
	"Pure inline of Base64FastCoder's method."

	| output thirdTripletIndex firstQuartetIndex firstOfThree secondOfThree thirdOfThree remainder |
	output := ByteString new: (aByteArray size / 3) ceiling * 4.
	thirdTripletIndex := 3.
	firstQuartetIndex := 1.	"Process all complete triplets."
	[thirdTripletIndex > aByteArray size] whileFalse: 
			[firstOfThree := aByteArray at: thirdTripletIndex - 2.
			secondOfThree := aByteArray at: thirdTripletIndex - 1.
			thirdOfThree := aByteArray at: thirdTripletIndex.
			output at: firstQuartetIndex
				put: ('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
						at: ((firstOfThree bitAnd: 2r11111100) bitShift: -2) + 1).
			output at: firstQuartetIndex + 1
				put: ('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
						at: (((firstOfThree bitAnd: 2r00000011) bitShift: 4)
								bitOr: ((secondOfThree bitAnd: 2r11110000) bitShift: -4)) + 1).
			output at: firstQuartetIndex + 2
				put: ('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
						at: (((secondOfThree bitAnd: 2r00001111) bitShift: 2)
								bitOr: ((thirdOfThree bitAnd: 2r11000000) bitShift: -6)) + 1).
			output at: firstQuartetIndex + 3
				put: ('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
						at: (thirdOfThree bitAnd: 2r00111111) + 1).
			thirdTripletIndex := thirdTripletIndex + 3.
			firstQuartetIndex := firstQuartetIndex + 4].	"Process any final incomplete triplet."
	remainder := thirdTripletIndex - aByteArray size.
	remainder = 3 ifTrue: [^output].
	firstOfThree := aByteArray at: thirdTripletIndex - 2.
	output at: firstQuartetIndex
		put: ('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
				at: ((firstOfThree bitAnd: 2r11111100) bitShift: -2) + 1).
	output at: firstQuartetIndex + 3 put: $=.
	remainder = 1
		ifFalse: 
			["the byte array is missing two values of another triplet"
			output at: firstQuartetIndex + 1
				put: ('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
						at: ((firstOfThree bitAnd: 2r00000011) bitShift: 4) + 1).
			output at: firstQuartetIndex + 2 put: $=]
		ifTrue: 
			["the byte array is only missing one value of another triplet"
			secondOfThree := aByteArray at: thirdTripletIndex - 1.
			output at: firstQuartetIndex + 1
				put: ('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
						at: (((firstOfThree bitAnd: 2r00000011) bitShift: 4)
								bitOr: ((secondOfThree bitAnd: 2r11110000) bitShift: -4)) + 1).
			output at: firstQuartetIndex + 2
				put: ('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
						at: ((secondOfThree bitAnd: 2r00001111) bitShift: 2) + 1)].
	^output