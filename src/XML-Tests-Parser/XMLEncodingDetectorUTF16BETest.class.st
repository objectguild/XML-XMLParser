Class {
	#name : #XMLEncodingDetectorUTF16BETest,
	#superclass : #XMLEncodingDetectorTest,
	#category : #'XML-Tests-Parser-Streams'
}

{ #category : #testing }
XMLEncodingDetectorUTF16BETest class >> isAbstract [
	^ false
]

{ #category : #accessing }
XMLEncodingDetectorUTF16BETest >> explicitStreamConverterClass [
	^ XMLUTF16BigEndianStreamConverter
]

{ #category : #accessing }
XMLEncodingDetectorUTF16BETest >> implicitEncodedStrings [
	^ self stringsFromAll:
		#(
			#(16r00 16r01)
			#(16r00 16r0F)
			#(16r00 16r7F))
]

{ #category : #accessing }
XMLEncodingDetectorUTF16BETest >> implicitStreamConverterClass [
	^ XMLImplicitUTF16BigEndianStreamConverter
]