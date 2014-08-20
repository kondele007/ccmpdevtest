/******************************************************************************
** Module Name   : KapSalesforceWS
** Description   : Class used to expose Web Services FROM Salesforce.com
**                 for use in AJAX/JavaScript code.
** 
** Technial Info : <Classes, Methods, etc>
** 
** Author(s)     : George Koodarappally (GK) - Acumen Solutions
** Revision History:-
** Version	Date		Author	Description of Action
** 1.0		03/01/2011	GK 	Initiated Script
******************************************************************************/

global class KapSalesforceWS {
    
    webservice static Id getNextTicket(String userId) {
    	String caseId;
    	
        //System.debug(userId);
        
        caseId = KapUtil.getNextTicketId(userId);
        
        if ((userId != null) && (caseId != null)) {
			KapUtil.assignTicketToUser(caseId, userId);
        }
        
        return caseId;
    }

	webservice static String getEncryptedLoginNameForUser(String userId) {
		String encryptedLoginName;
		
		System.debug('**********************************');
		System.debug('User Id : '+userId);
		System.debug('**********************************');
		
		encryptedLoginName = KapUtil.getEncryptedKapTestLoginNameForUser(userId);
		
		System.debug('**********************************');
		System.debug('Encrypted Login Name: '+encryptedLoginName);
		System.debug('**********************************');
		
		return encryptedLoginName;
	}

	webservice static String getEncryptedLoginNameForStudent(String accountId) {
		String encryptedLoginName;
		
		System.debug('**********************************');
		System.debug('Account Id : '+accountId);
		System.debug('**********************************');
		
		encryptedLoginName = KapUtil.getEncryptedKapTestLoginNameForStudent(accountId);
		
		System.debug('**********************************');
		System.debug('Encrypted Login Name: '+encryptedLoginName);
		System.debug('**********************************');
		
		return encryptedLoginName;
	}
}