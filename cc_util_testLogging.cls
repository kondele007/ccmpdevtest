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
private class cc_util_testLogging {

   private static String CLASSNAME = 'CloudCrazeUtils';
    private static String transactionLog = ''; 
    static testMethod void unitTestDebugLog() {
    	cc_util_logging.debug('test');
    	System.assertEquals(cc_util_logging.getDebugLog(), 'test');
    	cc_util_logging.resetDebugLog();
    	System.assertEquals(cc_util_logging.getDebugLog(), '');
    }
    static testMethod void unitTest() {
		String txtReturn = cc_util_logging.SUCCESS;
        String txStatus = cc_util_logging.SUCCESS;
        String methodName = 'unitTest ';
        
		List<E_ApplicationSettings__c> apps = [Select c.Id From E_ApplicationSettings__c c where name='CloudCraze'];
        delete apps;
        apps = new List<E_ApplicationSettings__c>();
        apps.add(new E_ApplicationSettings__c(Name='CloudCraze', LOG_Y_N__c='Y'));
        insert apps;
        System.assert([Select c.Id From E_ApplicationSettings__c c where name='CloudCraze'].size() != 0); 
        integer test = 0;
        try
        {
        	test = 1/0;
        }
        catch(Exception e)
        {
        	String exceptionMessage = cc_util_logging.constructExceptionMessageString(e);   
            cc_util_logging.createException(CLASSNAME + '.' + methodName, e.getTypeName(), exceptionMessage);
            txStatus = cc_util_logging.FAILED;
            txtReturn = e.getMessage();
            transactionLog = cc_util_logging.log(transactionLog, methodName + '\n\n >>> ERROR =' + e.getStackTraceString() + '\n\n');
        }
        
        try
        {
        	test = 1/0;
        }
        catch(Exception e)
        {
        	String exceptionMessage = cc_util_logging.constructExceptionMessageString(e);   
            cc_util_logging.createException(CLASSNAME + '.' + methodName, e.getTypeName(), exceptionMessage, null, null);
            txStatus = cc_util_logging.FAILED;
            txtReturn = e.getMessage();
            transactionLog = cc_util_logging.log(transactionLog, methodName + '\n\n >>> ERROR =' + e.getStackTraceString() + '\n\n');
        }
        
        try
        {
        	test = 1/0;
        }
        catch(Exception e)
        {
        	String exceptionMessage = cc_util_logging.constructExceptionMessageString(e);   
            cc_util_logging.createExceptionWithoutFuture(CLASSNAME + '.' + methodName, e.getTypeName(), exceptionMessage, null, null);
            txStatus = cc_util_logging.FAILED;
            txtReturn = e.getMessage();
            transactionLog = cc_util_logging.log(transactionLog, methodName + '\n\n >>> ERROR =' + e.getStackTraceString() + '\n\n');
        }
        
        try
        {
        	test = 1/0;
        }
        catch(Exception e)
        {
        	String exceptionMessage = cc_util_logging.constructExceptionMessageString(e);   
            cc_util_logging.createExceptionWithoutFuture(CLASSNAME + '.' + methodName, e.getTypeName(), exceptionMessage);
            txStatus = cc_util_logging.FAILED;
            txtReturn = e.getMessage();
            transactionLog = cc_util_logging.log(transactionLog, methodName + '\n\n >>> ERROR =' + e.getStackTraceString() + '\n\n');
        }
        finally
        {
        	transactionLog = cc_util_logging.log(transactionLog, 'End ' + methodName + ' Method');
            cc_util_logging.addToCCLog(CLASSNAME, methodName, '', '', txStatus, transactionLog);
            System.debug('\n TransactionLog =' + transactionLog);
        }
	}
}