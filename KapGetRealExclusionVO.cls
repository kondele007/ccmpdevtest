/******************************************************************************
** Module Name   : KapGetRealExclusionVO
** Description   : A Value Object (VO) used to entity to hold exclusion data
** 
** Technial Info : <Classes, Methods, etc>
** 
** Author(s)     : George Koodarappally (GK) - Acumen Solutions
** Revision History:-
** Version	Date		Author	Description of Action
** 1.0		03/01/2011	GK 		Initiated Script
******************************************************************************/

public with sharing class KapGetRealExclusionVO {
    public String excl_type {get; set;}
    public String excl_reason {get; set;}
}