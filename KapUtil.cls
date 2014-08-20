/******************************************************************************
** Module Name   : KapUtil
** Description   : Utility class containg common methods to be used in other classes
** 
** Technial Info : <Classes, Methods, etc>
** 
** Author(s)     : George Koodarappally (GK) - Acumen Solutions
** Revision History:-
** Version  Date        Author  Description of Action
** 1.0      03/01/2011  GK      Initiated Script
******************************************************************************/

public with sharing class KapUtil {
    
    public static Id getNextTicketId(Id user_id) {
        Map<String,Id> queueMap = new Map<String,Id>();
        List<Id> queueIds = new List<Id>();
        List<String> queueNames = new List<String>();
        GroupMember[] memberOfQueues;
        Group[] userQueues;
        Queue_Detail__c[] queuePriorities;
        
        //Get List of Queues for User
        try {
            memberOfQueues = [SELECT GroupId FROM GroupMember WHERE UserOrGroupId = :user_id];
            
            for (GroupMember moq: memberOfQueues) {
                queueIds.add(moq.GroupId);
            }
        } catch (Exception ex) {
            System.debug(ex);
            throw new KapException('User is not a member of any Queues.',ex);
        }

        try {
            userQueues = [SELECT Id, Name FROM Group WHERE Type = 'Queue' 
                                        AND Id IN :queueIds];
            System.debug(userQueues);
            
            for (Group uq: userQueues) {
                queueMap.put(uq.Name, uq.Id);
                queueNames.add(uq.Name);
            }
            
            System.debug(queueMap);
            System.debug(queueNames);
        } catch (Exception ex) {
            System.debug(ex);
            throw new KapException('Unable to retrieve User\'s Queue(s).',ex);
        }
                                    
                                    
        //Get Queue Priorities from List of Queues order by Descending Priority
        try {
            queuePriorities = [SELECT Name, Priority__c FROM Queue_Detail__c 
                                        WHERE Name IN :queueNames ORDER BY Priority__c DESC ];
            
            System.debug(queuePriorities);
        } catch (Exception ex) {
            System.debug(ex);
            throw new KapException('Unable to retrieve Queue Priority for this User\'s Queue(s).',ex);
        }
        
        //Get Oldest Ticket in Queue that is unasssigned
        for (Queue_Detail__c qd: queuePriorities) {
            Id queueId = queueMap.get(qd.Name);
            System.debug(queueId);
            
            try {
                //Case[] oldestTicket = [SELECT Id FROM Case WHERE OwnerId = :queueId AND Status IN ('Pending','Unresolved') ORDER BY LastModifiedDate ASC];
                Case[] oldestTicket = [SELECT Id FROM Case WHERE OwnerId = :queueId AND Status NOT IN ('Closed') ORDER BY LastModifiedDate ASC];
                System.debug(oldestTicket);
                
                If (oldestTicket.size() > 0) {
                    return oldestTicket[0].Id;
                } 
                /* Comment Code below after testing */
                /*else {
                    oldestTicket = [SELECT Id FROM Case ORDER BY LastModifiedDate ASC];
                    return oldestTicket[0].Id;
                }*/
                /* Comment Code above after testing */
                    
            } catch (Exception ex) {
                System.debug(ex);
                throw new KapException('Unable to retrieve Case for this User.',ex);
            }
        }
        
        return null;
    }
    
    public static void assignTicketToUser(Id case_id, Id user_id) {
        try {
            Case assignToCase = [SELECT Id FROM Case WHERE Id = :case_id LIMIT 1];
            assignToCase.OwnerId = user_id;
            if(assignToCase.Missed_Session_or_Test__c!=''){
           // assignToCase.Missed_Session_or_Test__c='null';
            }
            else{assignToCase.Missed_Session_or_Test__c='0';}
            update assignToCase;
        } catch (Exception ex) {
            System.debug(ex);
            throw new KapException('Unable to assign Case to this User.',ex);
        }
    }
    
    public static String getEncryptedKapTestLoginNameForStudent(Id account_id) {
        String login_name, encrypted_login_name;
        
        login_name = [SELECT Kaptest_Username__c FROM Account WHERE Id = :account_id].Kaptest_Username__c;
        if ((login_name != null) && (login_name != ''))
            encrypted_login_name = getEncryptedKapTestLoginName(login_name);
        
        return encrypted_login_name;
    }   
    
    public static String getEncryptedKapTestLoginNameForUser(Id user_id) {
        String login_name, encrypted_login_name;

        login_name = [SELECT Id FROM User WHERE Id = :user_id].Id;
        if ((login_name != null) && (login_name != ''))
            encrypted_login_name = getEncryptedKapTestLoginName(login_name);
        
        return encrypted_login_name ;
    }   

    public static String getEncryptedKapTestLoginName(String login_name) {
        String kaptestLoginName, encryptedKaptestLoginName;
        String kaplanCryptoKeyBase64String, kaplanIVBase64String;
        Blob kaplanCryptoKey, kaplanIVString;
        
        //Key: 16 17 54 D1 B8 E2 A2 B2 94 1B EB 0D C0 BC 24 B1 5F E6 A6 78 80 56 2C 2D 45 A4 0D DD 74 96 80 00
        //kaplanCryptoKeyHexString = '161754D1B8E2A2B2941BEB0DC0BC24B15FE6A67880562C2D45A40DDD74968000';
        //kaplanIVBase64String = 'AAAAAAAAAAAAAAAAAAAAAA==';
        //http://www.kaptest.com/oam_myhome.jhtml?oam=lbFi073VbkSVtPXqItPHBS696kJbTY1bL2a3yQg2fp4%3D
        //lbFi073VbkSVtPXqItPHBS696kJbTY1bL2a3yQg2fp4%3D
        
        //Get List of Queues for User
        try {
            //kaptestLoginName = 'vkatippally@kaplan.com';
            //kaptestLoginName = 'gjkood@yahoo.com';
            kaptestLoginName = login_name;
            //kaptestLoginName = [SELECT Id FROM User WHERE Id = :user_id].Id;
        } catch (Exception ex) {
            System.debug(ex);
            throw new KapException('Unable to retrieve Kaptest Login Nzme for this user.',ex);
        }

        //Get custom configuration values necessary for AES encryption
        try {
            Kaplan_Custom_Config__c kap_config = Kaplan_Custom_Config__c.getValues('Kaplan Custom Config');
            
            kaplanCryptoKeyBase64String = kap_config.Kaplan_AES_Encryption_Key_B64__c;
            kaplanIVBase64String = kap_config.Kaplan_AES_Initialization_Vector_B64__c;
        } catch (Exception ex) {
            System.debug(ex);
            throw new KapException('Unable to retrieve Ksplan custom configuration parameters.',ex);
        }

        try {
            kaplanCryptoKey = EncodingUtil.base64Decode(kaplanCryptoKeyBase64String);
            kaplanIVString = EncodingUtil.base64Decode(kaplanIVBase64String);
            
            Blob data = Blob.valueOf(kaptestLoginName);
            
            Blob encryptedData = Crypto.encrypt('AES256', kaplanCryptoKey, kaplanIVString, data);
            
            String b64EncryptedData = EncodingUtil.base64Encode(encryptedData);
            encryptedKaptestLoginName = EncodingUtil.urlEncode(b64EncryptedData, 'UTF-8');
            
            return encryptedKaptestLoginName;
        } catch (Exception ex) {
            System.debug(ex);
            throw new KapException('Unable to generate encrypted Kaptest Login Name for this User.',ex);
        }
        
        return null;
    }
    
    
    public static String getShipmentTrackingURL(String tracking_no) {
        String upsShipmentTrackingURLPrefix, upsShipmentTrackingURL;
        
        //Working URL: http://wwwapps.ups.com/WebTracking/processInputRequest?sort_by=status&tracknums_displayed=1&TypeOfInquiryNumber=T&loc=en_us&InquiryNumber1=1Z7VX9310313057590&track.x=0&track.y=0
        //Minimal URL: http://wwwapps.ups.com/WebTracking/processInputRequest?TypeOfInquiryNumber=T&InquiryNumber1=1Z7VX9310313057590
        
        //Get custom configuration values necessary for UPS Shipment Tracking
        try {
            Kaplan_Custom_Config__c kap_config = Kaplan_Custom_Config__c.getValues('Kaplan Custom Config');
            
            upsShipmentTrackingURLPrefix = kap_config.UPS_Tracking_URL__c;
        } catch (Exception ex) {
            System.debug(ex);
            throw new KapException('Unable to retrieve Ksplan custom configuration parameters.',ex);
        }
        
        if (tracking_no != null) {
            upsShipmentTrackingURL = upsShipmentTrackingURLPrefix + tracking_no;
            return upsShipmentTrackingURL;
        }

        return null;
    }
    
    /*
    public static boolean isBoolean(String boolean_string) {
        String testString = boolean_string.toLowerCase();
        
        if (    (testString == 'true')
                || (testString == 'yes')
                || (testString == 'y')
                || (testString == '1')
        ) {
            return true;
        } else if ( (testString == 'false')
                || (testString == 'no')
                || (testString == 'n')
                || (testString == '0')
        ) {
            return false;
        } else {
            return null;
        }
    }
    */
    
    
    public static String handleNullString(String inputString) {
        if (inputString == null) {
            return '';
        } else {
            return inputString;
        }
    }
    
    
    public static String truncateSFDCUserNameSuffix(String sfdcUserName) {
        if (sfdcUserName == null) {
            return '';
        } else {
            String kbsUserName = sfdcUserName.split('@')[0];
            return kbsUserName;
        }
    }
    
    
    public static String BooleanStringToIntegerString(String booleanString){
        if ((booleanString != null) && (booleanString != '')) {
            if (booleanString == 'true')
                return '1';
            else
                return '0';
        }
        return '0';
    }
    
/*  
    static testMethod void testPositive_getNextTicketId() {
        // Load Test Data
        // Add 'Test User' to User table
        User testUser = KapTestUtil.createTestUser();
        // Add 'Test Queue' to Queue table
        Group testQueue = KapTestUtil.createTestQueue();
        // Add 'Test User' to 'Test Queue' in GroupMember table
        GroupMember testQueueMember = KapTestUtil.createQueueMember(testQueue.Id, testUser.Id);
        // Add 'Test Queue' to Queue_Detail__c table
        Queue_Detail__c testQueuePriority = KapTestUtil.createQueuePriority();
        // Add 'Test Case' to Case table with owner = 'Test Queue'
        Case testCase = KapTestUtil.createTestCase(testQueue.Id);

        test.startTest();
        
        Id id = getNextTicketId(testUser.Id);
        
        test.stopTest();
    }
    
    static testMethod void testNegative_getNextTicketId_NO_USER() {
        // Load Test Data
        // Add 'Test User' to User table
        //User testUser = KapTestUtil.createTestUser();
        User testUser = new User();
        // Add 'Test Queue' to Queue table
        Group testQueue = KapTestUtil.createTestQueue();
        // Add 'Test User' to 'Test Queue' in GroupMember table
        //GroupMember testQueueMember = KapTestUtil.createQueueMember(testQueue.Id, testUser.Id);
        // Add 'Test Queue' to Queue_Detail__c table
        Queue_Detail__c testQueuePriority = KapTestUtil.createQueuePriority();
        // Add 'Test Case' to Case table with owner = 'Test Queue'
        Case testCase = KapTestUtil.createTestCase(testQueue.Id);

        test.startTest();
        
        Id id = getNextTicketId(testUser.Id);
        
        test.stopTest();
    }
    
    
    static testMethod void testNegative_getNextTicketId_NO_QUEUE_MEMBER() {
        // Load Test Data
        // Add 'Test User' to User table
        User testUser = KapTestUtil.createTestUser();
        // Add 'Test Queue' to Queue table
        Group testQueue = KapTestUtil.createTestQueue();
        // Add 'Test User' to 'Test Queue' in GroupMember table
        GroupMember testQueueMember = KapTestUtil.createQueueMember(testQueue.Id, testUser.Id);
        // Add 'Test Queue' to Queue_Detail__c table
        Queue_Detail__c testQueuePriority = KapTestUtil.createQueuePriority();
        // Add 'Test Case' to Case table with owner = 'Test Queue'
        Case testCase = KapTestUtil.createTestCase(testQueue.Id);

        test.startTest();
        
        Id id = getNextTicketId(testUser.Id);
        
        test.stopTest();
    }
    
    
    static testMethod void testNegative_getNextTicketId_NO_QUEUE() {
        // Load Test Data
        // Add 'Test User' to User table
        User testUser = KapTestUtil.createTestUser();
        // Add 'Test Queue' to Queue table
        Group testQueue = KapTestUtil.createTestQueue();
        // Add 'Test User' to 'Test Queue' in GroupMember table
        GroupMember testQueueMember = KapTestUtil.createQueueMember(testQueue.Id, testUser.Id);
        // Add 'Test Queue' to Queue_Detail__c table
        Queue_Detail__c testQueuePriority = KapTestUtil.createQueuePriority();
        // Add 'Test Case' to Case table with owner = 'Test Queue'
        Case testCase = KapTestUtil.createTestCase(testQueue.Id);

        test.startTest();
        
        Id id = getNextTicketId(testUser.Id);
        
        test.stopTest();
    }
    
    
    static testMethod void testNegative_getNextTicketId_NO_QUEUE_PRIORITY() {
        // Load Test Data
        // Add 'Test User' to User table
        User testUser = KapTestUtil.createTestUser();
        // Add 'Test Queue' to Queue table
        Group testQueue = KapTestUtil.createTestQueue();
        // Add 'Test User' to 'Test Queue' in GroupMember table
        GroupMember testQueueMember = KapTestUtil.createQueueMember(testQueue.Id, testUser.Id);
        // Add 'Test Queue' to Queue_Detail__c table
        //Queue_Detail__c testQueuePriority = KapTestUtil.createQueuePriority();
        // Add 'Test Case' to Case table with owner = 'Test Queue'
        Case testCase = KapTestUtil.createTestCase(testQueue.Id);

        test.startTest();
        
        Id id = getNextTicketId(testUser.Id);
        
        test.stopTest();
    }
    
    static testMethod void testNegative_getNextTicketId_NO_CASE() {
        // Load Test Data
        // Add 'Test User' to User table
        User testUser = KapTestUtil.createTestUser();
        // Add 'Test Queue' to Queue table
        Group testQueue = KapTestUtil.createTestQueue();
        // Add 'Test User' to 'Test Queue' in GroupMember table
        GroupMember testQueueMember = KapTestUtil.createQueueMember(testQueue.Id, testUser.Id);
        // Add 'Test Queue' to Queue_Detail__c table
        Queue_Detail__c testQueuePriority = KapTestUtil.createQueuePriority();
        // Add 'Test Case' to Case table with owner = 'Test Queue'
        //Case testCase = KapTestUtil.createTestCase(testQueue.Id);

        test.startTest();
        
        Id id = getNextTicketId(testUser.Id);
        
        test.stopTest();
    }
    
    
    
    static testMethod void testPositive_assignTicketToUser() {
        // Load Test Data
        // Add 'Test User' to User table
        User testUser = KapTestUtil.createTestUser();
        // Add 'Test Queue' to Queue table
        Group testQueue = KapTestUtil.createTestQueue();
        // Add 'Test User' to 'Test Queue' in GroupMember table
        GroupMember testQueueMember = KapTestUtil.createQueueMember(testQueue.Id, testUser.Id);
        // Add 'Test Queue' to Queue_Detail__c table
        Queue_Detail__c testQueuePriority = KapTestUtil.createQueuePriority();
        // Add 'Test Case' to Case table with owner = 'Test Queue'
        Case testCase = KapTestUtil.createTestCase(testQueue.Id);

        test.startTest();
        
        assignTicketToUser(testCase.Id, testUser.Id);
        
        test.stopTest();
        
    }
    
    static testMethod void testNegative_assignTicketToUser_NO_CASE() {
        // Load Test Data
        // Add 'Test User' to User table
        User testUser = KapTestUtil.createTestUser();
        // Add 'Test Queue' to Queue table
        Group testQueue = KapTestUtil.createTestQueue();
        // Add 'Test User' to 'Test Queue' in GroupMember table
        GroupMember testQueueMember = KapTestUtil.createQueueMember(testQueue.Id, testUser.Id);
        // Add 'Test Queue' to Queue_Detail__c table
        Queue_Detail__c testQueuePriority = KapTestUtil.createQueuePriority();
        // Add 'Test Case' to Case table with owner = 'Test Queue'
        Case testCase = new Case();

        test.startTest();
        
        assignTicketToUser(testCase.Id, testUser.Id);
        
        test.stopTest();
    }
    
    static testMethod void testNegative_assignTicketToUser_NO_USER() {
        // Load Test Data
        // Add 'Test User' to User table
        User testUser = new User();
        // Add 'Test Queue' to Queue table
        Group testQueue = KapTestUtil.createTestQueue();
        // Add 'Test User' to 'Test Queue' in GroupMember table
        //GroupMember testQueueMember = KapTestUtil.createQueueMember(testQueue.Id, testUser.Id);
        // Add 'Test Queue' to Queue_Detail__c table
        //Queue_Detail__c testQueuePriority = KapTestUtil.createQueuePriority();
        // Add 'Test Case' to Case table with owner = 'Test Queue'
        Case testCase = KapTestUtil.createTestCase(testQueue.Id);

        test.startTest();
        
        assignTicketToUser(testCase.Id, testUser.Id);
        
        test.stopTest();
    }
    
    
    static testMethod void testPositive_getEncryptedKapTestLoginName() {
        // Load Test Data
        // Add 'Test User' to User table
        User testUser = KapTestUtil.createTestUser();

        test.startTest();
        
        getEncryptedKapTestLoginName(testUser.Id);
        
        test.stopTest();
        
    }
    
    
    static testMethod void testNegative_getEncryptedKapTestLoginName_NO_USER() {
        // Load Test Data
        // Add 'Test User' to User table
        User testUser = new User();

        test.startTest();
        
        getEncryptedKapTestLoginName(testUser.Id);
        
        test.stopTest();
    }
    
    
    static testMethod void testPositive_getShipmentTrackingURL() {
        // Load Test Data
        String trackingNo = '123123123123';

        test.startTest();
        
        getShipmentTrackingURL(trackingNo);
        
        test.stopTest();
        
    }
    
    
    static testMethod void testNegative_getShipmentTrackingURL_NO_TRACKING_NUM() {
        // Load Test Data
        String trackingNo = '123123123123';

        test.startTest();
        
        getShipmentTrackingURL(trackingNo);
        
        test.stopTest();
    }
*/    

    
}