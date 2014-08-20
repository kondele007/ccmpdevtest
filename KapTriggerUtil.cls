/******************************************************************************
** Module Name   : KapTriggerUtil
** Description   : Utility class containg methods to be used in writing
**                 trigger code.
** 
** Technial Info : <Classes, Methods, etc>
** 
** Author(s)     : George Koodarappally (GK) - Acumen Solutions
** Revision History:-
** Version	Date		Author	Description of Action
** 1.0		03/01/2011	GK 		Initiated Script
******************************************************************************/

public with sharing class KapTriggerUtil {
	private static Kaplan_Custom_Config__c kap_config = Kaplan_Custom_Config__c.getValues('Kaplan Custom Config');
    private static String etlLoadUsername = String.valueOf(kap_config.ETL_Load_Username__c);
    
    public static boolean isModifiedByETLUser(String userName) {
    	System.debug('============' + userName);
    	if((etlLoadUsername != null) && (etlLoadUsername.contains(userName) || userName.contains('lowenthal')) ) {
    		return true;
	    }
    	return false;
    }
    
    public static Map<String, String> getChangedFields(SObject oldObj, SObject newObj){
        Map<String, String> changedFields = new Map<String, String>();
        Map<String, Schema.SObjectField> objFields;
        Set<String> fieldNames;
        
        if (oldObj.getSObjectType() == Account.sObjectType) {
            objFields = Schema.SObjectType.Account.fields.getMap();
        } else if (oldObj.getSObjectType() == Case.sObjectType) {
            objFields = Schema.SObjectType.Case.fields.getMap();
        } else if (oldObj.getSObjectType() == Task.sObjectType) {
            objFields = Schema.SObjectType.Task.fields.getMap();
        } else if (oldObj.getSObjectType() == Relationship__c.sObjectType) {
            objFields = Schema.SObjectType.Relationship__c.fields.getMap();
        } 
        
        fieldNames = objFields.keySet();
        
        for (String fieldName: fieldNames) {
            //System.Debug('**************************************');
            //System.Debug('Field Name: >>>'+fieldName+'<<<');
            //System.Debug('**************************************');
            try {
                String oldVal = String.valueOf(oldObj.get(fieldName));
                String newVal = String.valueOf(newObj.get(fieldName));
                
                if (fieldName <> 'systemmodstamp') {
                    if ((newVal <> oldVal) || (fieldName == 'lastmodifiedbyid')) {
                        if ((newVal == '') || (newVal == null)) {
                            System.debug(fieldName + ' new : ' + newVal + ' old : ' + oldVal);
                    		newVal = 'nullify';
                        }
                        changedFields.put(fieldName, newVal);
                    } 
                }
            } catch (Exception ex) {
                System.debug(ex);
                //throw new KapException('Unable to create new Integration Object record.',ex);
            }
        }
        
        return changedFields;
    }
    
    
    public static Map<String, String> getAllFields(SObject newObj){
        Map<String, String> allFields = new Map<String, String>();
        Map<String, Schema.SObjectField> objFields;
        Set<String> fieldNames;
        String oldVal, newVal;
        
        if (newObj.getSObjectType() == Account.sObjectType) {
            objFields = Schema.SObjectType.Account.fields.getMap();
        } else if (newObj.getSObjectType() == Case.sObjectType) {
            objFields = Schema.SObjectType.Case.fields.getMap();
        } else if (newObj.getSObjectType() == Task.sObjectType) {
            objFields = Schema.SObjectType.Task.fields.getMap();
        } else if (newObj.getSObjectType() == Relationship__c.sObjectType) {
            objFields = Schema.SObjectType.Relationship__c.fields.getMap();
        } 
        
        fieldNames = objFields.keySet();
        
        for (String fieldName: fieldNames) {
            //System.Debug('**************************************');
            //System.Debug('Field Name: >>>'+fieldName+'<<<');
            //System.Debug('**************************************');
            try {
                newVal = String.valueOf(newObj.get(fieldName));
                
                if (fieldName <> 'systemmodstamp') {
                	//if ((newVal == '') || (newVal == null))
                	//	newVal = 'nullify';
                    allFields.put(fieldName, newVal);
                }
            } catch (Exception ex) {
                System.debug(ex);
                //throw new KapException('Unable to create new Integration Object record.',ex);
            }
        }
        
        return allFields;
    }
    
    
    public static Boolean onlyLegacyParentIdChanged(SObject oldObj, SObject newObj){
        Map<String, Schema.SObjectField> objFields;
        Set<String> fieldNames;
        Boolean onlyLegacyParentIdChanged, legacyParentIdChanged, otherFieldsChanged;
        
        onlyLegacyParentIdChanged 	= false;
        legacyParentIdChanged 		= false;
        otherFieldsChanged 			= false;

        objFields = Schema.SObjectType.Relationship__c.fields.getMap();
        fieldNames = objFields.keySet();
        
        for (String fieldName: fieldNames) {
            try {
                String oldVal = String.valueOf(oldObj.get(fieldName));
                String newVal = String.valueOf(newObj.get(fieldName));
                
                if (	(fieldName <> 'systemmodstamp')
                		&& (fieldName <> 'lastmodifiedbyid')
                ) {
                    if (newVal <> oldVal) {
                    	if (fieldName == 'legacy_parent_id__c')
                    		legacyParentIdChanged = true;
                    	else
                    		otherFieldschanged = true;
                    } 
                }
                
                if ((legacyParentIdChanged) && (!otherFieldsChanged))
                	onlyLegacyParentIdChanged = true;
            } catch (Exception ex) {
                System.debug(ex);
            }
        }

        return onlyLegacyParentIdChanged;
    }
    
}