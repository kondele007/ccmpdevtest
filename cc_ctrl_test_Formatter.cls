/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class cc_ctrl_test_Formatter {

    static testMethod void testGetFormatted() {
        cc_ctrl_Formatter controller = new cc_ctrl_Formatter();
        controller.num = '123.45';
        E_LocaleFormatter__c ans = controller.getFormatted();
        System.assertEquals(123.45,ans.Currency__c);
    }
    
    static testMethod void testGetFormattedNull(){
        cc_ctrl_Formatter controller = new cc_ctrl_Formatter();
        E_LocaleFormatter__c ans = controller.getFormatted();
        System.assertEquals(0.0,ans.Currency__c);	
    }
    
    static testMethod void testGetFormattedCommas(){
    	cc_ctrl_Formatter controller = new cc_ctrl_Formatter();
        controller.num = '12456.78';
        E_LocaleFormatter__c ans = controller.getFormatted();
        System.assertEquals(12456.78,ans.Currency__c);
    }
}