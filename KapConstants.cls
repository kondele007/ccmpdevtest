/******************************************************************************
** Module Name   : KapConstants
** Description   : This class holds contstants that are referenced in other
**                 classes. Provides a common area for setting constants.
** 
** Technial Info : <Classes, Methods, etc>
** 
** Author(s)     : George Koodarappally (GK) - Acumen Solutions
** Revision History:-
** Version  Date        Author  Description of Action
** 1.0      03/01/2011  GK      Initiated Script
******************************************************************************/

public with sharing class KapConstants {
    public static final String KAP_RELATIONSHIP_ACCOUNT_RECORD_TYPE_NAME = 'Related Person Account';

    public static final String KAP_SFDC_ACCOUNT_ID_PREFIX = '001';
    public static final String KAP_SFDC_CASE_ID_PREFIX = '500';
    
    /*
    ** Constants used in the KapEngine Integration Code
    */
    public static final String KAP_KAPENGINE_URL = 'https://api.kaplan.com/ke/3.0/';

    public static final String KAP_KAPENGINE_ENROLLMENT_URL = 'enrollment/';
    public static final String KAP_KAPENGINE_PROD_ENROLLMENT_URL = 'productenrollment/';
    public static final String KAP_KAPENGINE_CLASS_ENROLLMENT_URL = 'classenrollment/';
    public static final String KAP_KAPENGINE_EVENT_ENROLLMENT_URL = 'eventenrollment/';
    
    public static final String KAP_KAPENGINE_TRANSACTION_URL = 'dkTransactions/';
    public static final String KAP_KAPENGINE_SHIP_ORDER_URL = 'shiporders/';

    public static final String KAP_ENROLLMENT_NODE_NAME = 'enrollment';
    public static final String KAP_PROD_ENROLLMENT_NODE_NAME = 'productEnrollment';
    public static final String KAP_CLASS_ENROLLMENT_NODE_NAME = 'classEnrollment';
    public static final String KAP_EVENT_ENROLLMENT_NODE_NAME = 'eventEnrollment';
    
    public static final String KAP_TRANSACTIONS_NODE_NAME = 'dkTransactions';
    public static final String KAP_TRANSACTION_NODE_NAME = 'dkTransaction';
    public static final String KAP_SHIP_ORDERS_NODE_NAME = 'shipments';
    public static final String KAP_SHIP_ORDER_NODE_NAME = 'shipment';
    
    
    /*
    ** Constants used in the GetReal Integration Code
    */
    public static final String KAP_GETREAL_USERID = 'userid';
    public static final String KAP_GETREAL_PASSWORD = 'password';
    public static final String KAP_GETREAL_AUTH = KAP_GETREAL_USERID + ':' + KAP_GETREAL_PASSWORD;
    public static final String KAP_GETREAL_URL = 'https://' + KAP_GETREAL_AUTH + '@api.kaplan.com/kbs/getreal/';

    public static final String KAP_GETREAL_PERSON_URL = 'person/2.1/xml';
    
    public static final String KAP_FLD_OBJECT_ID = 'object_id';
    public static final String KAP_FLD_STUDENT_ID = 'id';
    public static final String KAP_FLD_STUDENT_STUDENT_ID = 'student_id__c';
    public static final String KAP_FLD_STUDENT_FIRST_NAME = 'firstname';
    public static final String KAP_FLD_STUDENT_MIDDLE_NAME = 'middle_name__c';
    public static final String KAP_FLD_STUDENT_LAST_NAME = 'lastname';
    public static final String KAP_FLD_STUDENT_CALL_NAME = '';
    public static final String KAP_FLD_STUDENT_GENDER = '';
    public static final String KAP_FLD_STUDENT_BIRTH_DATE = '';
    public static final String KAP_FLD_STUDENT_NATL_DO_NOT_CALL = 'nat_do_not_call_flag__c';
    public static final String KAP_FLD_STUDENT_DO_NOT_CALL = 'do_not_call2__c';
    public static final String KAP_FLD_STUDENT_DO_NOT_EMAIL = 'email_opt_out2__c';
    public static final String KAP_FLD_STUDENT_DO_NOT_MAIL = 'do_not_mail_flag__c';
    public static final String KAP_FLD_STUDENT_DO_NOT_SHARE = 'do_not_share_flag__c';
    public static final String KAP_FLD_STUDENT_MAIL_PREF = '';
    public static final String KAP_FLD_STUDENT_NO_EMAIL_REASON = '';
    public static final String KAP_FLD_STUDENT_BATCH_ID = '';
    public static final String KAP_FLD_STUDENT_ENTRY_DATE = 'entry_date__c';
    
    public static final String KAP_FLD_PERMANENT_ADDRESS_ADDRESS1 = 'billingstreet';
    public static final String KAP_FLD_PERMANENT_ADDRESS_ADDRESS2 = 'permanent_address2__c';
    public static final String KAP_FLD_PERMANENT_ADDRESS_ADDRESS3 = 'permanent_address3__c';
    public static final String KAP_FLD_PERMANENT_ADDRESS_CITY = 'billingcity';
    public static final String KAP_FLD_PERMANENT_ADDRESS_STATE = 'billingstate';
    public static final String KAP_FLD_PERMANENT_ADDRESS_POSTAL_CODE = 'billingpostalcode';
    public static final String KAP_FLD_PERMANENT_ADDRESS_COUNTRY = 'billingcountry';
    public static final String KAP_FLD_PERMANENT_ADDRESS_MAILING_FLAG = 'permanent_mailing_flag__c';

    public static final String KAP_FLD_WORK_ADDRESS_ADDRESS1 = 'shippingstreet';
    public static final String KAP_FLD_WORK_ADDRESS_ADDRESS2 = 'work_address_line2__c';
    public static final String KAP_FLD_WORK_ADDRESS_ADDRESS3 = 'work_address_line3__c';
    public static final String KAP_FLD_WORK_ADDRESS_CITY = 'shippingcity';
    public static final String KAP_FLD_WORK_ADDRESS_STATE = 'shippingstate';
    public static final String KAP_FLD_WORK_ADDRESS_POSTAL_CODE = 'shippingpostalcode';
    public static final String KAP_FLD_WORK_ADDRESS_COUNTRY = 'shippingcountry';
    public static final String KAP_FLD_WORK_ADDRESS_MAILING_FLAG = 'work_mailing_flag__c';
    
    public static final String KAP_FLD_SCHOOL_ADDRESS_ADDRESS1 = 'school_address_line_1__c';
    public static final String KAP_FLD_SCHOOL_ADDRESS_ADDRESS2 = 'school_address_line_2__c';
    public static final String KAP_FLD_SCHOOL_ADDRESS_ADDRESS3 = 'school_address_line_3__c';
    public static final String KAP_FLD_SCHOOL_ADDRESS_CITY = 'school_city__c';
    public static final String KAP_FLD_SCHOOL_ADDRESS_STATE = 'school_state__c';
    public static final String KAP_FLD_SCHOOL_ADDRESS_POSTAL_CODE = 'school_postal_code__c';
    public static final String KAP_FLD_SCHOOL_ADDRESS_COUNTRY = 'school_country__c';
    public static final String KAP_FLD_SCHOOL_ADDRESS_MAILING_FLAG = 'school_mailing_flag__c';
    
    public static final String KAP_FLD_OTHER_ADDRESS_ADDRESS1 = 'other_address_line_1__c';
    public static final String KAP_FLD_OTHER_ADDRESS_ADDRESS2 = 'other_address_line_2__c';
    public static final String KAP_FLD_OTHER_ADDRESS_ADDRESS3 = 'other_address_line_3__c';
    public static final String KAP_FLD_OTHER_ADDRESS_CITY = 'other_city__c';
    public static final String KAP_FLD_OTHER_ADDRESS_STATE = 'other_state__c';
    public static final String KAP_FLD_OTHER_ADDRESS_POSTAL_CODE = 'other_postal_code__c';
    public static final String KAP_FLD_OTHER_ADDRESS_COUNTRY = 'other_country__c';
    public static final String KAP_FLD_OTHER_ADDRESS_MAILING_FLAG = 'other_mailing_flag__c';

    public static final String KAP_FLD_STUDENT_PHONE_1_TYPE = 'phone_1_type__c';
    public static final String KAP_FLD_STUDENT_PHONE_1 = 'phone';
    public static final String KAP_FLD_STUDENT_PHONE_1_EXTENSION = 'phone_1_extension__c';
    public static final String KAP_FLD_STUDENT_PHONE_2_TYPE = 'phone_2_type__c';
    public static final String KAP_FLD_STUDENT_PHONE_2 = 'phone_2__c';
    public static final String KAP_FLD_STUDENT_PHONE_2_EXTENSION = 'phone_2_extension__c';
    public static final String KAP_FLD_STUDENT_PHONE_3_TYPE = 'phone_3_type__c';
    public static final String KAP_FLD_STUDENT_PHONE_3 = 'phone_3__c';
    public static final String KAP_FLD_STUDENT_PHONE_3_EXTENSION = 'phone_3_extension__c';

    public static final String KAP_FLD_STUDENT_EMAIL_1_TYPE = '';
    public static final String KAP_FLD_STUDENT_EMAIL_1 = 'personemail';
    public static final String KAP_FLD_STUDENT_EMAIL_2_TYPE = '';
    public static final String KAP_FLD_STUDENT_EMAIL_2 = 'email_2__c';

    public static final String KAP_FLD_STUDENT_INTL_AGENT = '';
    public static final String KAP_FLD_STUDENT_INTL_BIRTH_COUNTRY = '';
    public static final String KAP_FLD_STUDENT_INTL_COUNTRY = '';
    public static final String KAP_FLD_STUDENT_INTL_IS_F1 = 'f1_flag__c';
    public static final String KAP_FLD_STUDENT_INTL_BACKGROUND = 'educational_background__c';
    public static final String KAP_FLD_STUDENT_INTL_ABA_NUMBER = 'aba_number__c';

    public static final String KAP_FLD_RELATIONSHIP_RELATIONSHIP_ID = 'relationship_id__c';
    public static final String KAP_FLD_RELATIONSHIP_KBS_PARENT_ID = 'legacy_parent_id__c';
    public static final String KAP_FLD_RELATIONSHIP_FIRST_NAME = 'parent_first_name__c';
    public static final String KAP_FLD_RELATIONSHIP_LAST_NAME = 'parent_last_name__c';
    public static final String KAP_FLD_RELATIONSHIP_TYPE = 'relation_type__c';
    public static final String KAP_FLD_RELATIONSHIP_PHONE_1 = 'phone_1__c';
    public static final String KAP_FLD_RELATIONSHIP_PHONE_1_EXTENSION = 'phone_1_extension__c';
    public static final String KAP_FLD_RELATIONSHIP_PHONE_2 = 'phone_2__c';
    public static final String KAP_FLD_RELATIONSHIP_PHONE_2_EXTENSION = 'phone_2_extension__c';
    public static final String KAP_FLD_RELATIONSHIP_EMAIL_1 = 'email_1__c';
    public static final String KAP_FLD_RELATIONSHIP_EMAIL_2 = 'email_2__c';

    public static final String KAP_FLD_INTERACTION_TYPE = 'subject';
    public static final String KAP_FLD_INTERACTION_CONTACT = 'whoid';
    public static final String KAP_FLD_INTERACTION_DATE = 'activitydate';
    public static final String KAP_FLD_INTERACTION_REASON = 'subject';
    public static final String KAP_FLD_INTERACTION_COMMENT = 'description';
    public static final String KAP_FLD_INTERACTION_USER = 'lastmodifiedbyid';
    public static final String KAP_FLD_INTERACTION_NO_INTEREST = '';
    public static final String KAP_FLD_INTERACTION_KBS_USER_ID = 'kbs_user_id__c';
    public static final String KAP_FLD_INTERACTION_LAST_MODIFIED_DATE = 'lastmodifieddate';
    
    public static final String KAP_FLD_CASE_NUMBER = 'casenumber';
    public static final String KAP_FLD_CASE_CLOSED_DATE = 'closeddate';
    public static final String KAP_FLD_CASE_DESCRIPTION = 'description';
    public static final String KAP_FLD_CASE_ORIGIN = 'origin';
    public static final String KAP_FLD_CASE_PRIORITY = 'priority';
    public static final String KAP_FLD_CASE_REASON = 'reason';
    public static final String KAP_FLD_CASE_STATUS = 'status';
    public static final String KAP_FLD_CASE_SUBJECT = 'subject';
    public static final String KAP_FLD_CASE_TYPE = 'type';
    public static final String KAP_FLD_CASE_TYPE_DETAIL = 'type_detail__c';
    public static final String KAP_FLD_CASE_RESOLUTION_TYPE = 'resolution_type__c';
    public static final String KAP_FLD_CASE_PRODUCT = 'product__c';
    public static final String KAP_FLD_CASE_OWNER_TEAM = 'owner_team__c';
    public static final String KAP_FLD_CASE_ONLINE_EXTENSION_DATE = 'online_extension_date__c';
    public static final String KAP_FLD_CASE_ENROLLMENT_ID = 'enrollment_id__c';
    public static final String KAP_FLD_CASE_LAST_MODIFIED_BY = 'lastmodifiedby';
    public static final String KAP_FLD_CASE_LAST_MODIFIED_DATE = 'lastmodifieddate';
    
    /*
    ** Constants decipher GetReal Response Codes
    */
    public static final String KAP_GETREAL_RESPONSE_CODE_25_TEXT = 'Locked by Delta K'; 
    public static final String KAP_GETREAL_RESPONSE_CODE_20_TEXT = 'Waiting'; 
    public static final String KAP_GETREAL_RESPONSE_CODE_10_TEXT = 'Processed'; 
    public static final String KAP_GETREAL_RESPONSE_CODE_5_TEXT = 'Processing'; 
    public static final String KAP_GETREAL_RESPONSE_CODE_0_TEXT = 'Pending'; 
    public static final String KAP_GETREAL_RESPONSE_CODE_NEG_10_TEXT = 'Error'; 
    public static final String KAP_GETREAL_RESPONSE_CODE_NEG_20_TEXT = 'Unresolvable Error'; 
    public static final String KAP_GETREAL_RESPONSE_CODE_NEG_21_TEXT = 'Resolvable Error'; 
    public static final String KAP_GETREAL_RESPONSE_CODE_NEG_30_TEXT = 'Duplicate Student'; 
    public static final String KAP_GETREAL_RESPONSE_CODE_NEG_35_TEXT = 'Duplicate Message'; 
    public static final String KAP_GETREAL_RESPONSE_CODE_NEG_40_TEXT = 'Rejected'; 
    public static final String KAP_GETREAL_RESPONSE_CODE_NEG_50_TEXT = 'Duplicate Enrollment'; 
    public static final String KAP_GETREAL_RESPONSE_CODE_NEG_60_TEXT = 'Duplicate Order'; 
    public static final String KAP_GETREAL_RESPONSE_CODE_NEG_70_TEXT = 'Error Addressed'; 
    public static final String KAP_GETREAL_RESPONSE_CODE_NEG_80_TEXT = 'Unknown'; 
    
    public static final String KAP_GETREAL_RESP_CODE_LOCKED_BY_DELTAK = '25'; 
    public static final String KAP_GETREAL_RESP_CODE_WAITING = '20'; 
    public static final String KAP_GETREAL_RESP_CODE_PROCESSED = '10'; 
    public static final String KAP_GETREAL_RESP_CODE_PROCESSING = '5'; 
    public static final String KAP_GETREAL_RESP_CODE_PENDING = '0'; 
    public static final String KAP_GETREAL_RESP_CODE_ERROR = '-10'; 
    public static final String KAP_GETREAL_RESP_CODE_UNRESOLVABLE_ERROR = '-20'; 
    public static final String KAP_GETREAL_RESP_CODE_RESOLVABLE_ERROR = '-21'; 
    public static final String KAP_GETREAL_RESP_CODE_DUPLICATE_STUDENT = '-30'; 
    public static final String KAP_GETREAL_RESP_CODE_DUPLICATE_MESSAGE = '-35'; 
    public static final String KAP_GETREAL_RESP_CODE_REJECTED = '-40'; 
    public static final String KAP_GETREAL_RESP_CODE_DUPLICATE_ENROLLMENT = '-50'; 
    public static final String KAP_GETREAL_RESP_CODE_DUPLICATE_ORDER = '-60'; 
    public static final String KAP_GETREAL_RESP_CODE_ERROR_ADDRESSED = '-70'; 
    public static final String KAP_GETREAL_RESP_CODE_UNKNOWN = '-80'; 
    
    /*
    ** Constants used in the Case Close VF Page
    */
    /*
    public static final String KAP_TYPE_DETAIL_RESET_PASSWORD = 'Reset Kaptest password';
    public static final String KAP_TYPE_DETAIL_ONLINE_EXTENSION = 'Class extension';
    public static final String KAP_RESOLUTION_TYPE_RESET_PASSWORD = 'Reset password';
    public static final String KAP_RESOLUTION_TYPE_ONLINE_EXTENSION = 'Processed class extension';
    */
    public static final String KAP_TYPE_DETAIL_RESET_PASSWORD = 'Username/password reset';
    public static final String KAP_TYPE_DETAIL_ONLINE_EXTENSION = 'Request an extension';
    public static final String KAP_RESOLUTION_TYPE_RESET_PASSWORD = 'Reset Kaptest password';
    public static final String KAP_RESOLUTION_TYPE_ONLINE_EXTENSION = 'Processed automatic extension';
    
    /*
    ** Constants used in the Self Service Case Creation Web Service
    */
    public static final String KAP_SSCASEWS_CLASS_EXTENSION = 'CLASS_EXTENSION';
    public static final String KAP_SSCASEWS_RESET_PASSWORD = 'RESET_PASSWORD';
        
    public static final String KAP_SSCASEWS_CASE_TYPE_CLASS_EXTENSION = 'Change of plans';
    public static final String KAP_SSCASEWS_CASE_TYPE_DETAIL_CLASS_EXTENSION = 'Request an extension';
    //public static final String KAP_SSCASEWS_RESOLUTION_TYPE_DETAIL_CLASS_EXTENSION = 'Processed automatic extension';
    public static final String KAP_SSCASEWS_RESOLUTION_TYPE_DETAIL_CLASS_EXTENSION = 'Processed automatic extension 28 days or less';
    
    public static final String KAP_SSCASEWS_CASE_TYPE_PASSWORD_RESET = 'My online resources';
    public static final String KAP_SSCASEWS_CASE_TYPE_DETAIL_PASSWORD_RESET = 'Username/password reset';
    public static final String KAP_SSCASEWS_RESOLUTION_TYPE_PASSWORD_RESET = 'Reset Kaptest password';

    public static final String KAP_SSCASEWS_ERR_UNSUPPORTED_TRANSACTION = 'This transaction is not supported. Please recheck Case Type and Type Detail.';
    public static final String KAP_SSCASEWS_ERR_MISSING_STUDENT_ID = 'Missing Student Id.';
    public static final String KAP_SSCASEWS_ERR_MISSING_ENROLLMENT_ID = 'Missing Enrollment Id.';
    public static final String KAP_SSCASEWS_ERR_MISSING_PRODUCT_LINE = 'Missing Product Line.';
    public static final String KAP_SSCASEWS_ERR_MISSING_CASE_TYPE = 'Missing Case Type.';
    public static final String KAP_SSCASEWS_ERR_MISSING_CASE_TYPE_DETAIL = 'Missing Case Type Detail.';
    public static final String KAP_SSCASEWS_ERR_MISSING_STATUS = 'Missing Status.';
    public static final String KAP_SSCASEWS_ERR_MISSING_ONLINE_EXTENSION_DATE = 'Missing Online Extension Date.';
    public static final String KAP_SSCASEWS_ERR_INVALID_ENROLLMENT_ID = 'Invalid Enrollment Id. Unable to locate Enrollment record for that Id.';
    public static final String KAP_SSCASEWS_ERR_INVALID_STUDENT_ID = 'Invalid Student Id. Unable to locate Student record for that Id.';
    public static final String KAP_SSCASEWS_ERR_NO_SUCH_QUEUE = 'There is no case queue with the given queue name.';
    
    public static final String KAP_SSCASEWS_SELF_SERVICE_QUEUE_NAME = 'Self Service Queue';
    //public static final String KAP_SSCASEWS_SELF_SERVICE_QUEUE_NAME = 'Customer Support Queue';   
    /*
    public static final String KAP_FLD_WORK_ADDRESS_XX = '';
    */
    

}