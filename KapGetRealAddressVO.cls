/******************************************************************************
** Module Name   : KapGetRealAddressVO
** Description   : A Value Object (VO) used to entity to hold Address data
** 
** Technial Info : <Classes, Methods, etc>
** 
** Author(s)     : George Koodarappally (GK) - Acumen Solutions
** Revision History:-
** Version  Date        Author  Description of Action
** 1.0      03/01/2011  GK      Initiated Script
******************************************************************************/

public with sharing class KapGetRealAddressVO {
    public String addr_type {get; set;}
    public String line_1 {get; set;}
    public String line_2 {get; set;}
    public String line_3 {get; set;}
    public String city {get; set;}
    public String state {get; set;}
    public String postal_code {get; set;}
    public String country {get; set;}
    public String start_date {get; set;}
    public String end_date {get; set;}
    public String mail {get; set;}
    public String latitude {get; set;}
    public String longitude {get; set;}
    
    /*
    public String XX {get; set;}
    public String XX {get; set;}
    */
}