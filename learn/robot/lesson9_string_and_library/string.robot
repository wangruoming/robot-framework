*** Settings ***
Library    ./library/split_string.py
Library  				String    

*** Variables ***
${output}		*May 27 10:29:26: %P2054-7-DEBUG: [classifiler][classifier_process_spectral_msg][1469]freq(5745) cnt(0) tstamp(-2037232662, 286940, 0) *May 27 10:29:26: %P2054-7-DEBUG: [classifiler][classifier_process_spectral_msg][1469]freq(5765) cnt(0) tstamp(-2036897476, 335186, 0) *May 27 10:29:27: %P2054-7-DEBUG: [classifiler][classifier_process_spectral_msg][1469]freq(5785) cnt(0) tstamp(-2036610641, 286835, 1) *May 27 10:29:27: %P2054-7-DEBUG: [classifiler][classifier_process_spectral_msg][1469]freq(5805) cnt(0) tstamp(-2036275272, 335369, 0)

*** Test Cases ***
Test 字符串中取取出对应字符串
	[Documentation]    字符串中取取出对应字符串
	Log	${output}
	Log to console	${output}
	${ret}=	test_split_string	${output}
	Log	${ret}
	#Get Matches tstamp*
	