//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
/* ============================================================
 * This code is part of the "apex-lang" open source project avaiable at:
 * 
 *      http://code.google.com/p/apex-lang/
 *
 * This code is licensed under the Apache License, Version 2.0.  You may obtain a 
 * copy of the License at:
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * ============================================================
 */
public with sharing class cc_util_RandomString {

    public static String random(Integer count) {
        return random(count, false, false);
    }

    public static String randomAscii(Integer count) {
        return random(count, 32, 127, false, false);
    }
    
    public static String randomAlphabetic(Integer count) {
        return random(count, true, false);
    }
    
    public static String randomAlphanumeric(Integer count) {
        return random(count, true, true);
    }
    
    public static String randomNumeric(Integer count) {
        return random(count, false, true);
    }

    public static String random(Integer count, String chars) {
        return random(count, 0, (chars == null ? 0 : chars.length()), false, false, chars);
    }

    public static String random(Integer count, boolean letters, boolean numbers) {
        return random(count, 0, 0, letters, numbers);
    }
    
    public static String random(Integer count, Integer startIndex, Integer endIndex, boolean letters, boolean numbers) {
        return random(count, startIndex, endIndex, letters, numbers, null);
    }

    public static String random(Integer count, Integer startIndex, Integer endIndex, boolean letters, boolean numbers, String chars) {
        if (count <= 0) {
            return '';
        }
        if(chars == null && (letters || numbers)){
            chars = '';
            startIndex = 0;
            if(letters){
                endIndex += 52;
                for(Integer i = al.Character.toAscii('a'), max = al.Character.toAscii('z'); i <= max; i++){
                    chars += al.Character.toChar(i);
                }    
                for(Integer i = al.Character.toAscii('A'), max = al.Character.toAscii('Z'); i <= max; i++){
                    chars += al.Character.toChar(i);
                }    
            }
            if(numbers){
                endIndex += 10;
                for(Integer i = al.Character.toAscii('0'), max = al.Character.toAscii('9'); i <= max; i++){
                    chars += al.Character.toChar(i);
                }    
            }
        }
        al.IntegerRange allowableRange = null;
        if(chars == null){
            allowableRange = new al.IntegerRange(32,127);
        } else {
            allowableRange = new al.IntegerRange(0,chars.length());
        }
        if(!allowableRange.contains(new al.IntegerRange(startIndex,endIndex))){
            startIndex = allowableRange.min();
            endIndex = allowableRange.max();
        }    

        String buffer = '';
        String ch;
        Integer gap = endIndex - startIndex;
        Integer next = 0;
        
        while (count-- > 0) {
            next = Math.round(Math.floor(Math.random()*gap)) + startIndex;
            if (chars == null) {
                ch = al.Character.toChar(next);
            } else {
                ch = al.StringUtils.charAt(chars,next);
            }
            buffer += ch;
        }
        return buffer;
    }

    private static String kHexChars = '0123456789abcdefABCDEF';
    
    /**
     * Implementation ported from Java Library at http://jug.safehaus.org
     */
    public static String randomUUID(){
        String returnValue = '';
        Integer nextByte = 0;
        for(Integer i = 0; i < 16; i++){
            if(i==4 || i==6 || i==8 || i==10){
                returnValue += '-';
            }
            //generate a "byte"; i.e., number in range [-2^7,2^7-1]
            nextByte = (Math.round(Math.random() * 255)-128) & 255;

            if(i==6){
                nextByte = nextByte & 15;
                nextByte = nextByte | (4 << 4);
            }
            if(i==8){
                nextByte = nextByte & 63;
                nextByte = nextByte | 128;
            }
            
            returnValue += al.StringUtils.charAt(kHexChars,nextByte >> 4);
            returnValue += al.StringUtils.charAt(kHexChars,nextByte & 15);
        }
        return returnValue;
    }
    
}