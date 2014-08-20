@isTest
private class kapUpdPrgramOfIntrstOnAccount_BIBU_Test {

    public static testMethod void InsertnupdateAccnt(){
    // Perform our data preparation.
        Kaplan_Custom_Config__c customSettingRec = new Kaplan_Custom_Config__c(Name='Kaplan Custom Config',ETL_Load_Username__c='ktpdatawarehousenonprodsupport@kaplan.com.commerce');
        insert customSettingRec;
        Account accnt= new Account(Name = 'Test Account',programs_of_interest__c='GMAT');
        insert accnt; 
        test.starttest();
        Account Accntupd=[Select id,programs_of_interest__c from account where Id=:accnt.id];
        Accntupd.programs_of_interest__c='GRE';
        update Accntupd;
        test.stoptest();

    }

}