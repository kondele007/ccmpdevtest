/******************************************************************************
** Module Name   : KapGetRealUtil 

** Description   : Utility class containg methods to be used in the GetReal
**               integration code.
** 
** Technial Info : <Classes, Methods, etc>
** 
** Author(s)     : George Koodarappally (GK) - Acumen Solutions
** Revision History:-
** Version  Date        Author  Description of Action
** 1.0    03/01/2011  GK      Initiated Script
******************************************************************************/

public with sharing class KapGetRealUtil {
    
    private static Kaplan_Custom_Config__c kap_config = Kaplan_Custom_Config__c.getValues('Kaplan Custom Config');
    private static Integer getRealMaxRetryCount = Integer.valueOf(kap_config.GetReal_Max_Retry_Count__c);
    private static String getRealMessagePrefix = String.valueOf(kap_config.GetReal_Message_Prefix__c);
    
    private static Boolean addressLine1Queried, phoneNumberQueried;
    private static Map<String, String> mapAddressLine1 = new Map<String, String>();
    private static Map<String, String> mapAddressPostalCode = new Map<String, String>();
    private static Map<Integer, String> mapPhoneNumber = new Map<Integer, String>();
    private static Map<Integer, String> mapGetRealResponseCodeText = new Map<Integer, String>();
    private static Integer MessageIdSuffixIterator;


    public static void initGetRealResponseCodeText() {
        mapGetRealResponseCodeText.put(25, KapConstants.KAP_GETREAL_RESPONSE_CODE_25_TEXT);
        mapGetRealResponseCodeText.put(20, KapConstants.KAP_GETREAL_RESPONSE_CODE_20_TEXT);
        mapGetRealResponseCodeText.put(10, KapConstants.KAP_GETREAL_RESPONSE_CODE_10_TEXT);
        mapGetRealResponseCodeText.put(5, KapConstants.KAP_GETREAL_RESPONSE_CODE_5_TEXT);
        mapGetRealResponseCodeText.put(0, KapConstants.KAP_GETREAL_RESPONSE_CODE_0_TEXT);
        mapGetRealResponseCodeText.put(-10, KapConstants.KAP_GETREAL_RESPONSE_CODE_NEG_10_TEXT);
        mapGetRealResponseCodeText.put(-20, KapConstants.KAP_GETREAL_RESPONSE_CODE_NEG_20_TEXT);
        mapGetRealResponseCodeText.put(-21, KapConstants.KAP_GETREAL_RESPONSE_CODE_NEG_21_TEXT);
        mapGetRealResponseCodeText.put(-30, KapConstants.KAP_GETREAL_RESPONSE_CODE_NEG_30_TEXT);
        mapGetRealResponseCodeText.put(-35, KapConstants.KAP_GETREAL_RESPONSE_CODE_NEG_35_TEXT);
        mapGetRealResponseCodeText.put(-40, KapConstants.KAP_GETREAL_RESPONSE_CODE_NEG_40_TEXT);
        mapGetRealResponseCodeText.put(-50, KapConstants.KAP_GETREAL_RESPONSE_CODE_NEG_50_TEXT);
        mapGetRealResponseCodeText.put(-60, KapConstants.KAP_GETREAL_RESPONSE_CODE_NEG_60_TEXT);
        mapGetRealResponseCodeText.put(-70, KapConstants.KAP_GETREAL_RESPONSE_CODE_NEG_70_TEXT);
    }
    
    
    public static KapGetRealPersonVO populateStudentBasicProfile(KapGetRealPersonVO personRec, Map<String, String> mapChangedFields) {
        String FirstName, MiddleName, LastName, CallName;
        String Gender, BirthDate, NatlDoNotCall, MailPref, NoEmailReason, BatchId, EntryDate;
         
        personRec.f_name            = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_FIRST_NAME);
        personRec.m_name            = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_MIDDLE_NAME);
        personRec.l_name            = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_LAST_NAME);
        personRec.call_name      = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_CALL_NAME);
        personRec.gender            = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_GENDER);
        personRec.birth_date        = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_BIRTH_DATE);
        personRec.natl_donotcall    = KapUtil.BooleanStringToIntegerString(mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_NATL_DO_NOT_CALL));
        personRec.mail_pref      = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_MAIL_PREF);
        personRec.no_email_reason   = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_NO_EMAIL_REASON);
        personRec.batch_id        = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_BATCH_ID);
        personRec.entry_date        = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_ENTRY_DATE);
 
        //System.Debug('***************************************');
        //System.Debug('In populateStudentBasicProfile : MapFirstName : '+mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_FIRST_NAME));
        //System.Debug('In populateStudentBasicProfile : PersonFirstName : '+personRec.f_name);
        //System.Debug('***************************************');
        
        return personRec;
    }
    

    public static KapGetRealPersonVO populateStudentAddress(KapGetRealPersonVO personRec, Map<String, String> mapChangedFields, String AddressType) {
        String Address1, Address2, Address3, City, State, PostalCode, Country, MailFlag;
        
        if (!addressLine1Queried) {
            Account addrAcct = [SELECT BillingStreet, BillingPostalCode, ShippingStreet, ShippingPostalCode, School_Address_Line_1__c, School_Postal_Code__c, Other_Address_Line_1__c, Other_Postal_Code__c FROM Account WHERE Id = :personRec.id]; 
            
            mapAddressLine1.clear();
            if (addrAcct.BillingStreet != null) mapAddressLine1.put('Perm', addrAcct.BillingStreet);
            if (addrAcct.ShippingStreet != null) mapAddressLine1.put('Work', addrAcct.ShippingStreet);
            if (addrAcct.School_Address_Line_1__c != null) mapAddressLine1.put('School', addrAcct.School_Address_Line_1__c);
            if (addrAcct.Other_Address_Line_1__c != null) mapAddressLine1.put('Other', addrAcct.Other_Address_Line_1__c);
            
            mapAddressPostalCode.clear();
            if (addrAcct.BillingPostalCode != null) mapAddressPostalCode.put('Perm', addrAcct.BillingPostalCode );
            if (addrAcct.ShippingPostalCode != null) mapAddressPostalCode.put('Work', addrAcct.ShippingPostalCode );
            if (addrAcct.School_Postal_Code__c != null) mapAddressPostalCode.put('School', addrAcct.School_Postal_Code__c );
            if (addrAcct.Other_Postal_Code__c != null) mapAddressPostalCode.put('Other', addrAcct.Other_Postal_Code__c );
            
            addressLine1Queried = true;
        }

        if (AddressType == 'Perm') {
            Address1            = mapChangedFields.get(KapConstants.KAP_FLD_PERMANENT_ADDRESS_ADDRESS1);
            Address2            = mapChangedFields.get(KapConstants.KAP_FLD_PERMANENT_ADDRESS_ADDRESS2);
            Address3            = mapChangedFields.get(KapConstants.KAP_FLD_PERMANENT_ADDRESS_ADDRESS3);
            City                = mapChangedFields.get(KapConstants.KAP_FLD_PERMANENT_ADDRESS_CITY);
            State              = mapChangedFields.get(KapConstants.KAP_FLD_PERMANENT_ADDRESS_STATE);
            PostalCode        = mapChangedFields.get(KapConstants.KAP_FLD_PERMANENT_ADDRESS_POSTAL_CODE);
            Country          = mapChangedFields.get(KapConstants.KAP_FLD_PERMANENT_ADDRESS_COUNTRY);
            MailFlag            = mapChangedFields.get(KapConstants.KAP_FLD_PERMANENT_ADDRESS_MAILING_FLAG);
        } else if (AddressType == 'Work') {
            Address1            = mapChangedFields.get(KapConstants.KAP_FLD_WORK_ADDRESS_ADDRESS1);
            Address2            = mapChangedFields.get(KapConstants.KAP_FLD_WORK_ADDRESS_ADDRESS2);
            Address3            = mapChangedFields.get(KapConstants.KAP_FLD_WORK_ADDRESS_ADDRESS3);
            City                = mapChangedFields.get(KapConstants.KAP_FLD_WORK_ADDRESS_CITY);
            State              = mapChangedFields.get(KapConstants.KAP_FLD_WORK_ADDRESS_STATE);
            PostalCode        = mapChangedFields.get(KapConstants.KAP_FLD_WORK_ADDRESS_POSTAL_CODE);
            Country          = mapChangedFields.get(KapConstants.KAP_FLD_WORK_ADDRESS_COUNTRY);
            MailFlag            = mapChangedFields.get(KapConstants.KAP_FLD_WORK_ADDRESS_MAILING_FLAG);
        } else if (AddressType == 'School') {
            Address1            = mapChangedFields.get(KapConstants.KAP_FLD_SCHOOL_ADDRESS_ADDRESS1);
            Address2            = mapChangedFields.get(KapConstants.KAP_FLD_SCHOOL_ADDRESS_ADDRESS2);
            Address3            = mapChangedFields.get(KapConstants.KAP_FLD_SCHOOL_ADDRESS_ADDRESS3);
            City                = mapChangedFields.get(KapConstants.KAP_FLD_SCHOOL_ADDRESS_CITY);
            State              = mapChangedFields.get(KapConstants.KAP_FLD_SCHOOL_ADDRESS_STATE);
            PostalCode        = mapChangedFields.get(KapConstants.KAP_FLD_SCHOOL_ADDRESS_POSTAL_CODE);
            Country          = mapChangedFields.get(KapConstants.KAP_FLD_SCHOOL_ADDRESS_COUNTRY);
            MailFlag            = mapChangedFields.get(KapConstants.KAP_FLD_SCHOOL_ADDRESS_MAILING_FLAG);
        } else if (AddressType == 'Other') {
            Address1            = mapChangedFields.get(KapConstants.KAP_FLD_OTHER_ADDRESS_ADDRESS1);
            Address2            = mapChangedFields.get(KapConstants.KAP_FLD_OTHER_ADDRESS_ADDRESS2);
            Address3            = mapChangedFields.get(KapConstants.KAP_FLD_OTHER_ADDRESS_ADDRESS3);
            City                = mapChangedFields.get(KapConstants.KAP_FLD_OTHER_ADDRESS_CITY);
            State              = mapChangedFields.get(KapConstants.KAP_FLD_OTHER_ADDRESS_STATE);
            PostalCode        = mapChangedFields.get(KapConstants.KAP_FLD_OTHER_ADDRESS_POSTAL_CODE);
            Country          = mapChangedFields.get(KapConstants.KAP_FLD_OTHER_ADDRESS_COUNTRY);
            MailFlag            = mapChangedFields.get(KapConstants.KAP_FLD_OTHER_ADDRESS_MAILING_FLAG);
        }
        
        if ((Address1 != null) || (Address2 != null) || (Address3 != null) || (City != null) || (State != null) || (PostalCode != null) || (Country != null) || (MailFlag != null)) {
            KapGetRealAddressVO addrVO = new KapGetRealAddressVO();
            
            addrVO.addr_type = AddressType;
            
            //Address Line 1 and Postal Code are required for GetReal
            if (Address1 == null) Address1 = mapAddressLine1.get(AddressType);
            if (PostalCode == null) PostalCode   = mapAddressPostalCode.get(AddressType);
            
            if (Address1 != null)   addrVO.line_1      = Address1;
            if (Address2 != null)   addrVO.line_2      = Address2;
            if (Address3 != null)   addrVO.line_3      = Address3;
            if (City != null)      addrVO.city       = City;
            if (State != null)    addrVO.state      = State;
            if (PostalCode != null) addrVO.postal_code  = PostalCode;
            if (Country != null)    addrVO.country    = Country;
            if (MailFlag != null)   addrVO.mail      = MailFlag;
            
            personRec.addressList.add(addrVO);
            
            //System.Debug('***************************************');
            //System.Debug('In populateStudentAddress: Address Type: '+AddressType);
            //System.Debug('In populateStudentAddress: MapAddressLine1 : '+Address1);
            //System.Debug('In populateStudentAddress: AddressVO: '+addrVO.line_1);
            //System.Debug('In populateStudentAddress: PersonAddressListLine1: '+personRec.addressList[0].line_1);
            //System.Debug('***************************************');
        
        }
        
        return personRec;
    }
    

    public static KapGetRealPersonVO populateStudentPhoneAndEmail(KapGetRealPersonVO personRec, Map<String, String> mapChangedFields) {
        String Phone1Type, Phone1, Phone1Extension;
        String Phone2Type, Phone2, Phone2Extension;
        String Phone3Type, Phone3, Phone3Extension;
        String Email1Type, Email1;
        String Email2Type, Email2;
        
        Phone1Type        = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_PHONE_1_TYPE);
        Phone1            = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_PHONE_1);
        Phone1Extension  = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_PHONE_1_EXTENSION);
        Phone2Type        = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_PHONE_2_TYPE);
        Phone2            = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_PHONE_2);
        Phone2Extension  = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_PHONE_2_EXTENSION);
        Phone3Type        = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_PHONE_3_TYPE);
        Phone3            = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_PHONE_3);
        Phone3Extension  = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_PHONE_3_EXTENSION);
        Email1Type        = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_EMAIL_1_TYPE);
        Email1            = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_EMAIL_1);
        Email2Type        = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_EMAIL_2_TYPE);
        Email2            = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_EMAIL_2);

        if (!phoneNumberQueried) {
            Account phoneAcct = [SELECT Phone_1_Type__c, Phone, Phone_2_Type__c, Phone_2__c, Phone_3_Type__c, Phone_3__c FROM Account WHERE Id = :personRec.id];    
            mapPhoneNumber.clear();
            
            if (phoneAcct.Phone != null) mapPhoneNumber.put(0, phoneAcct.Phone);
            if (phoneAcct.Phone_2__c != null) mapPhoneNumber.put(1, phoneAcct.Phone_2__c);
            if (phoneAcct.Phone_3__c != null) mapPhoneNumber.put(2, phoneAcct.Phone_3__c);
            
            phoneNumberQueried = false;
        }
        
        if ((Phone1Type != null) || (Phone1 != null) || (Phone1Extension != null)) {
            KapGetRealPhoneVO phoneVO = new KapGetRealPhoneVO();
            
            phoneVO.phone_type  = Phone1Type;
            phoneVO.index      = '0';
            
            if (Phone1 != null) {
                phoneVO.phone_number    = Phone1;
            }              
            else {
                phoneVO.phone_number    = mapPhoneNumber.get(0);
            }              
            if (Phone1Extension != null)    phoneVO.ext          = Phone1Extension;
            
            personRec.phoneList.add(phoneVO);
        }

        if ((Phone2Type != null) || (Phone2 != null || (Phone2Extension != null))) {
            KapGetRealPhoneVO phoneVO = new KapGetRealPhoneVO();
            
            phoneVO.phone_type  = Phone2Type;
            phoneVO.index      = '1';
            
            //if (Phone2 != null)              phoneVO.phone_number = Phone2;
            if (Phone2 != null) {
                phoneVO.phone_number    = Phone2;
            }              
            else {
                phoneVO.phone_number    = mapPhoneNumber.get(1);
            }              
            if (Phone2Extension != null)    phoneVO.ext          = Phone2Extension;
            
            personRec.phoneList.add(phoneVO);
        }

        if ((Phone3Type != null) || (Phone3 != null || (Phone3Extension != null))) {
            KapGetRealPhoneVO phoneVO = new KapGetRealPhoneVO();
            
            phoneVO.phone_type  = Phone3Type;
            phoneVO.index      = '2';
            
            //if (Phone3 != null)              phoneVO.phone_number = Phone3;
            if (Phone3 != null) {
                phoneVO.phone_number    = Phone3;
            }              
            else {
                phoneVO.phone_number    = mapPhoneNumber.get(2);
            }              
            if (Phone3Extension != null)    phoneVO.ext          = Phone3Extension;
            
            personRec.phoneList.add(phoneVO);
        }

        if ((Email1Type != null) || (Email1 != null)) {
            KapGetRealEmailVO emailVO = new KapGetRealEmailVO();
            
            emailVO.index      = '0';
            
            if (Email1 != null) emailVO.email_address   = Email1;
            
            personRec.emailList.add(emailVO);
        }

        if ((Email2Type != null) || (Email2 != null)) {
            KapGetRealEmailVO emailVO = new KapGetRealEmailVO();
            
            emailVO.index      = '1';
            
            if (Email2 != null) emailVO.email_address   = Email2;
            
            personRec.emailList.add(emailVO);
        }

        //System.Debug('***************************************');
        //System.Debug('In  populateStudentPhoneAndEmail : Phone 1 index: '+personRec.phoneList[0].index);
        //System.Debug('In  populateStudentPhoneAndEmail : Phone 1: '+personRec.phoneList[0].phone_number);
        //System.Debug('In  populateStudentPhoneAndEmail : Email 1 index: '+personRec.emailList[0].index);
        //System.Debug('In  populateStudentPhoneAndEmail : Email 1: '+personRec.emailList[0].email_address);
        //System.Debug('***************************************');
        
        return personRec;
    }
    
    
    public static KapGetRealPersonVO populateStudentExclusionInfo(KapGetRealPersonVO personRec, Map<String, String> mapChangedFields) {
        String DoNotCallStr, DoNotEmailStr, DoNotMailStr, DoNotShareStr;
        Boolean DoNotCall, DoNotEmail, DoNotMail, DoNotShare;
        System.debug(LoggingLevel.INFO, '$$Roster populateStudentExclusionInfo - personRec=' + personRec);
        System.debug(LoggingLevel.INFO, '$$Roster populateStudentExclusionInfo - mapChangedFields=' + mapChangedFields);        

        DoNotCallStr        = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_DO_NOT_CALL);
        DoNotEmailStr      = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_DO_NOT_EMAIL);
        DoNotMailStr        = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_DO_NOT_MAIL);
        DoNotShareStr      = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_DO_NOT_SHARE);
        
        DoNotCall   = false;
        DoNotEmail  = false;
        DoNotMail   = false;
        DoNotShare  = false;
        
        if ((DoNotCallStr != null) && (DoNotCallStr != ''))  DoNotCall   = Boolean.valueOf(DoNotCallStr);
        if ((DoNotEmailStr != null) && (DoNotEmailStr != ''))   DoNotEmail  = Boolean.valueOf(DoNotEmailStr);
        if ((DoNotMailStr != null) && (DoNotMailStr != ''))  DoNotMail   = Boolean.valueOf(DoNotMailStr);
        if ((DoNotShareStr != null) && (DoNotShareStr != ''))   DoNotShare  = Boolean.valueOf(DoNotShareStr);
        
        System.debug(LoggingLevel.INFO, '$$Roster populateStudentExclusionInfo Do Not Call Condition=' + DoNotCall);
        System.debug(LoggingLevel.INFO, '$$Roster populateStudentExclusionInfo personRec=' + personRec);
        System.debug(LoggingLevel.INFO, '$$Roster populateStudentExclusionInfo personRec.exclusionList=' + personRec.exclusionList);

        if(personRec.exclusionList == null){
            personRec.exclusionList = new List<KapGetRealExclusionVO>();
        }
        
        if (DoNotCall) {
            KapGetRealExclusionVO exclusionVO = new KapGetRealExclusionVO();
            
            exclusionVO.excl_type      = 'Phone';
            exclusionVO.excl_reason  = 'Customer Request';
            
            personRec.exclusionList.add(exclusionVO);
        }

         if (DoNotEmail) {
            KapGetRealExclusionVO exclusionVO = new KapGetRealExclusionVO();
            
            exclusionVO.excl_type      = 'Email';
            exclusionVO.excl_reason  = 'Customer Request';
            
            personRec.exclusionList.add(exclusionVO);
        }

         if (DoNotMail) {
            KapGetRealExclusionVO exclusionVO = new KapGetRealExclusionVO();
            
            exclusionVO.excl_type      = 'Mail';
            exclusionVO.excl_reason  = 'Customer Request';
            
            personRec.exclusionList.add(exclusionVO);
        }

         if (DoNotShare) {
            KapGetRealExclusionVO exclusionVO = new KapGetRealExclusionVO();
            
            exclusionVO.excl_type      = 'Do Not Share Info';
            exclusionVO.excl_reason  = 'Customer Request';
            
            personRec.exclusionList.add(exclusionVO);
        }

        System.debug(LoggingLevel.INFO, '$$Roster Exit populateStudentExclusionInfo');
        return personRec;
    }

    
    public static KapGetRealPersonVO populateStudentIntlInfo(KapGetRealPersonVO personRec, Map<String, String> mapChangedFields) {
        String Agent, BirthCountry, Country, Background, isF1, ABANumber;

        Agent              = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_INTL_AGENT);
        BirthCountry        = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_INTL_BIRTH_COUNTRY);
        Country          = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_INTL_COUNTRY);
        Background        = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_INTL_BACKGROUND);
        isF1                = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_INTL_IS_F1);
        ABANumber          = mapChangedFields.get(KapConstants.KAP_FLD_STUDENT_INTL_ABA_NUMBER);
        
        if ((Agent != null) || (BirthCountry != null) || (Country != null) || (Background != null) || (isF1 != null) || (ABANumber != null)) {
            KapGetRealInternationalInfoVO intlInfoVO = new KapGetRealInternationalInfoVO();
            
            if (Agent != null)        intlInfoVO.agent          = Agent;
            if (BirthCountry != null)   intlInfoVO.birth_country    = BirthCountry;
            if (Country != null)        intlInfoVO.country        = Country;
            if (Background != null)  intlInfoVO.background     = Background;
            if (isF1 != null)          intlInfoVO.isF1           = isF1;
            if (ABANumber != null)    intlInfoVO.aba_number    = ABANumber;
            
            personRec.intlInfoList.add(intlInfoVO);
        }

        return personRec;
    }


    public static KapGetRealPersonVO populateStudentRelationship(KapGetRealPersonVO personRec, Map<String, String> mapChangedFields) {
        String LegacyParentId, RelationshipType, FirstName, LastName, Phone1, Phone2, Phone1Extension, Phone2Extension, Email1, Email2;

        Relationship__c relationship = [SELECT Parent_Last_Name__c, Phone_1__c, Phone_2__c FROM Relationship__c WHERE Id = :personRec.id];   //Person Rec temporarily holds the relationship id.
        
        if (relationship.Parent_Last_Name__c != null)
            LastName = relationship.Parent_Last_Name__c;
        
        LegacyParentId    = mapChangedFields.get(KapConstants.KAP_FLD_RELATIONSHIP_KBS_PARENT_ID);
        RelationshipType    = mapChangedFields.get(KapConstants.KAP_FLD_RELATIONSHIP_TYPE);
        FirstName          = mapChangedFields.get(KapConstants.KAP_FLD_RELATIONSHIP_FIRST_NAME);
        LastName            = mapChangedFields.get(KapConstants.KAP_FLD_RELATIONSHIP_LAST_NAME);
        
        Phone1            = mapChangedFields.get(KapConstants.KAP_FLD_RELATIONSHIP_PHONE_1);
        Phone1Extension  = mapChangedFields.get(KapConstants.KAP_FLD_RELATIONSHIP_PHONE_1_EXTENSION);
        if (((Phone1Extension != null) && (Phone1Extension != '')) && ((Phone1 == null) || (Phone1 == ''))) {
            Phone1 = relationship.Phone_1__c;
        }
        
        Phone2            = mapChangedFields.get(KapConstants.KAP_FLD_RELATIONSHIP_PHONE_2);
        Phone2Extension  = mapChangedFields.get(KapConstants.KAP_FLD_RELATIONSHIP_PHONE_2_EXTENSION);
        if (((Phone2Extension != null) && (Phone2Extension != '')) && ((Phone2 == null) || (Phone2 == ''))) {
            Phone2 = relationship.Phone_2__c;
        }
        
        Email1            = mapChangedFields.get(KapConstants.KAP_FLD_RELATIONSHIP_EMAIL_1);
        Email2            = mapChangedFields.get(KapConstants.KAP_FLD_RELATIONSHIP_EMAIL_2);

        if ((RelationshipType != null) || (FirstName != null) || (LastName != null)
                 || (Phone1 != null) || (Phone1Extension != null)
                 || (Phone2 != null) || (Phone2Extension != null)
                 || (Email1 != null) || (Email2 != null)) {
            KapGetRealRelationshipVO relationshipVO = new KapGetRealRelationshipVO();
            
            if (RelationshipType == null)
                RelationshipType = 'Parent';
            
            relationshipVO.kbs_parent_id = LegacyParentId;
            
            System.Debug('***************************************');
            System.Debug('In populateStudentRelationship LastName : '+LastName);
            System.Debug('***************************************');
            
            if (RelationshipType != null)   relationshipVO.relationship_type    = RelationshipType;
            if (FirstName != null)        relationshipVO.f_name            = FirstName;
            if (LastName != null)          relationshipVO.l_name               = LastName;
            if (Phone1 != null)          relationshipVO.phone_1           = Phone1;
            if (Phone1Extension != null)    relationshipVO.phone_1_extension    = Phone1Extension;
            if (Phone2 != null)          relationshipVO.phone_2           = Phone2;
            if (Phone2Extension != null)    relationshipVO.phone_2_extension    = Phone2Extension;
            if (Email1 != null)          relationshipVO.email_address_1   = Email1;
            if (Email2 != null)          relationshipVO.email_address_2   = Email2;
            
            personRec.relationshipList.add(relationshipVO);
        }

        return personRec;
    }

    
    public static KapGetRealPersonVO populateStudentInteraction(KapGetRealPersonVO personRec, Map<String, String> mapChangedFields) {
        String InteractionType, InteractionDate, InteractionContact, Reason, Comment, NoInterest, InteractionUser, InteractionProgram;
        String ProgramsOfInterest, ProgramOfInterest;
        List<Account> accts;
        List<Case> cases;
        
        List<Task> activities = [SELECT WhatId FROM Task WHERE Id = :personRec.id];  //Person Rec temporarily holds the activity id.
        if (activities.size() > 0) {
            String whatId = String.valueOf(activities[0].WhatId).substring(0,3);
            if (whatId.equals(KapConstants.KAP_SFDC_ACCOUNT_ID_PREFIX)) {
                accts = [SELECT Programs_of_Interest__c, Name FROM Account WHERE Id = :activities[0].WhatId];
            } else if (whatId.equals(KapConstants.KAP_SFDC_CASE_ID_PREFIX)) {
                cases = [SELECT AccountId FROM Case WHERE Id = :activities[0].WhatId];
                accts = [SELECT Programs_of_Interest__c, Name FROM Account WHERE Id = :cases[0].AccountId];
            }
        }
        //List<Account> accts = [SELECT Programs_of_Interest__c, Name FROM Account WHERE Id = :activities[0].WhatId];
        //List<Case> cases = [SELECT Programs_of_Interest__c, Name FROM Case WHERE Id = :activities[0].WhatId];
        
        if (accts.size() > 0) {
            ProgramsOfInterest = accts[0].Programs_of_Interest__c;
            ProgramOfInterest = (ProgramsOfInterest != null && ProgramsOfInterest != '')?ProgramsOfInterest.split(', ')[0]:'';
            InteractionContact = accts[0].Name;
        }

        //InteractionType   = mapChangedFields.get(KapConstants.KAP_FLD_INTERACTION_TYPE);
        InteractionType  = 'Inbound Call';
        InteractionDate  = mapChangedFields.get(KapConstants.KAP_FLD_INTERACTION_LAST_MODIFIED_DATE);
        //InteractionContact    = mapChangedFields.get(KapConstants.KAP_FLD_INTERACTION_CONTACT);
        Reason            = mapChangedFields.get(KapConstants.KAP_FLD_INTERACTION_REASON);
        Comment          = mapChangedFields.get(KapConstants.KAP_FLD_INTERACTION_COMMENT);
        NoInterest        = mapChangedFields.get(KapConstants.KAP_FLD_INTERACTION_NO_INTEREST);
        InteractionUser  = mapChangedFields.get(KapConstants.KAP_FLD_INTERACTION_KBS_USER_ID);
        InteractionProgram  = ProgramOfInterest;

        if ((InteractionType != null) || (InteractionDate != null) || (InteractionContact != null) || (Reason != null) || (Comment != null) || (NoInterest != null) || (InteractionUser != null)) {
            KapGetRealInteractionVO interactionVO = new KapGetRealInteractionVO();
            
            if (InteractionType != null)    interactionVO.interaction_type  = InteractionType;
            if (InteractionDate != null)    interactionVO.interaction_date  = InteractionDate;
            if (InteractionContact != null) interactionVO.contact          = InteractionContact;
            if (Reason != null)          interactionVO.reason           = Reason;
            if (Comment != null)            interactionVO.comment          = Comment;
            if (NoInterest != null)      interactionVO.no_interest     = NoInterest;
            if (InteractionUser != null)    interactionVO.user            = InteractionUser;
            if (InteractionProgram != null) interactionVO.program          = InteractionProgram;
            
            personRec.interactionList.add(interactionVO);
        }
        
        return personRec;
    }

    
    public static KapGetRealPersonVO populateStudentCaseAsInteraction(KapGetRealPersonVO personRec, Map<String, String> mapChangedFields) {
        String InteractionType, InteractionDate, InteractionContact, Reason, Comment, NoInterest, InteractionUser, InteractionProgram;
        String caseNumber, caseAccount, caseType, caseSubject, caseDescription, caseDetail, caseStatus, caseTypeDetail, caseResolutionType, caseLastModifiedDate, caseLastModifiedBy;
        String ProgramsOfInterest, ProgramOfInterest;

        List<Case> cases = [SELECT Enrollment__r.Kaplan_Program__c, AccountId, Account.Name FROM Case WHERE Id = :personRec.id];     //Person Rec temporarily holds the case id.
        ProgramOfInterest = cases[0].Enrollment__r.Kaplan_Program__c;
        if (ProgramOfInterest == null || ProgramOfInterest == '') {
            List<Account> accts = [SELECT Programs_of_Interest__c FROM Account WHERE Id = :cases[0].AccountId];
            ProgramsOfInterest = accts[0].Programs_of_Interest__c;
            ProgramOfInterest = (ProgramsOfInterest != null && ProgramsOfInterest != '')?ProgramsOfInterest.split(', ')[0]:'';
        }
        InteractionContact = cases[0].Account.Name;

        caseNumber            = mapChangedFields.get(KapConstants.KAP_FLD_CASE_NUMBER);
        caseType                = mapChangedFields.get(KapConstants.KAP_FLD_CASE_TYPE);
        caseSubject          = mapChangedFields.get(KapConstants.KAP_FLD_CASE_SUBJECT);
        caseStatus            = mapChangedFields.get(KapConstants.KAP_FLD_CASE_STATUS);
        caseTypeDetail        = mapChangedFields.get(KapConstants.KAP_FLD_CASE_TYPE_DETAIL);
        caseResolutionType    = mapChangedFields.get(KapConstants.KAP_FLD_CASE_RESOLUTION_TYPE);
        caseLastModifiedDate    = mapChangedFields.get(KapConstants.KAP_FLD_CASE_LAST_MODIFIED_DATE);
        caseLastModifiedBy    = mapChangedFields.get(KapConstants.KAP_FLD_CASE_LAST_MODIFIED_BY);
        caseDescription      = mapChangedFields.get(KapConstants.KAP_FLD_CASE_DESCRIPTION);
        InteractionProgram    = ProgramOfInterest;
        
        if (caseStatus != null && caseStatus.contains('Closed'))
            InteractionType = 'Case Closed';
        else
            InteractionType = 'Case Opened';
            
        InteractionDate  = caseLastModifiedDate;
        //InteractionContact    = caseAccount;
        Reason            = caseSubject;
        Comment          = (caseType != ''?'Type: '+caseType:'')
                                + (caseStatus != ''? '\nStatus: '+caseStatus:'')
                                + (caseTypeDetail != ''? '\nType Detail: '+caseTypeDetail:'')
                                + (caseResolutionType != ''? '\nResolution: '+caseResolutionType:'')
                                + (caseDescription != ''? '\nDescription: '+caseDescription:'');
        NoInterest        = '';
        //InteractionUser   = caseLastModifiedBy;
        InteractionUser  = mapChangedFields.get(KapConstants.KAP_FLD_INTERACTION_KBS_USER_ID);

        if ((InteractionType != null) || (InteractionDate != null) || (InteractionContact != null) || (Reason != null) || (Comment != null) || (NoInterest != null) || (InteractionUser != null)) {
            KapGetRealInteractionVO interactionVO = new KapGetRealInteractionVO();
            
            if (InteractionType != null)    interactionVO.interaction_type  = InteractionType;
            if (InteractionDate != null)    interactionVO.interaction_date  = InteractionDate;
            if (InteractionContact != null) interactionVO.contact          = InteractionContact;
            if (Reason != null)          interactionVO.reason           = Reason;
            if (Comment != null)            interactionVO.comment          = Comment;
            if (NoInterest != null)      interactionVO.no_interest     = NoInterest;
            if (InteractionUser != null)    interactionVO.user            = InteractionUser;
            if (InteractionProgram != null) interactionVO.program          = InteractionProgram;
            
            personRec.interactionList.add(interactionVO);
        }
        return personRec;
    }
    
     
    public static KapGetRealPersonVO populateCaseInteraction(KapGetRealPersonVO personRec, Map<String, String> mapChangedFields) {
        String InteractionType, InteractionDate, InteractionContact, Reason, Comment, NoInterest, InteractionUser, InteractionProgram;
        String ProgramsOfInterest, ProgramOfInterest;
        List<Account> accts;
        List<Case> cases;

        List<Task> activities = [SELECT WhatId FROM Task WHERE Id = :personRec.id];  //Person Rec temporarily holds the activity id.
        if (activities.size() > 0) {
            cases = [SELECT Enrollment__r.Kaplan_Program__c, AccountId, Account.Name FROM Case WHERE Id = :activities[0].WhatId];   
            ProgramOfInterest = cases[0].Enrollment__r.Kaplan_Program__c;
            if (ProgramOfInterest == null || ProgramOfInterest == '') {
                accts = [SELECT Programs_of_Interest__c FROM Account WHERE Id = :cases[0].AccountId];
                ProgramsOfInterest = accts[0].Programs_of_Interest__c;
                ProgramOfInterest = (ProgramsOfInterest != null && ProgramsOfInterest != '')?ProgramsOfInterest.split(', ')[0]:'';
            }
            InteractionContact = cases[0].Account.Name;
        }
        
        //InteractionType   = mapChangedFields.get(KapConstants.KAP_FLD_INTERACTION_TYPE);
        InteractionType  = 'Inbound Call';
        InteractionDate  = mapChangedFields.get(KapConstants.KAP_FLD_INTERACTION_LAST_MODIFIED_DATE);
        //InteractionContact    = mapChangedFields.get(KapConstants.KAP_FLD_INTERACTION_CONTACT);
        Reason            = mapChangedFields.get(KapConstants.KAP_FLD_INTERACTION_REASON);
        Comment          = mapChangedFields.get(KapConstants.KAP_FLD_INTERACTION_COMMENT);
        NoInterest        = mapChangedFields.get(KapConstants.KAP_FLD_INTERACTION_NO_INTEREST);
        InteractionUser  = mapChangedFields.get(KapConstants.KAP_FLD_INTERACTION_KBS_USER_ID);
        InteractionProgram  = ProgramOfInterest;

        if ((InteractionType != null) || (InteractionDate != null) || (InteractionContact != null) || (Reason != null) || (Comment != null) || (NoInterest != null) || (InteractionUser != null)) {
            KapGetRealInteractionVO interactionVO = new KapGetRealInteractionVO();
            
            if (InteractionType != null)    interactionVO.interaction_type  = InteractionType;
            if (InteractionDate != null)    interactionVO.interaction_date  = InteractionDate;
            if (InteractionContact != null) interactionVO.contact          = InteractionContact;
            if (Reason != null)          interactionVO.reason           = Reason;
            if (Comment != null)            interactionVO.comment          = Comment;
            if (NoInterest != null)      interactionVO.no_interest     = NoInterest;
            if (InteractionUser != null)    interactionVO.user            = InteractionUser;
            if (InteractionProgram != null) interactionVO.program          = InteractionProgram;
            
            personRec.interactionList.add(interactionVO);
        }
        
        return personRec;
    }

    
    public static KapGetRealPersonVO getIntegrationObjectPersonRec(Integration_Object__c intObject) {
        KapGetRealPersonVO personRec = new KapGetRealPersonVO();
        
        personRec.addressList = new List<KapGetRealAddressVO>();
        personRec.phoneList = new List<KapGetRealPhoneVO>();
        personRec.emailList = new List<KapGetRealEmailVO>();
        personRec.exclusionList = new List<KapGetRealExclusionVO>();
        personRec.intlInfoList = new List<KapGetRealInternationalInfoVO>();
        personRec.relationshipList = new List<KapGetRealRelationshipVO>();
        personRec.interactionList = new List<KapGetRealInteractionVO>();
        
        /*
        ** Student Profile Update
        ** - Populate Student Basic Profile, Address, Phone & Email, International Info
        ** Student Relationship Update
        ** - Populate Student Id, Relationship
        ** Student Activity Update
        ** - Populate Student Id, Interaction (Activity Info)
        ** Case Creation/Close Update
        ** - Populate Student Id, Interaction (Case Info)
        ** Case Activity Update
        ** - Populate Student Id, Interaction (Case Activity Info)
        */
        
        String objectType = intObject.Object_Type__c;
        
        Map<String, String> changedFieldsMap = getChangedFields(intObject);
        
        personRec.id = changedFieldsMap.get(KapConstants.KAP_FLD_OBJECT_ID);
        personRec.student_id = changedFieldsMap.get(KapConstants.KAP_FLD_STUDENT_STUDENT_ID);
        
        if (objectType == 'Account') {
            personRec = populateStudentBasicProfile(personRec, changedFieldsMap);
            
            System.Debug('***************************************');
            System.Debug(LoggingLevel.INFO,'In getIntegrationObjectPersonRec : PersonFirstName : '+personRec.f_name);
            System.Debug('***************************************');
            
            addressLine1Queried = false;
            phoneNumberQueried = false;
            personRec = populateStudentAddress(personRec, changedFieldsMap, 'Perm');
            personRec = populateStudentAddress(personRec, changedFieldsMap, 'School');
            personRec = populateStudentAddress(personRec, changedFieldsMap, 'Work');
            personRec = populateStudentAddress(personRec, changedFieldsMap, 'Other');
            personRec = populateStudentPhoneAndEmail(personRec, changedFieldsMap);
            personRec = populateStudentExclusionInfo(personRec, changedFieldsMap);
            personRec = populateStudentIntlInfo(personRec, changedFieldsMap);
        } else if (objectType == 'Relationship__c') {
            personRec = populateStudentRelationship(personRec, changedFieldsMap);
        } else if (objectType == 'Case') {
            personRec = populateStudentCaseAsInteraction(personRec, changedFieldsMap);
        } else if (objectType == 'Account Task') {
            personRec = populateStudentInteraction(personRec, changedFieldsMap);
        } else if (objectType == 'Case Task') {
            personRec = populateCaseInteraction(personRec, changedFieldsMap);
        }
        
        System.Debug('***************************************');
        System.Debug('In getIntegrationObjectPersonRec : PersonFirstName (2) : '+personRec.f_name);
        System.Debug('***************************************');
        
        return personRec;
    }

    
    public static Map<String, String> getChangedFields(Integration_Object__c intObject) {
        Map<String, String> mapChangedFields = new Map<String, String>();
        List<Integration_Object_Field__c> intObjectFields;
        
        intObjectFields = [SELECT Changed_Field__c, Changed_Value__c FROM Integration_Object_Field__c WHERE Integration_Object__c = :intObject.Id];
        
        for (Integration_Object_Field__c intObjField: intObjectFields) {
            mapChangedFields.put(intObjField.Changed_Field__c, intObjField.Changed_Value__c);
        }
        
        mapChangedFields.put('object_id',intObject.Object_Id__c);
        mapChangedFields.put('object_type',intObject.Object_Type__c);
        mapChangedFields.put('student_id__c',String.valueOf(intObject.Student_Id__c));
        mapChangedFields.put('legacy_parent_id__c',String.valueOf(intObject.Legacy_Parent_Id__c));
        mapChangedFields.put('kbs_user_id__c',String.valueOf(intObject.KBS_User_Id__c));
        mapChangedFields.put('lastmodifiedby',intObject.User_Name__c);
              
        return mapChangedFields;
    }

    
    public static String getGetRealResponseCodeText(Integer getRealResponseCode) {
        return mapGetRealResponseCodeText.get(getRealResponseCode);
    } 

    
    public static void handleGetRealResponse(String xmlRequest, KapXmlResponseWS xmlResponse, Integration_Object__c intObject) {
        Dom.Document xmlDoc;
        Dom.XMLNode xmlNode, responseNode;
        Dom.XMLNode payloadNode, messageResultsNode, messageNode, resultNode, personNode, relationshipNode;
        Dom.XMLNode errorNode, errorNameNode, errorCodeNode, errorDescriptionNode, errorDetailNode;
        String errorName, errorCode, errorDescription, errorDetail, resultStatus;
        String nodeName;
        Integer xmlResponseStatusCode;
        String xmlResponseMessage;
        String intObjectStatus, intObjectXmlResponse;
        Integer retryCount;
        String returnedRelationshipParentId, returnedAccountabilityId;
        
        initGetRealResponseCodeText();
        
        xmlResponseStatusCode = xmlResponse.statusCode;
        xmlResponseMessage = xmlResponse.xmlBody;
        
        xmlDoc = new Dom.Document();
        try {
            xmlDoc.load(xmlResponseMessage);
            xmlNode = xmlDoc.getRootElement(); //Must be <response> node
            nodeName = xmlNode.getName();
        } catch(Exception e) {
            
        }
        
        intObjectStatus = 'Retry';
        
        if (nodeName == 'response') {
            responseNode = xmlNode;
            
            payloadNode = responseNode.getChildElement('payload', null);
            if (payloadNode != null) {
                messageResultsNode = payloadNode.getChildElement('message_results', null);
                messageNode = messageResultsNode.getChildElement('message', null);
                resultNode = messageNode.getChildElement('result', null);
                personNode = messageNode.getChildElement('person', null);
                try {
                    relationshipNode = personNode.getChildElement('relationship', null);
                    returnedRelationshipParentId = relationshipNode.getAttributeValue('uid', null);
                    returnedAccountabilityId = relationshipNode.getAttributeValue('acc_id', null);
                } catch (Exception e) {
                    System.debug('No Relationship Node present or missing atrributes.');
                    System.debug('Relationship Node Value: '+relationshipNode);
                    System.debug('UID Atrribute Value: '+returnedRelationshipParentId);
                    System.debug('ACC_ID Atrribute Value: '+returnedAccountabilityId);
                    System.debug(e);
                }
                
                if (resultNode != null) resultStatus = resultNode.getAttributeValue('status', null);
            }
            
            errorNode = responseNode.getChildElement('error', null);
            if (errorNode != null) {
                errorNameNode = errorNode.getChildElement('name', null);
                errorCodeNode = errorNode.getChildElement('code', null);
                errorDescriptionNode = errorNode.getChildElement('description', null);
                errorDetailNode = errorNode.getChildElement('detail', null);
                
                if (errorNameNode != null) errorName = errorNameNode.getText();
                if (errorCodeNode != null) errorCode = errorCodeNode.getText();
                if (errorDescriptionNode != null) errorDescription = errorDescriptionNode.getText();
                if (errorDetailNode != null) errorDetail = errorDetailNode.getText();
            }
        }

        if (xmlResponseStatusCode != 200) {
            // Error Condition
            if (xmlResponseStatusCode == 400) {
                // Server Unavailable
                intObjectStatus = 'Error';
            } else if (xmlResponseStatusCode == 500) {
                // Flag Message to be Resent
                intObjectStatus = 'Retry';
            }
        } else {
            // Message Received Successfully by Server
            // Check Result Status Code for processing status   
            if (resultStatus == KapConstants.KAP_GETREAL_RESP_CODE_PROCESSED) {
                intObjectStatus = 'Completed';
            } else if (resultStatus == KapConstants.KAP_GETREAL_RESP_CODE_RESOLVABLE_ERROR) {
                intObjectStatus = 'Completed';
            } else {
                intObjectStatus = 'Error';
            }
        }
        
        retryCount = 0;
        if (intObject.Retry_Count__c != null)
            retryCount = Integer.valueOf(intObject.Retry_Count__c);
            
        if (retryCount >= getRealMaxRetryCount)  {
            if (intObjectStatus == 'Retry') 
                intObjectStatus = 'Retry Count Exceeded';
        } else {
            retryCount = retryCount+1;  
        }
            
        intObject.Status__c = intObjectStatus;
        intObject.Retry_Count__c =  retryCount;
        intObject.HTTP_Status_Code__c = xmlResponseStatusCode;
        intObject.GetReal_Status_Code__c = Decimal.valueOf(((resultStatus != null)?resultStatus:'-1'));
        intObject.GetReal_Status_Code_Text__c = mapGetRealResponseCodeText.get(Integer.valueOf(((resultStatus != null)?resultStatus:'-1')));
        intObject.XML_Request__c = xmlRequest;
        intObject.XML_Response__c = xmlResponseMessage;
        intObject.Message_Id_Suffix_Iterator__c = messageIdSuffixIterator; 
        
        update intObject;
        
        if ((intObject.Object_Type__c == 'Relationship__c') && (resultStatus == KapConstants.KAP_GETREAL_RESP_CODE_PROCESSED)) {
            List<Relationship__c> relationships = [SELECT Id, Legacy_Parent_Id__c, Relationship_Id__c FROM Relationship__c WHERE Id = :intObject.Object_Id__c];
            if (relationships.size() > 0) {
                Relationship__c relationship = relationships[0];
                Boolean updateRelationship = false;
                
                if ((relationship.Legacy_Parent_Id__c == null) || (relationship.Legacy_Parent_Id__c == '')) {
                    if ((returnedRelationshipParentId != null) && (returnedRelationshipParentId != '')) {
                        relationship.Legacy_Parent_Id__c = returnedRelationshipParentId;
                        updateRelationship = true;
                        //update relationship;
                    }
                }
                
                if ((relationship.Relationship_Id__c == null) || (relationship.Relationship_Id__c == '')) {
                    if ((returnedAccountabilityId != null) && (returnedAccountabilityId != '')) {
                        relationship.Relationship_Id__c = returnedAccountabilityId;
                        updateRelationship = true;
                        //update relationship;
                    }
                }
                
                if(updateRelationship) {
                    update relationship;
                }
            }
        }
    }

    
    public static void handleGetRealError(String errorMesg, String xmlRequest, KapXmlResponseWS xmlResponse, Integration_Object__c intObject) {
        String nodeName;
        Integer xmlResponseStatusCode;
        String xmlResponseMessage;
        String intObjectStatus, resultStatus;
        Integer retryCount;
        
        initGetRealResponseCodeText();
        
        xmlResponseStatusCode = xmlResponse.statusCode;
        xmlResponseMessage = xmlResponse.xmlBody;
        
        intObjectStatus = 'Retry';
        
        retryCount = 0;
        if (intObject.Retry_Count__c != null)
            retryCount = Integer.valueOf(intObject.Retry_Count__c);
            
        if (retryCount >= getRealMaxRetryCount)  {
            if (intObjectStatus == 'Retry') 
                intObjectStatus = 'Retry Count Exceeded';
        } else {
            retryCount = retryCount+1;  
        }
            
        intObject.Status__c = intObjectStatus;
        intObject.Retry_Count__c =  retryCount;
        intObject.HTTP_Status_Code__c = xmlResponseStatusCode;
        intObject.GetReal_Status_Code__c = Decimal.valueOf(((resultStatus != null)?resultStatus:'-1'));
        intObject.GetReal_Status_Code_Text__c = errorMesg;
        intObject.XML_Request__c = xmlRequest;
        intObject.XML_Response__c = xmlResponseMessage;
        intObject.Message_Id_Suffix_Iterator__c = messageIdSuffixIterator; 
        
        update intObject;

    }
    
    
    public static String createMessageList(Integration_Object__c intObject) {
        String messageGroupId, clientName;
        XMLStreamWriter w = new XMLStreamWriter();
        /*
        ** 'message_group_id' field must contain the integraion Batch Id 
        ** 'client_name' field must contain the source system ('Salesforce.com') 
        **
        */
        
        if (intObject == null)
            return null;
        
        clientName = 'salesforce';
        messageGroupId = getRealMessagePrefix + '-' + intObject.Record_Number__c;
        System.Debug('***************************************');
        System.Debug('In createMessageList : Message Group Id '+messageGroupId);
        System.Debug('***************************************');

        w.writeStartDocument('UTF-8', '1.0');
        w.writeStartElement('', 'message_batch', '');
        w.writeAttribute('', '', 'message_group_id', KapUtil.handleNullString(messageGroupId));
        w.writeAttribute('', '', 'client_name', KapUtil.handleNullString(clientName));
        createMessage(w, intObject);
        w.writeEndElement();
        w.writeEndDocument();
        
        System.Debug('***************************************');
        System.Debug('In createMessageList : Stream '+w.getXmlString());
        System.Debug('***************************************');
        
        return w.getXmlString();
    }
    
    
    public static void createMessage(XMLStreamWriter w, Integration_Object__c intObject) {
        String messageId, clientName;
        KapGetRealPersonVO person = getIntegrationObjectPersonRec(intObject);
        /*
        ** 'message_id' field must contain the integraion Object Id 
        ** 'client_name' field must contain the LastModifyBys user name
        **
        */
        
        messageIdSuffixIterator = Integer.valueOf(intObject.Message_Id_Suffix_Iterator__c);
        messageIdSuffixIterator = messageIdSuffixIterator + 1;
        
        messageId = getRealMessagePrefix + '-' + intObject.Record_Number__c;
        clientName = KapUtil.truncateSFDCUserNameSuffix(intObject.User_Name__c);
        
        messageId = messageId+'-'+messageIdSuffixIterator;
    
        System.Debug('***************************************');
        System.Debug('In createMessage: PersonFirstName : '+person.f_name);
        System.Debug('In createMessage: Message Id : '+messageId);
        System.Debug('In createMessage: Client Name : '+clientName);
        System.Debug('***************************************');
        
        w.writeStartElement('', 'message', '');
        w.writeAttribute('', '', 'message_id', KapUtil.handleNullString(messageId));
        w.writeAttribute('', '', 'client_name', KapUtil.handleNullString(clientName));
        createPersonNode(w, person);
        w.writeEndElement();
    }
    

    public static void createPersonNode(XMLStreamWriter w, KapGetRealPersonVO person) {
        
        System.Debug('***************************************');
        System.Debug('In createPersonNode: PersonFirstName : '+person.f_name);
        System.Debug('***************************************');
        
        w.writeStartElement('', 'person', '');
        w.writeAttribute('', '', 'client_sys_id', KapUtil.handleNullString(person.id));
        w.writeAttribute('', '', 'uid', KapUtil.handleNullString(person.student_id));
        addTextElement(w,'f_name',KapUtil.handleNullString(person.f_name));
        addTextElement(w,'m_name',KapUtil.handleNullString(person.m_name));
        addTextElement(w,'l_name',KapUtil.handleNullString(person.l_name));
        addTextElement(w,'entry_date',KapUtil.handleNullString(person.entry_date));
        addTextElement(w,'natl_donotcall',KapUtil.handleNullString(person.natl_donotcall));
        /*
        addTextElement(w,'entry_date',KapUtil.handleNullString(person.do_not_call));
        addTextElement(w,'entry_date',KapUtil.handleNullString(person.do_not_email));
        addTextElement(w,'entry_date',KapUtil.handleNullString(person.do_not_mail));
        addTextElement(w,'entry_date',KapUtil.handleNullString(person.do_not_share));
        */

        if (person.addressList.size() > 0) {
            createAddressList(w, person);
        }
        if (person.phoneList.size() > 0) {
            createPhoneList(w, person);
        }
        if (person.emailList.size() > 0) {
            createEmailList(w, person);
        }
        if (person.exclusionList.size() > 0) {
            createExclusionList(w, person);
        }
        if (person.intlInfoList.size() > 0) {
            createInternationalInfoNode(w, person);
        }
        if (person.relationshipList.size() > 0) {
            createRelationshipList(w, person);
        }
        if (person.interactionList.size() > 0) {
            createInteractionList(w, person);
        }
        w.writeEndElement();

    }

    
    public static void createAddressList(XMLStreamWriter w, KapGetRealPersonVO person) {
        
        if((person.addressList != null) && (person.addressList.size() > 0)) {
            w.writeStartElement('', 'address_list', '');
            for (KapGetRealAddressVO address: person.addressList) {
                createAddressNode(w, address);
            }
            w.writeEndElement();
        }
        
        /*
        System.Debug('***************************************');
        System.Debug('In createAddressList: Node : '+addressListNode.getText());
        System.Debug('In createAddressList: Document : '+doc.toXMLString());
        System.Debug('***************************************');
        */
    }

    
    public static void createAddressNode(XMLStreamWriter w, KapGetRealAddressVO address) {
        
        w.writeStartElement('', 'address', '');
        addTextElement(w, 'type', KapUtil.handleNullString(address.addr_type));
        addTextElement(w, 'line_1', KapUtil.handleNullString(address.line_1));
        addTextElement(w, 'line_2', KapUtil.handleNullString(address.line_2));
        addTextElement(w, 'line_3', KapUtil.handleNullString(address.line_3));
        addTextElement(w, 'city', KapUtil.handleNullString(address.city));
        addTextElement(w, 'state', KapUtil.handleNullString(address.state));
        addTextElement(w, 'postal_code', KapUtil.handleNullString(address.postal_code));
        addTextElement(w, 'country', KapUtil.handleNullString(address.country));
        addTextElement(w, 'start_date', KapUtil.handleNullString(address.start_date));
        addTextElement(w, 'end_date', KapUtil.handleNullString(address.end_date));
        addTextElement(w, 'mail', KapUtil.handleNullString(address.mail));
        w.writeEndElement();
        
        /*
        System.Debug('***************************************');
        System.Debug('In createAddressNode: Node : '+addressNode);
        System.Debug('In createAddressNode: Document : '+doc.toXMLString());
        System.Debug('***************************************');
        */
    }

    /*
    <lead_list>
            <lead>
               <type>stu</type>
               <source>Website- Kaplan Website</source>
               <channel>20</channel>
               <interest_list>
                  <interest>
                     <primary>true</primary>
                     <program>ACT</program>
                  </interest>
               </interest_list>
            </lead>
         </lead_list>
    */
    public static void createLeadList(XMLStreamWriter w, KapGetRealPersonVO person) {

        w.writeStartElement('', 'lead_list', '');
        w.writeStartElement('', 'lead', '');
        addTextElement(w, 'type', 'stu');
        addTextElement(w, 'source', 'Website- Kaplan Website');
        addTextElement(w, 'channel', '20');
        w.writeStartElement('', 'interest_list', '');
        
        for (KapGetRealCCOrderItemVO itemVO: person.cloudCrazeOrder.itemList) {
            w.writeStartElement('', 'interest', '');
            addTextElement(w, 'primary', 'true');
            addTextElement(w, 'product', itemVO.productCode);
            w.writeEndElement();
        }
        
        w.writeEndElement();
        w.writeEndElement();
        w.writeEndElement();        
    }
        
    /*
         <accountability_list>
            <accountability>
               <subordinateUID>90000712</subordinateUID>
               <type>school_student</type>
               <grad_year>1973</grad_year>
            </accountability>
         </accountability_list>
    */     
    public static void createAccountabilityList(XMLStreamWriter w, KapGetRealPersonVO person) {

        w.writeStartElement('', 'accountability_list', '');
        //Roster Changes Begin
        w.writeStartElement('', 'accountability', '');
        System.debug('Inside AccountabilityList and the value of Schoolid is :: '+person.subordinateUID);
        System.debug('Inside AccountabilityList and the value of Schoolid is :: '+person.grad_year);
        addTextElement(w, 'subordinateUID', KapUtil.handleNullString(person.subordinateUID));
        addTextElement(w, 'grad_year', KapUtil.handleNullString(person.grad_year));
        w.writeEndElement();
        //Roster Changes End
        w.writeEndElement();        
    }

    public static void createPhoneList(XMLStreamWriter w, KapGetRealPersonVO person) {

        boolean hasAtleastOnePhone = false;
        for (KapGetRealPhoneVO phone: person.phoneList) {
            if (phone.phone_number != null) {
                hasAtleastOnePhone = true;
            }
        }
        
        if(hasAtleastOnePhone) {
            w.writeStartElement('', 'phone_list', '');
            for (KapGetRealPhoneVO phone: person.phoneList) {
                if (phone.phone_number != null) {
                    createPhoneNode(w, phone);
                }
            }
            w.writeEndElement();
        }
        
        /*
        System.Debug('***************************************');
        System.Debug('In createPhoneList : Node : '+phoneListNode.getText());
        System.Debug('***************************************');
        */
    }

    
    public static void createPhoneNode(XMLStreamWriter w, KapGetRealPhoneVO phone) {
        String phoneNumber = KapUtil.handleNullString(phone.phone_number);
        
        w.writeStartElement('', 'phone', '');

        if (phoneNumber.equals('nullify'))
            w.writeAttribute('', '', 'cmd', '-1');
            
        addTextElement(w, 'index', KapUtil.handleNullString(phone.index));
        addTextElement(w, 'number', KapUtil.handleNullString(phone.phone_number));
        addTextElement(w, 'ext', KapUtil.handleNullString(phone.ext));
        addTextElement(w, 'type', KapUtil.handleNullString(phone.phone_type));
        w.writeEndElement();
        
        /*
                <phone>
                    <index>0</index>
                    <number>1231231231</number>
                </phone>
        */
        
        /*
        System.Debug('***************************************');
        System.Debug('In createPhoneNode: Node : '+phoneNode);
        System.Debug('***************************************');
        */
    }

    
    public static void createEmailList(XMLStreamWriter w, KapGetRealPersonVO person) {

        w.writeStartElement('', 'email_list', '');
        for (KapGetRealEmailVO email: person.emailList) {
            createEmailNode(w, email);
        }
        w.writeEndElement();
        
        /*
        System.Debug('***************************************');
        System.Debug('In createEmailList : Node : '+emailListNode.getText());
        System.Debug('***************************************');
        */
    }

    
    public static void createEmailNode(XMLStreamWriter w, KapGetRealEmailVO email) {
        String emailAddress = KapUtil.handleNullString(email.email_address);
        
        w.writeStartElement('', 'email', '');

        if (emailAddress.equals('nullify'))
            w.writeAttribute('', '', 'cmd', '-1');
            
        addTextElement(w, 'index', KapUtil.handleNullString(email.index));
        addTextElement(w, 'e_address', KapUtil.handleNullString(email.email_address));
        w.writeEndElement();
        
        /*
                <email>
                    <index>0</index>
                    <e_address>vijay.srinivasan@kaplan.com</e_address>
                </email>
        */
        
        /*
        System.Debug('***************************************');
        System.Debug('In createEmailNode : Node : '+emailNode);
        System.Debug('***************************************');
        */
    }

    
    public static void createExclusionList(XMLStreamWriter w, KapGetRealPersonVO person) {

        w.writeStartElement('', 'exclusion_list', '');
        for (KapGetRealExclusionVO exclusion: person.exclusionList) {
            createExclusionNode(w, exclusion);
        }
        w.writeEndElement();
        
        /*
        System.Debug('***************************************');
        System.Debug('In createExclusionList : Node : '+emailListNode.getText());
        System.Debug('***************************************');
        */
    }

    
    public static void createExclusionNode(XMLStreamWriter w, KapGetRealExclusionVO exclusion) {
        
        w.writeStartElement('', 'exclusion', '');
        addTextElement(w, 'type', KapUtil.handleNullString(exclusion.excl_type));
        addTextElement(w, 'reason', KapUtil.handleNullString(exclusion.excl_reason));
        w.writeEndElement();
        
        /*
                <exclusion>
                    <type>Phone</type>
                    <reason>Customer Request</reason>
                </exclusion>
        */
        
        /*
        System.Debug('***************************************');
        System.Debug('In createExclusionNode : Node : '+emailNode);
        System.Debug('***************************************');
        */
    }
 
    
    public static void createInternationalInfoNode(XMLStreamWriter w, KapGetRealPersonVO person) {
        KapGetRealInternationalInfoVO intlInfo = person.intlInfoList[0];
        
        w.writeStartElement('', 'intl_info', '');
        addTextElement(w, 'agent', KapUtil.handleNullString(intlInfo.agent));
        addTextElement(w, 'birth_country', KapUtil.handleNullString(intlInfo.birth_country));
        addTextElement(w, 'country', KapUtil.handleNullString(intlInfo.country));
        addTextElement(w, 'background', KapUtil.handleNullString(intlInfo.background));
        addTextElement(w, 'isF1', KapUtil.handleNullString(intlInfo.isF1));
        addTextElement(w, 'aba_number', KapUtil.handleNullString(intlInfo.aba_number));
        w.writeEndElement();
        
        /*
                <intl_info>
                    <agent>0</agent>
                    <birth_country>0</birth_country>
                    <country>0</country>
                    <background>0</background>
                    <isF1>0</isF1>
                    <aba_number>0</aba_number>
                </intl_info>
        */
        
        /*
        System.Debug('***************************************');
        System.Debug('In createInternationalInfoNode : Node : '+internationalInfoNode.getText());
        System.Debug('***************************************');
        */
    }
    
    
    public static void createRelationshipList(XMLStreamWriter w, KapGetRealPersonVO person) {

        //w.writeStartElement('', 'relationship_list', '');
        for (KapGetRealRelationshipVO relationship: person.relationshipList) {
            createRelationshipNode(w, relationship, person);
        }
        //w.writeEndElement();
        
        /*
        System.Debug('***************************************');
        System.Debug('In createRelationshipListNode : Node : '+relationshipListNode.getText());
        System.Debug('***************************************');
        */
    }

    
    public static void createRelationshipNode(XMLStreamWriter w, KapGetRealRelationshipVO relationship, KapGetRealPersonVO person) {
        String phone1, phone2, phone1Extension, phone2Extension, email1, email2;
        String kbsParentId;
                
        phone1            = KapUtil.handleNullString(relationship.phone_1);
        phone1Extension  = KapUtil.handleNullString(relationship.phone_1_extension);
        phone2            = KapUtil.handleNullString(relationship.phone_2);
        phone2Extension  = KapUtil.handleNullString(relationship.phone_2_extension);
        email1            = KapUtil.handleNullString(relationship.email_address_1);
        email2            = KapUtil.handleNullString(relationship.email_address_2);
        
        w.writeStartElement('', 'relationship', '');
        w.writeAttribute('', '', 'client_sys_id', KapUtil.handleNullString(relationship.id));
        
        kbsParentId = KapUtil.handleNullString(relationship.kbs_parent_id);
        if (kbsParentId != '')
            w.writeAttribute('', '', 'uid', kbsParentId);
            
        addTextElement(w, 'f_name', KapUtil.handleNullString(relationship.f_name));
        addTextElement(w, 'l_name', KapUtil.handleNullString(relationship.l_name));
        addTextElement(w, 'type', KapUtil.handleNullString(relationship.relationship_type));
        
        if ((phone1 != '') || (phone1Extension != '') || (phone2 != '') || (phone2Extension != '')) {
            w.writeStartElement('', 'phone_list', '');
            if ((phone1 != '') || (phone1Extension != '')) {
                w.writeStartElement('', 'phone', '');
                addTextElement(w, 'index', '0');
                addTextElement(w, 'number', phone1);
                if (phone1Extension != '')
                    addTextElement(w, 'ext', phone1Extension);
                w.writeEndElement();
            }
            if ((phone2 != '') || (phone2Extension != '')) {
                w.writeStartElement('', 'phone', '');
                addTextElement(w, 'index', '1');
                addTextElement(w, 'number', phone2);
                if (phone2Extension != '')
                    addTextElement(w, 'ext', phone2Extension);
                w.writeEndElement();
            }
            w.writeEndElement();
        }
        
        if ((email1 != '') || (email2 != '')) {
            w.writeStartElement('', 'email_list', '');
            if (email1 != '') {
                w.writeStartElement('', 'email', '');
                addTextElement(w, 'index', '0');
                addTextElement(w, 'e_address', email1);
                w.writeEndElement();
            }
            if (email2 != '') {
                w.writeStartElement('', 'email', '');
                addTextElement(w, 'index', '1');
                addTextElement(w, 'e_address', email2);
                w.writeEndElement();
            }
            w.writeEndElement();
        }
        
        w.writeEndElement();
        
        /*
                <relationship>
                    <f_name>0</f_name>
                    <l_name>0</l_name>
                    <type>0</type>
                    <phone_list>
                        <phone>
                            <index>0</index>
                            <number>1231231231</number>
                        </phone>
                        <phone>
                            <index>1</index>
                            <number>1231231231</number>
                        </phone>
                    </phone_list>
                    <email_list>
                        <email>
                            <index>0</index>
                            <e_address>vijay.srinivasan@kaplan.com</e_address>
                        </email>
                        <email>
                            <index>1</index>
                            <e_address>vijay.srinivasan@kaplan.com</e_address>
                        </email>
                    </email_list>
                </relationship>
        */
        
        /*
        System.Debug('***************************************');
        System.Debug('In createRelationshipNode : Node : '+relationshipNode.getText());
        System.Debug('***************************************');
        */
    }
    
    
    public static void createInteractionList(XMLStreamWriter w, KapGetRealPersonVO person) {

        w.writeStartElement('', 'lead_list', '');
        w.writeStartElement('', 'lead', '');
        addTextElement(w, 'type', 'stu');
        w.writeStartElement('', 'interest_list', '');
        w.writeStartElement('', 'interest', '');
        addTextElement(w, 'program', KapUtil.handleNullString(person.interactionList[0].program));
        
        w.writeStartElement('', 'interaction_list', '');
        for (KapGetRealInteractionVO interaction: person.interactionList) {
            createInteractionNode(w, interaction, person);
        }
        w.writeEndElement();
        
        w.writeEndElement();
        w.writeEndElement();
        w.writeEndElement();
        w.writeEndElement();
        
        /*
        System.Debug('***************************************');
        System.Debug('In createInteractionList: Node : '+interactionListNode.getText());
        System.Debug('***************************************');
        */
    }
    

    public static void createInteractionNode(XMLStreamWriter w, KapGetRealInteractionVO interaction, KapGetRealPersonVO person) {
        Datetime dttm;
        String dttm_str;
        
        if(KapUtil.handleNullString(interaction.interaction_date) != '')
            dttm = Datetime.valueOfGMT(KapUtil.handleNullString(interaction.interaction_date));
        if (dttm != null) {
            dttm_str = dttm.format('MM/dd/yyyy hh:mm:ss a','EST');
            interaction.interaction_date = dttm_str;
        }
            
        w.writeStartElement('', 'interaction', '');
        w.writeAttribute('', '', 'client_sys_id', KapUtil.handleNullString(interaction.id));
        w.writeAttribute('', '', 'uid', KapUtil.handleNullString(person.student_id));
        addTextElement(w, 'type', KapUtil.handleNullString(interaction.interaction_type));
        addTextElement(w, 'contact', KapUtil.handleNullString(interaction.contact));
        addTextElement(w, 'date', KapUtil.handleNullString(interaction.interaction_date));
        addTextElement(w, 'reason', KapUtil.handleNullString(interaction.reason));
        
        addCDataElement(w, 'comment', KapUtil.handleNullString(interaction.comment));
        
        addTextElement(w, 'no_interest', 'true');
        String kbsUserId = KapUtil.handleNullString(interaction.user);
        if (kbsUserId != '')
            addTextElement(w, 'user', String.valueOf(Double.valueOf(kbsUserId).intValue()));
        else
            addTextElement(w, 'user', '0');
        w.writeEndElement();
        
        /*
                <interaction>
                    <type>0</type>
                    <contact>0</contact>
                    <date>0</date>
                    <reason>0</reason>
                    <comment>0</comment>
                    <no_interest>0</no_interest>
                    <user>0</user>
                </interaction>
        */
        
        /*
        System.Debug('***************************************');
        System.Debug('In createInteractionNode: Node : '+interactionNode.getText());
        System.Debug('***************************************');
        */
    }


    public static void addTextElement(XMLStreamWriter w, String elementName, String elementValue) {
        if ((elementValue != null) && (elementValue != '')) {
            w.writeStartElement('', elementName, '');
            if (elementValue != 'nullify')
                w.writeCharacters(elementValue);
            w.writeEndElement();
        }
    }


    public static void addCDataElement(XMLStreamWriter w, String elementName, String elementValue) {
        if ((elementValue != null) && (elementValue != '')) {
            w.writeStartElement('', elementName, '');
            if (elementValue != 'nullify')
                w.writeCData(elementValue);
            w.writeEndElement();
        }
    }
    
    /********************************************************
    BEGIN
    Kaplan Test Prep Iron Cloud Project
    Following code inserted by CloudCraze team
    *********************************************************/
    public static String createCloudCrazeOrderPlaceMessage(KapGetRealPersonVO person) {
        String messageGroupId, messageId, clientName;
        XMLStreamWriter w = new XMLStreamWriter();
        clientName = 'salesforce';

        //messageGroupId = getRealMessagePrefix + '-' + person.CloudCrazeMessageId;
        messageGroupId = 'CCORDER' + '-' + person.CloudCrazeMessageId;
        
        w.writeStartDocument('UTF-8', '1.0');
        w.writeStartElement('', 'message_batch', '');
            w.writeAttribute('', '', 'message_group_id', KapUtil.handleNullString(messageGroupId));
            w.writeAttribute('', '', 'client_name', KapUtil.handleNullString(clientName));
            
            messageIdSuffixIterator = 1;
            messageId = 'CCORDER' + '-' + person.CloudCrazeMessageId + '-' + messageIdSuffixIterator ;      
            
            w.writeStartElement('', 'message', '');
                w.writeAttribute('', '', 'message_id', KapUtil.handleNullString(messageId));
                w.writeAttribute('', '', 'client_name', KapUtil.handleNullString(clientName));
                createPersonNodeWithCloudCrazeOrder(w, person);
            w.writeEndElement();

        w.writeEndElement();
        w.writeEndDocument();
        
        System.Debug('***************************************');
        System.Debug('In createMessageList : Stream '+w.getXmlString());
        System.Debug('***************************************');
        
        return w.getXmlString();
    }
    
    public static void createPersonNodeWithCloudCrazeOrder(XMLStreamWriter w, KapGetRealPersonVO person) {
        
        System.Debug('***************************************');
        System.Debug('In createPersonNode: PersonFirstName : '+person.f_name);
        System.Debug('***************************************');
        
        w.writeStartElement('', 'person', '');
            if(person.student_id != null)
                w.writeAttribute('', '', 'uid', person.student_id);
            addTextElement(w,'f_name',KapUtil.handleNullString(person.f_name));
            addTextElement(w,'l_name',KapUtil.handleNullString(person.l_name));
            if(person.student_id == null){
                addTextElement(w,'entry_date',KapUtil.handleNullString(person.entry_date));

                if (person.addressList != null && person.addressList.size() > 0) {
                    createAddressList(w, person);
                }
                if (person.phoneList != null && person.phoneList.size() > 0) {
                    createPhoneList(w, person);
                }
                
                System.debug(LoggingLevel.INFO,'Roster Email List'+person.emailList);
                if (person.emailList != null && person.emailList.size() > 0) {
                    createEmailList(w, person);
                }
                
                //Roster Changes
                System.debug(LoggingLevel.INFO,'Roster Exclusion List'+person.exclusionList);
                if (person.exclusionList != null && person.exclusionList.size() > 0) {
                    createExclusionList(w, person);
                }

                if(person.cloudCrazeOrder != null) {
                    createleadList(w, person);
                }               
                //Roster Changes
                System.debug(LoggingLevel.INFO, '$$Roster person.grad_year=' + person.grad_year);
                if((person.subordinateUID != null)  || (person.grad_year != null)) {
                    System.debug('The value of School Id is::'+person.subordinateUID);
                    System.debug('The value of Grad year is::'+person.grad_year);
                    createAccountabilityList(w, person);
                }
                
                /* NOT NEEDED
                if (person.intlInfoList.size() > 0) {
                    createInternationalInfoNode(w, person);
                }
                */
            }
            if(person.cloudCrazeOrder != null){
                createCloudCrazeOrderNode(w, person);
            }       
        w.writeEndElement();
    }

    public static void createCloudCrazeOrderNode(XMLStreamWriter w, KapGetRealPersonVO person) {
        w.writeStartElement('', 'order', '');
            if(person.cloudCrazeOrder.paymentMethodList.size() > 0){
                w.writeStartElement('', 'paymethod_list', '');
                    for(KapGetRealPaymentMethodVO payMethodVO : person.cloudCrazeOrder.paymentMethodList){
                        w.writeStartElement('', 'paymethod', '');
                            addTextElement(w,'index',String.valueOf(payMethodVO.index));
                            w.writeStartElement('', 'creditcard', '');
                                addTextElement(w,'subscription_id',KapUtil.handleNullString(payMethodVO.cc_subscriptionId));
                                addTextElement(w,'masked_number',KapUtil.handleNullString(payMethodVO.cc_maskedNumber));
                                addTextElement(w,'card_type',KapUtil.handleNullString(payMethodVO.cc_type));
                                if(payMethodVO.cc_billingAddress != null){
                                    w.writeStartElement('', 'billing_address', '');
                                        w.writeStartElement('', 'address', '');
                                            addTextElement(w,'type',KapUtil.handleNullString(payMethodVO.cc_billingAddress.addr_type));
                                            addTextElement(w,'line_1',KapUtil.handleNullString(payMethodVO.cc_billingAddress.line_1));
                                            addTextElement(w,'line_2',KapUtil.handleNullString(payMethodVO.cc_billingAddress.line_2));
                                            addTextElement(w,'line_3',KapUtil.handleNullString(payMethodVO.cc_billingAddress.line_3));
                                            addTextElement(w,'city',KapUtil.handleNullString(payMethodVO.cc_billingAddress.city));
                                            addTextElement(w,'state',KapUtil.handleNullString(payMethodVO.cc_billingAddress.state));
                                            addTextElement(w,'postal_code',KapUtil.handleNullString(payMethodVO.cc_billingAddress.postal_code));
                                            addTextElement(w,'country',KapUtil.handleNullString(payMethodVO.cc_billingAddress.country));
                                        w.writeEndElement();
                                    w.writeEndElement();
                                }
                            w.writeEndElement();
                        w.writeEndElement();
                    }
                w.writeEndElement();
            }
            w.writeStartElement('', 'item_list', '');
                for(KapGetRealCCOrderItemVO itemVO : person.cloudCrazeOrder.itemList){
                    w.writeStartElement('', itemVO.deliveryType, '');
                        w.writeAttribute('', '', 'client_sys_id', itemVO.client_sys_id);
                        addTextElement(w,'id',KapUtil.handleNullString(itemVO.classId));
                        addTextElement(w,'code',KapUtil.handleNullString(itemVO.productCode));
                        
                        // No other items are needed if it is a center-based on live online marketing event
                        if(itemVO.deliveryType != null && itemVO.deliveryType != 'event_item') {
                            addTextElement(w,'study_center',KapUtil.handleNullString(itemVO.studyCenter));
                            System.debug(LoggingLevel.INFO,'lKapGetRealUtil - flexdate --' + itemVO.startDate);
                            addTextElement(w,'start_date',KapUtil.handleNullString(itemVO.startDate));
                            System.debug(LoggingLevel.INFO,'lKapGetRealUtil - flexEndDate --' + itemVO.endDate);
                            addTextElement(w,'expiration_date',KapUtil.handleNullString(itemVO.endDate));

                            //SFI-1269 - Get Real Update 
                            //Roster Changes
                            //addTextElement(w, 'channel', '20');
                            addTextElement(w, 'channel', String.valueOf(itemVO.channel == null ? 20 : itemVO.channel));
                            addTextElement(w,'transaction_code',KapUtil.handleNullString(itemVO.transactionCode));
                            addTextElement(w,'base_price',KapUtil.handleNullString(String.valueOf(itemVO.basePrice)));
                            w.writeStartElement('', 'discount', '');
                                addTextElement(w, 'code', KapUtil.handleNullString(itemVO.discountCode));
                                addTextElement(w, 'amount', String.valueOf(itemVO.discountAmount == null ? 0.0 : itemVO.discountAmount));
                            w.writeEndElement();
                            if(itemVO.shippingMethod != null){
                                w.writeStartElement('', 'shipping', '');
                                    addTextElement(w,'method',KapUtil.handleNullString(itemVO.shippingMethod.method));
                                    addTextElement(w,'fee',KapUtil.handleNullString(String.valueOf(itemVO.shippingMethod.fee)));
                                    if(itemVO.shippingMethod.shippingAddress != null){
                                        w.writeStartElement('', 'shipto', '');
                                            w.writeStartElement('', 'address', '');
                                                addTextElement(w,'type',KapUtil.handleNullString(itemVO.shippingMethod.shippingAddress.addr_type));
                                                addTextElement(w,'line_1',KapUtil.handleNullString(itemVO.shippingMethod.shippingAddress.line_1));
                                                addTextElement(w,'line_2',KapUtil.handleNullString(itemVO.shippingMethod.shippingAddress.line_2));
                                                addTextElement(w,'line_3',KapUtil.handleNullString(itemVO.shippingMethod.shippingAddress.line_3));
                                                addTextElement(w,'city',KapUtil.handleNullString(itemVO.shippingMethod.shippingAddress.city));
                                                addTextElement(w,'state',KapUtil.handleNullString(itemVO.shippingMethod.shippingAddress.state));
                                                addTextElement(w,'postal_code',KapUtil.handleNullString(itemVO.shippingMethod.shippingAddress.postal_code));
                                                addTextElement(w,'country',KapUtil.handleNullString(itemVO.shippingMethod.shippingAddress.country));                                            
                                            w.writeEndElement();
                                        w.writeEndElement();
                                    }
                                w.writeEndElement();
                            }
                            if(itemVO.payments.size() > 0){
                                w.writeStartElement('', 'payment_list', '');
                                    for(KapGetRealPaymentVO paymentVO : itemVO.payments){
                                        w.writeStartElement('', 'payment', '');
                                            addTextElement(w,'index',String.valueOf(paymentVO.index));
                                            addTextElement(w,'paymethod_index',String.valueOf(paymentVO.payMethodIndex));
                                            addTextElement(w,'amount',String.valueOf(paymentVO.amount));
                                            addTextElement(w,'cc_auth_code',KapUtil.handleNullString(paymentVO.cc_authCode));
                                            addTextElement(w,'cc_settlement_date',KapUtil.handleNullString(paymentVO.cc_settlmentDate));
                                        w.writeEndElement();
                                    }
                                w.writeEndElement();
                            }
                            if(itemVO.installmentsRemaining > 0){
                                w.writeStartElement('', 'installments', '');
                                    addTextElement(w,'paymethod_index','0');
                                    addTextElement(w,'balance', String.valueOf(itemVO.balanceRemaining));
                                    addTextElement(w,'remaining_installments',String.valueOf(itemVO.installmentsRemaining));
                                w.writeEndElement();
                            }
                        }
                    w.writeEndElement();
                }
            w.writeEndElement();
        w.writeEndElement();
    }
    /********************************************************
    END
    Kaplan Test Prep Iron Cloud Project
    *********************************************************/
}