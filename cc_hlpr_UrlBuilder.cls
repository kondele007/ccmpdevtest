//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_hlpr_UrlBuilder
{
	//==================================================
    // INSTANCE VARIABLES
    //==================================================
    private String          sb = '';
    private boolean         isFirst = true;
    private boolean         ignoreIfNull;
	//==================================================
    // CONSTRUCTOR
    //==================================================
    public cc_hlpr_UrlBuilder( String url, boolean ignoreIfNull )
    {
        this.sb = url;
        this.ignoreIfNull = ignoreIfNull;
    }
	//==================================================
    // SERVICE METHODS
    //==================================================
    public cc_hlpr_UrlBuilder append( String key, String value )
    {
        if ( value == null && ignoreIfNull )
        {
            return this;
        }

        if ( isFirst )
        {
            sb += '?';
            isFirst = false;
        }
        else
        {
            sb += '&';
        }

        try
        {
            sb += EncodingUtil.urlEncode( key, 'UTF-8' );
            sb += '=';
            sb += EncodingUtil.urlEncode( value, 'UTF-8' );
        }
        catch ( Exception e )
        {
        }

        return this;
    }

    public String toMyString()
    {
        return sb;
    }

    /*public void appendAll(Map<String, String> parameterMap)
    {
        Set<Map.Entry<String,String[]>> entries = parameterMap.entrySet();
        for ( Map.Entry<String,String[]> entry : entries ) 
        {
            appendAll( entry.getKey(), entry.getValue() );
        }
    }*/

     public void appendAll(String key, List<String> values) 
     {
        for ( String value : values ) 
        {
            append( key, value );
        }
        
    }
}