/******************************************************************************
** Module Name   : KapGetRealRelationshipVO
** Description   : A Value Object (VO) used to entity to hold relationship data
** 
** Technial Info : <Classes, Methods, etc>
** 
** Author(s)     : George Koodarappally (GK) - Acumen Solutions
** Revision History:-
** Version	Date		Author	Description of Action
** 1.0		03/01/2011	GK 		Initiated Script
******************************************************************************/

public with sharing class KapGetRealRelationshipVO {
    public String id {get; set;}
    public String kbs_parent_id {get; set;}
    public String student_id {get; set;}
    public String f_name {get; set;}
    public String l_name {get; set;}
    public String relationship_type {get; set;}
    public String phone_1 {get; set;}
    public String phone_1_extension {get; set;}
    public String phone_2 {get; set;}
    public String phone_2_extension {get; set;}
    public String email_address_1 {get; set;}
    public String email_address_2 {get; set;}

    public List<KapGetRealPhoneVO> phoneList {get; set;}
    public List<KapGetRealEmailVO> emailList {get; set;}

    /*
    public String XX {get; set;}
    public String XX {get; set;}
    */
}