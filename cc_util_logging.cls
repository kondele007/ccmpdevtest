public with sharing class cc_util_logging {
	private static string ccDebugLog = '';
	public static final String SUCCESS = 'Success'; 
	public static final String FAILED = 'Failed';
	public static String logSetting = (E_ApplicationSettings__c.getValues('CloudCraze') != null) ? E_ApplicationSettings__c.getValues('CloudCraze').LOG_Y_N__c : 'Y';
	
	public static String logSettingValue =  (logSetting != null && 'Y'.equalsIgnoreCase(logSetting)) ? 'Y' : 'N';
	
	public static String debug(String logMsg) {
		ccDebugLog += logMsg;
		return ccDebugLog;
	}
	public static void resetDebugLog() {
		ccDebugLog = '';
	}
	public static string getDebugLog() {
		return ccDebugLog;
	}
	public static String log(String transactionLog, String s){
	 	System.debug(System.LoggingLevel.Info, s); 
	 	return transactionLog += System.now() + ' ' + s + '\n';
	}

	@future
	public static void addToCCLogFuture(String className, String methodName,
	                            String objectName, String objectId,
	                            String status,
	                            String transactionLog) {
		addToCCLog(className,methodName,
	                            objectName, objectId,
	                            status,
	                            transactionLog);                            	
	}


	public static Id addToCCLog(String className, String methodName,
	                            String objectName, String objectId,
	                            String status,
	                            String transactionLog) {
	    System.debug('>>>transactionLog =' + transactionLog);
	    if('Y'.equalsIgnoreCase(logSettingValue)
	    && transactionLog!=null && transactionLog.length()>0) {

	    	if(status==null || status=='') status='SUCCESS';

			E_Log__c cclog = new E_Log__c();
			cclog.ClassName__c=className;
			cclog.MethodName__c=methodName;
			cclog.ObjectName__c=objectName;
			cclog.ObjectId__c=objectId;
			cclog.LogTime__c=System.now();
			cclog.Status__c=status;
			insert cclog;
		    System.debug('>>>ccLog.Id =' + ccLog.Id);

			String recStr = 'Transaction Log';
			recStr += '\nLogId:' + cclog.Id;
			recStr += '\nLogTime:' + cclog.LogTime__c;
			recStr += '\nClassName:' + cclog.ClassName__c;
			recStr += '\nMethodName:' + cclog.MethodName__c;
			recStr += '\nObjectName:' + cclog.ObjectName__c;
			recStr += '\nObjectId:' + cclog.ObjectId__c;
			recStr += '\n';
			recStr += transactionLog;
		    System.debug('>>>recStr =' + recStr);

			Blob recBlob=Blob.valueOf(recStr);
			Attachment att=new Attachment();
			att.Name='Log Details' + System.now() + '.txt';
			att.ParentId=cclog.Id;
			att.Body=recBlob;
			insert att;

		    System.debug('>>>att.Id =' + att.Id);
			return cclog.Id;
	    }
	    return null;
	}
	/**
	 * Method to create an exception entry in the custom object with the following params
	 * Run as future method so that the db commit doesn't affect the other callouts.
	 * @param: functionPoint - The function point in the code where the exception occurred
	 * @param: exceptionType - The type of exception
	 * @param: exceptionMessage - The detailed exception message.
	 */
    @future
    public static void createException(String functionPoint, String exceptionType, String exceptionMessage) {
		//Create an exception record
		E_Exception__c exceptionInstance = new E_Exception__c();
		exceptionInstance.Function_Point__c = functionPoint;
		exceptionInstance.Exception_Type__c = exceptionType;
		exceptionInstance.Exception_Message__c = exceptionMessage;
		try {
			insert exceptionInstance;
		}
		catch(Exception e) {
			// exception occured while record insertion, notify calling method.
			return;
		}
		//inserted successfully. return true
		return;
	}


	/**
	 * Method to create an exception entry in the custom object with the following params
	 * Run as future method so that the db commit doesn't affect the other callouts.
	 * @param: functionPoint - The function point in the code where the exception occurred
	 * @param: exceptionType - The type of exception
	 * @param: exceptionMessage - The detailed exception message.
	 * @param: iSObject – Sobject field name.
	 * @param: salesforceId – Salesforce Id
	 */
	@future
	public static void createException(String functionPoint, String exceptionType, String exceptionMessage, String iSObject, String salesforceId) {
		//Create an exception record
		E_Exception__c exceptionInstance = new E_Exception__c(
													Function_Point__c = functionPoint,
													Exception_Type__c = exceptionType,
													Exception_Message__c = exceptionMessage,
													SObject__c = iSObject,
													Salesforce_Id__c = salesforceId);

		try {
			insert exceptionInstance;
		} catch(Exception e) {
			return;
		}
		return;
	}


	/**
	 * Method to create an exception entry in the custom object with the following params
	 * Run as future method so that the db commit doesn't affect the other callouts.
	 * @param: functionPoint - The function point in the code where the exception occurred
	 * @param: exceptionType - The type of exception
	 * @param: exceptionMessage - The detailed exception message.
	 */
	public static void createExceptionWithoutFuture(String functionPoint, String exceptionType, String exceptionMessage) {
		//Create an exception record
		E_Exception__c exceptionInstance = new E_Exception__c();
		exceptionInstance.Function_Point__c = functionPoint;
		exceptionInstance.Exception_Type__c = exceptionType;
		exceptionInstance.Exception_Message__c = exceptionMessage;
		try {
			insert exceptionInstance;
		} catch(Exception e) {
			// exception occured while record insertion, notify calling method.
			return;
		}
		//inserted successfully. return true
		return;
	}


	/**
	 * Method to create an exception entry in the custom object with the following params
	 * Run as future method so that the db commit doesn't affect the other callouts.
	 * @param: functionPoint - The function point in the code where the exception occurred
	 * @param: exceptionType - The type of exception
	 * @param: exceptionMessage - The detailed exception message.
	 * @param: iSObject – Sobject field name.
	 * @param: salesforceId – Salesforce Id
	 */
	public static void createExceptionWithoutFuture(String functionPoint, String exceptionType, String exceptionMessage, String iSObject, String salesforceId) {
		//Create an exception record
		E_Exception__c exceptionInstance = new E_Exception__c(
													Function_Point__c = functionPoint,
													Exception_Type__c = exceptionType,
													Exception_Message__c = exceptionMessage,
													SObject__c = iSObject,
													Salesforce_Id__c = salesforceId);

		try {
			insert exceptionInstance;
		} catch(Exception e) {
			return;
		}
		return;
	}
	
	/**
	 * Method to construct the exception message from exception object
	 */   
	public static String constructExceptionMessageString(Exception exceptionInstance) {
		String exceptionString = '\n Line Number : ' + exceptionInstance.getLineNumber();
		exceptionString += '\n Exception Cause: ' + exceptionInstance.getCause();
		exceptionString += '\n Exception Message: ' + exceptionInstance.getMessage();
		exceptionString += '\n Stack Trace: ' + exceptionInstance.getStackTraceString();
		return exceptionString;
	}
	
}