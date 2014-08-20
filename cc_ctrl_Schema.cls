global with sharing class cc_ctrl_Schema {
	
	global class Table implements al.ObjectComparator {
		public String name {get;set;}
		public String label {get;set;}
		public List<Field> fields {get;set;}

        global Integer compare(Object object1, Object object2){
            Table t1 = (Table)object1;
            Table t2 = (Table)object2;
            Integer rc = 0;
            if(t1.name < t2.name) rc = -1;
            else if(t1.name > t2.name) rc = 1;
            return rc;
        }
	}
	
	global class Field implements al.ObjectComparator {
		public String name {get;set;}
		public String label {get;set;}
		public String dataType {get;set;}
		public String defaultValue {get;set;}
		public Integer length {get;set;}
		
        global Integer compare(Object object1, Object object2){
            Field f1 = (Field)object1;
            Field f2 = (Field)object2;
            Integer rc = 0;
            if('Name'.equalsIgnoreCase(f1.name)) rc = -1;
            else if('Name'.equalsIgnoreCase(f2.name)) rc = 1;
            
            if(rc == 0) {
	            if(f1.name < f2.name) rc = -1;
	            else if(f1.name > f2.name) rc = 1;
            }
            return rc;
        }
	}
	
	public List<Table> tables {get;set;}
	private static Set<String> excludeFields = new Set<String> {'Id','SystemModstamp','CreatedById','CreatedDate','IsDeleted','LastModifiedById','LastModifiedDate','OwnerId'};
	
    public cc_ctrl_Schema() {
    	tables = new List<Table>();
    	
		Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
		for(String sobjName : gd.keySet()) {
            Schema.Describesobjectresult dr = gd.get(sobjName).getDescribe();
//		    if(dr.isCustom() == true && dr.isCustomSetting() == true) { // custom settings
		    if(dr.isCustom() == true && dr.isCustomSetting() == false && dr.getName().startsWith('E_')) { // custom objects
//		    if(dr.getName().equalsIgnoreCase('E_AccountGroup__c')) { // just E_AccountGroup__c
		        System.debug(sobjName + ' = ' + dr);
		        Table t = new Table();
		        t.name = dr.getName();
		        t.label = dr.getLabel();
		        t.fields = new List<Field>();
		        
		        Map<String, Schema.SObjectField> fieldMap = dr.fields.getMap();
		        System.debug('field map=' + fieldMap);
		        for(String fieldName : fieldMap.keySet()) {
		        	Schema.Describefieldresult dField = fieldMap.get(fieldName).getDescribe();
		        	System.debug('dfield ' + fieldName + '=' + dField);
		        	if(!excludeFields.contains(dField.getName())) {
		        	    t.fields.add(populateField(dField));
		        	}
		        }
		        
		        // sort fields by name
		        t.fields = (List<Field>)al.ArrayUtils.qsort(t.fields, new Field(), true);
		        
                tables.add(t);
		    }
		}

        // sort tables by name
        tables = (List<Table>)al.ArrayUtils.qsort(tables, new Table(), true);
    }
    
    private Field populateField(Schema.Describefieldresult sf) {
    	Field f = new Field();
    	f.name = sf.getName();
    	f.label = sf.getLabel();
    	
    	String sfType = sf.getType().name();
    	if('REFERENCE'.equalsIgnoreCase(sfType)) {
    		sfType = (sf.getRelationshipOrder() == 1 ? 'Master-detail' : 'Lookup') + ' (' + sf.getReferenceTo().get(0) + ')';
    	} else if('INTEGER'.equalsIgnoreCase(sfType)) {
    		sfType = 'Integer (' + sf.getDigits() + ')';
        } else if('DOUBLE'.equalsIgnoreCase(sfType)) {
            sfType = 'Double (' + (sf.getPrecision() - sf.getScale()) + ',' + sf.getScale() + ')';
        } else if('CURRENCY'.equalsIgnoreCase(sfType)) {
            sfType = 'Currency (' + (sf.getPrecision() - sf.getScale()) + ',' + sf.getScale() + ')';
        } else if('PERCENT'.equalsIgnoreCase(sfType)) {
            sfType = 'Percent (' + (sf.getPrecision() - sf.getScale()) + ',' + sf.getScale() + ')';
        } else if('DATETIME'.equalsIgnoreCase(sfType)) {
            sfType = 'DateTime';
        } else if('STRING'.equalsIgnoreCase(sfType)) {
            sfType = 'Text (' + sf.getLength() + ')';
        } else if('PHONE'.equalsIgnoreCase(sfType)) {
            sfType = 'Phone (' + sf.getLength() + ')';
        } else if('EMAIL'.equalsIgnoreCase(sfType)) {
            sfType = 'Email (' + sf.getLength() + ')';
        } else if('TEXTAREA'.equalsIgnoreCase(sfType)) {
            sfType = 'Text Area (' + sf.getLength() + ')';
        } else if('PICKLIST'.equalsIgnoreCase(sfType)) {
            sfType = 'Picklist (';
            Boolean isFirst = true;
            for(Schema.PicklistEntry entry : sf.getPicklistValues()) {
            	if(!isFirst) {
            		sfType += ', ';
            	} else {
            		isFirst = false;
            	}

            	if(entry.isDefaultValue()) {
            		sfType += '*';
            	}

            	sfType += entry.getValue();
            }
            sfType += ')';
        } else if('BOOLEAN'.equalsIgnoreCase(sfType)) {
            sfType = 'Boolean';
        } else if('DATE'.equalsIgnoreCase(sfType)) {
            sfType = 'Date';
        }
        
        if(sf.isExternalId()) {
        	sfType += ' (Ext ID)';
        }
        
    	f.dataType = sfType;

    	f.defaultValue = sf.getDefaultValueFormula();
    	f.length = sf.getLength();
    	return f;
    }
    
    private static testMethod void testSchemaController() {
    	cc_ctrl_Schema controller = new cc_ctrl_Schema();
    	system.assert(controller != null);
    }
}