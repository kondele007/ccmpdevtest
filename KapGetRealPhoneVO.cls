/******************************************************************************
** Module Name   : KapGetRealPhoneVO
** Description   : A Value Object (VO) used to entity to hold phone data
** 
** Technial Info : <Classes, Methods, etc>
** 
** Author(s)     : George Koodarappally (GK) - Acumen Solutions
** Revision History:-
** Version	Date		Author	Description of Action
** 1.0		03/01/2011	GK 		Initiated Script
******************************************************************************/

public with sharing class KapGetRealPhoneVO {
    public String index {get; set;}
    public String phone_number {get; set;}
    public String ext {get; set;}
    public String phone_type {get; set;}

    /*
    public String XX {get; set;}
    public String XX {get; set;}
    */

}