//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_hlpr_CryptoExtension {
	//==================================================
    // CONSTRUCTOR
    //==================================================
	public cc_hlpr_CryptoExtension()
	{
		
	}
	//==================================================
    // SERVICE METHODS
    //==================================================
	public String generateMD5FingerPrint(String strMessage, String strKey) {
		String algorithmName = 'hmacMD5';
		Blob mac = Crypto.generateMac(algorithmName, Blob.valueOf(strMessage), Blob.valueOf(strKey));
		return EncodingUtil.convertToHex(mac);
		
	}
	static testMethod void myUnitTest1() {
		cc_hlpr_CryptoExtension myTest = new cc_hlpr_CryptoExtension();
        System.assertEquals(myTest.generateMD5FingerPrint('Hello World!1234567890ABCDEFGH$156.0^1111', 'ginger'), 'c83ac0645d1992f67520b3142860d3c5');
        System.assertEquals(myTest.generateMD5FingerPrint('5Djr26DA^346^1272427393^0^','ginger1000!'), 'eb356343199b0b7dbbb8768848ee45fd');
		System.assertEquals(myTest.generateMD5FingerPrint('5Djr26DA^809^1272427393^1^','ginger1000!'), '4757f9ce189322bc24e8fdac89dbee26');
		System.assertEquals(myTest.generateMD5FingerPrint('5Djr26DA^299^1272427393^2^','ginger1000!'), '30249164c7a8d00e3aeb8d044a545b1c');
		System.assertEquals(myTest.generateMD5FingerPrint('5Djr26DA^790^1272427393^3^','ginger1000!'), 'a11a20f5282f57f51607818336b61ff7');
		System.assertEquals(myTest.generateMD5FingerPrint('5Djr26DA^538^1272427393^4^','ginger1000!'), 'e6ab0e0f0a2f786c85c76c4dc020e826');
		System.assertEquals(myTest.generateMD5FingerPrint('5Djr26DA^354^1272427393^5^','ginger1000!'), '0155478c2a2580d84245a04693d547f9');
		System.assertEquals(myTest.generateMD5FingerPrint('5Djr26DA^374^1272427393^6^','ginger1000!'), 'ec50ee4d28c46044a87f1fcb8f3531c7');
		System.assertEquals(myTest.generateMD5FingerPrint('5Djr26DA^583^1272427393^7^','ginger1000!'), 'b601f18538c1f4016e75e1fdd0040358');
		System.assertEquals(myTest.generateMD5FingerPrint('5Djr26DA^73^1272427393^8^','ginger1000!'), 'db4081874dd8d2e0345a1d6e177ca27f');
	}
}