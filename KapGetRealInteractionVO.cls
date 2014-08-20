/******************************************************************************
** Module Name   : KapGetRealInteractionVO
** Description   : A Value Object (VO) used to entity to hold interaction data
** 
** Technial Info : <Classes, Methods, etc>
** 
** Author(s)     : George Koodarappally (GK) - Acumen Solutions
** Revision History:-
** Version	Date		Author	Description of Action
** 1.0		03/01/2011	GK 		Initiated Script
******************************************************************************/

public with sharing class KapGetRealInteractionVO {
    public String id {get; set;}
    public String student_id {get; set;}
    public String interaction_type {get; set;}
    public String contact {get; set;}
    public String interaction_date {get; set;}
    public String reason {get; set;}
    public String comment {get; set;}
    public String no_interest {get; set;}
    public String user {get; set;}
    public String program {get; set;}

    /*
    public String XX {get; set;}
    public String XX {get; set;}
    */
}