/******************************************************************************
** Module Name   : KapGetRealPersonVO
** Description   : A Value Object (VO) used to entity to hold person data
** 
** Technial Info : <Classes, Methods, etc>
** 
** Author(s)     : George Koodarappally (GK) - Acumen Solutions
** Revision History:-
** Version  Date        Author  Description of Action
** 1.0      03/01/2011  GK      Initiated Script
******************************************************************************/

public with sharing class KapGetRealPersonVO {
    public String id {get; set;}
    public String student_id {get; set;}
    public String f_name {get; set;}
    public String m_name {get; set;}
    public String l_name {get; set;}
    public String call_name {get; set;}
    public String gender {get; set;}
    public String birth_date {get; set;}
    public String natl_donotcall {get; set;}
    public String mail_pref {get; set;}
    public String no_email_reason {get; set;}
    public String batch_id {get; set;}
    public String entry_date {get; set;}
    //Roster Changes
    public String subordinateUID{get;set;}
    public String grad_year {get; set;}
    
    public List<KapGetRealAddressVO> addressList {get; set;}
    public List<KapGetRealPhoneVO> phoneList {get; set;}
    public List<KapGetRealEmailVO> emailList {get; set;}
    public List<KapGetRealExclusionVO> exclusionList {get; set;}
    public List<KapGetRealInternationalInfoVO> intlInfoList {get; set;}
    public List<KapGetRealRelationshipVO> relationshipList {get; set;}
    public List<KapGetRealInteractionVO> interactionList {get; set;}
    
    /*
    public String XX {get; set;}
    public String XX {get; set;}
    public String XX {get; set;}
    */
    
    /**************************************
        BEGIN CloudCraze additions
    **************************************/
    public KapGetRealCloudCrazeOrderVO cloudCrazeOrder{get; set;}
    public String CloudCrazeMessageId{get; set;}
    /**************************************
        END CloudCraze additions
    **************************************/
}