/******************************************************************************
** Module Name   : KapGetRealInternationalInfoVO
** Description   : A Value Object (VO) used to entity to hold international data
** 
** Technial Info : <Classes, Methods, etc>
** 
** Author(s)     : George Koodarappally (GK) - Acumen Solutions
** Revision History:-
** Version	Date		Author	Description of Action
** 1.0		03/01/2011	GK 		Initiated Script
******************************************************************************/

public with sharing class KapGetRealInternationalInfoVO {
    public String agent {get; set;}
    public String birth_country {get; set;}
    public String country {get; set;}
    public String background {get; set;}
    public String isF1 {get; set;}
    public String aba_number {get; set;}
    public String ama_number {get; set;}

    /*
    public String XX {get; set;}
    public String XX {get; set;}
    public String XX {get; set;}
    */
}