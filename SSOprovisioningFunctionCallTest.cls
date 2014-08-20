@isTest
public class SSOprovisioningFunctionCallTest{
//Ensure Accountability Id is Unique..  

static testMethod void testPkcChildStudent(){
SSOprovisioningFunctionCall.details variableclass=new SSOprovisioningFunctionCall.details(); 

//Child-Student
variableclass.StudentId=1235080999;
variableclass.kaptestUserId='Test96788986';
variableclass.email='kalptv1@kaplan.com';
variableclass.firstName='kalptv1';
variableclass.lastName='anatv1';
variableclass.abaNumber='CHILD_01';
 variableclass.amaNumber='';
 variableclass.billingAddressLine1='395 HUDSON';
 variableclass.billingAddressLine2='APT 2';
 variableclass.billingCity='HACK';
 variableclass.billingState='NJ';
 variableclass.billingZip='07601';
 variableclass.billingCountry='USA';
 variableclass.billingFirstName='testbillingKALPtv1';
 variableclass.billingLastName='testbillingLastANAtv1';
 variableclass.billingPhone='21233535';
 variableclass.accountabilityId='126666689';
 variableclass.shippingAddressLine1='395 Hudson';
 variableclass.shippingAddressLine2='apt2';
 variableclass.shippingCity='NYC';
 variableclass.shippingState='NY';
 variableclass.shippingFirstName='testshipfirstkalptv1';
 variableclass.shippingLastName='testshiplastanatv1';
 variableclass.shippingZip='10024';
 variableclass.shippingCountry='USA';
 variableclass.shippingPhone='21345356';
 variableclass.schoolId='1234586889';
 variableclass.schoolName='testvigtv1';
 variableclass.schoolState='NY';
 variableclass.graduationYear='2013';
 variableclass.preCollegeProgramSelected=true;
 variableclass.medicalProgramSelected=false;
 variableclass.relationshipId='5879999943';
variableclass.parentlastName='babtv1';
 variableclass.parentfirstName='ramtv1';
 variableclass.parentStudentId='';
 variableclass.parentKaptestUserId='DEV120999990227';
  variableclass.ParentEmail='Pamtv1@KAPLAN.COM';
 variableclass.PersonEmail='Pabutv1@KAPLAN.COM';
 variableclass.defaultProfileId='00eC0000001fHjd';
 variableclass.defaultLocale='en_US';
 variableclass.defaultEncoding='UTF-8';
 variableclass.defaultSource='WEB';
 variableclass.defaultTimeZone='America/New_York';
 variableclass.defaultaccountgroup='a0KC0000008Wlfh';
 
Kaplan_Custom_Config__c kap_config= new Kaplan_Custom_Config__c();
kap_config.Name = 'Kaplan Custom Config';
kap_config.ETL_Load_Username__c='ktpdatawarehousenonprodsupport@kaplan.com.commerce';
Insert kap_config;
  Account Acc= new Account(); 
    Acc.lastname='Testkpv1';
    Acc.FirstName='TestFkpv1';
    Acc.Kaptest_User_Id__c='Test96788986';
    Acc.Student_ID__c=1235080999;
    insert acc;
 E_ContactAddr__c Econ=new E_ContactAddr__c();
  Econ.AddressFirstline__c='395 Hudson';
 Econ.ContactAddrId__c='34623';
    Econ.Email__c='test1@test.com';
    Econ.City__c='Hack';
    Econ.FirstName__c='TestK1';
    Econ.LastName__c='TestL1';
    Econ.State__c='NJ';
    
    insert Econ;
  E_AddressBook__c EAddBook= new E_AddressBook__c();
    EAddBook.Account__c=Acc.id;
    EAddBook.E_ContactAddress__c=Econ.id;
    insert EAddBook;
SSOprovisioningFunctionCall.executeAccountUserProvisioning(variableclass);
  List<Account> a = [select Student_ID__c from Account where Student_ID__c= 1235080999];
  System.assertEquals(a.size(), 1);
}

static testMethod void testMyWebSvcPkcParent(){
SSOprovisioningFunctionCall.details variableclass=new SSOprovisioningFunctionCall.details(); 
//PARENT
//variableclass.studentId=1501545008;
variableclass.kaptestUserId='Test967399399';
variableclass.email='Testsaittest3@kaplan.com';
variableclass.firstName='testtkap';
variableclass.lastName='testttprep';
variableclass.abaNumber='PARENTT01';
 variableclass.amaNumber='';
 variableclass.billingAddressLine1='395 HUDSON';
 variableclass.billingAddressLine2='APT 2';
 variableclass.billingCity='HACK';
 variableclass.billingState='NJ';
 variableclass.billingZip='07601';
 variableclass.billingCountry='USA';
 variableclass.billingFirstName='testbillingFirstpkaptest';
 variableclass.billingLastName='testbillingLastppreptest';
 variableclass.billingPhone='21233535';
 variableclass.accountabilityId='126870';
 
 variableclass.shippingAddressLine1='395 Hudson';
 variableclass.shippingAddressLine2='apt2';
 variableclass.shippingCity='NYC';
 variableclass.shippingState='NY';
 variableclass.shippingFirstName='testshipfirstpKapnametest';
 variableclass.shippingLastName='testshiplastpKapnametest';
 variableclass.shippingZip='10024';
 variableclass.shippingCountry='USA';
 variableclass.shippingPhone='21345356';
 
 
 variableclass.schoolId='123488889';
 variableclass.schoolName='testschoolnamePktest';
 variableclass.schoolState='NY';
 variableclass.graduationYear='2013';
 variableclass.preCollegeProgramSelected=true;
 variableclass.medicalProgramSelected=true;
 variableclass.childEmail='testpkapspkchild1@email.com';
 variableclass.childlastName='Pkaptchild';
 variableclass.childfirstName='testprepkChild';
 variableclass.childStudentId='1916600466';
 variableclass.childKaptestUserId='DEV120999027';
 variableclass.PersonEmail='Ptestemailktesttwo@KAPLAN.COM';
 variableclass.relationshipId='589999943';
 variableclass.defaultProfileId='00eC0000001fHjd';
 variableclass.defaultLocale='en_US';
 variableclass.defaultEncoding='UTF-8';
 variableclass.defaultSource='WEB';
 variableclass.defaultTimeZone='America/New_York';
 variableclass.defaultaccountgroup='a0KC0000008Wlfh';
 variableclass.parentStudentId='87663244';  
 Kaplan_Custom_Config__c kap_config= new Kaplan_Custom_Config__c();
 kap_config.Name = 'Kaplan Custom Config';
 kap_config.ETL_Load_Username__c='ktpdatawarehousenonprodsupport@kaplan.com.commerce';
 Insert kap_config;
SSOprovisioningFunctionCall.executeAccountUserProvisioning(variableclass);
  List<Account> a = [select Student_ID__c from Account where Student_ID__c= 1916600466];
  System.assertEquals(a.size(), 1);
}
static testMethod void testMyWebSvcRegular(){
SSOprovisioningFunctionCall.details variableclass=new SSOprovisioningFunctionCall.details(); 
variableclass.email='Testemailkotptestone@kaplan.com';
variableclass.firstName='testfirstkpnametest';
variableclass.lastName='testlastkpnametest';
variableclass.abaNumber='123466';
 variableclass.amaNumber='2345';
     variableclass.billingFirstName='testfirstkpnametest';
     variableclass.billingLastName='testlastkpnametest';
     variableclass.billingAddressLine1='395 HUDSON';
     variableclass.billingAddressLine2='APT 2';
     variableclass.billingCity='NYC';
     variableclass.billingState='NY';
     variableclass.billingZip='07601';
     variableclass.billingCountry='USA';
     variableclass.accountabilityId='123';
     variableclass.billingPhone='21233535';
     variableclass.shippingFirstName='testfirstkpnametest';
     variableclass.shippingLastName='testlastkpnametest';
     variableclass.shippingAddressLine1='395 Hudson';
     variableclass.shippingAddressLine2='apt2';
     variableclass.shippingCity='NYC';
     variableclass.shippingState='NY';
     variableclass.shippingZip='10024';
     variableclass.shippingCountry='USA';
     variableclass.shippingPhone='21345356';
     variableclass.schoolId='123466789';
     variableclass.schoolName='testschoolkpnametest';
     variableclass.schoolState='NY';
     variableclass.graduationYear='2013';
     variableclass.studentId=12220012;
     variableclass.kaptestUserId='120000027109';
     variableclass.preCollegeProgramSelected=false;
     variableclass.childEmail=null;
    // variableclass.parentEmail='parentkpemail@kaplan.com';
     variableclass.parentLastName='Name';
     variableclass.parentFirstName='testParent';
     //variableclass.relationshipId='58967643';
     variableclass.childlastName='Namekp';
     variableclass.childfirstName='testkpChild';
     variableclass.childStudentId='121455863';
     variableclass.childKaptestUserId='120390027';
     variableclass.medicalProgramSelected=false;
     variableclass.PersonEmail='Personaemailkotpptestone@KAPLAN.COM';
     variableclass.defaultProfileId='00eC0000001fHjd';
      variableclass.defaultLocale='en_US';
     variableclass.defaultEncoding='UTF-8';
    variableclass.defaultSource='en_US';
    variableclass.defaultTimeZone='America/New_York';
    
    Kaplan_Custom_Config__c kap_config= new Kaplan_Custom_Config__c();
    kap_config.Name = 'Kaplan Custom Config';
    kap_config.ETL_Load_Username__c='ktpdatawarehousenonprodsupport@kaplan.com.commerce';
    Insert kap_config;
    SSOprovisioningFunctionCall.executeAccountUserProvisioning(variableclass);
  List<Account> a = [select Student_ID__c from Account where Student_ID__c= 12220012];
  System.assertEquals(a.size(), 1);
}

/*****
static testMethod void testMyWebSvcParentchildUpdate(){
//Update Test data..

SSOprovisioningFunctionCall.details variableclass=new SSOprovisioningFunctionCall.details(); 
variableclass.kaptestUserId='Test100258';
variableclass.email='ramv1tk1@kaplan.com';
variableclass.firstName='updateramv1tk1';
variableclass.lastName='Updatebabv1tk1';
variableclass.abaNumber='PARENT01';
 variableclass.amaNumber='';
 variableclass.billingAddressLine1='1086 W King';
 variableclass.billingAddressLine2='APT 1';
 variableclass.billingCity='WestChester';
 variableclass.billingState='PA';
 variableclass.billingZip='19355';
 variableclass.billingCountry='USA';
// variableclass.billingFirstName='testbillingramv1tk1';
// variableclass.billingLastName='testbillingLastbabv1tk1';
 variableclass.billingPhone='21233535';
 //variableclass.accountabilityId='12389999';  

 variableclass.shippingAddressLine1='1086 W King';
 /****variableclass.shippingAddressLine2='apt2';
 variableclass.shippingCity='NYC';
 variableclass.shippingState='NY';
 variableclass.shippingFirstName='testshipfirstramv1tk1';
 variableclass.shippingLastName='testshiplastbabv1tk1';
 variableclass.shippingZip='10024';****/
// variableclass.shippingCountry='USA';
 //variableclass.shippingPhone='21345356';uncomment
 
 
// variableclass.schoolId='1234586889';****/
 //variableclass.schoolName='testvigv1tk1U1';uncomment
/*** variableclass.schoolState='NJ';
 variableclass.graduationYear='2013';
**/
 /***uncomment sai
 variableclass.preCollegeProgramSelected=true;
 variableclass.medicalProgramSelected=true;
 variableclass.childEmail='kalpv1tk1@email.com';
 variableclass.relationshipId='539679999';

 variableclass.childlastName='kpulv1tk1';
 variableclass.childfirstName='kalpv1tk1';
 variableclass.childStudentId='12109999';
 variableclass.childKaptestUserId='DEV1120900227';
     
 variableclass.PersonEmail='Pramv1tk1@KAPLAN.COM';
 variableclass.defaultProfileId='00eC0000001fHjd';
 variableclass.defaultLocale='en_US';
 variableclass.defaultEncoding='UTF-8';
 variableclass.defaultSource='WEB';
 variableclass.defaultTimeZone='America/New_York';
 variableclass.defaultaccountgroup='a0KC0000008Wlfh'; 
 
  Kaplan_Custom_Config__c kap_config= new Kaplan_Custom_Config__c();
    kap_config.Name = 'Kaplan Custom Config';
    kap_config.ETL_Load_Username__c='ktpdatawarehousenonprodsupport@kaplan.com.commerce';
    Insert kap_config;
    SSOprovisioningFunctionCall.executeAccountUserProvisioning(variableclass);  uncomment**/
 // List<Account> a = [select Student_ID__c from Account where Student_ID__c= 12220012];
 // System.assertEquals(a.size(), 1);
 
 //}***/

}