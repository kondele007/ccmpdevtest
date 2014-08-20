public abstract class cc_api_dl_dataLoaderBase {
	public abstract SObject getNewSObject();
	public virtual void deleteObject() {}
	public abstract String getDataFileName();
	public abstract String getStaticResourceUrl();
	public abstract Map<String, Schema.SObjectField> getFieldMap();
	
	public Map<String, Schema.DescribeFieldResult> getFieldDescribeMap() {
		Map<String, Schema.DescribeFieldResult> ret = new Map<String, Schema.DescribeFieldResult>();
		Map<String, Schema.SObjectField> fMap = getFieldMap();
		Set<String> keys = fMap.keyset();
		for(String key : keys) {
			ret.put(key, fMap.get(key).getDescribe());
			//System.debug('getFieldDescribeMap---> key=' + key + ' describe= ' +fMap.get(key).getDescribe());
		}
		return ret;
	}
	
	public virtual void postProcess(List<SObject> objs) {
		System.debug('--- cc_api_dl_dataLoader.postProcess: inserting objs=' + objs);
		try{
			insert objs;
		}
		catch(Exception e){
			//this means those objects already exist;
		}
	}
	
	public virtual String getTestString() {
		return '<document></document>';
	}
	public virtual String getDataString() {
		String cs = getStaticResourceUrl();
		PageReference pr = new PageReference(cs+'/'+getDataFileName());
		Blob content = pr.getContent();
	    return content.toString();
	}
	public void loadData() {
		deleteObject();
        Map<String, Schema.DescribeFieldResult> fieldMap = getFieldDescribeMap();
        System.debug('fieldMap--->' + fieldMap);
        Dom.Document doc = new Dom.Document();
        String dataContent = '';
        if(Test.isRunningTest()) {
        	dataContent = getTestString();
        	System.debug('--- cc_api_dl_dataLoaderBase.loadData: test dataContent=' + dataContent);
        } else {
        	dataContent = getDataString();
        }
		
	    doc.load(dataContent);
	    dom.XmlNode rootNode = doc.getRootElement();
	    System.debug('root name-->'+ rootNode.getName());
	    List<dom.XmlNode> children = rootNode.getChildElements();
	    List<SObject> objs= new List<SObject>();
	    for(dom.XmlNode node : children) {
	        System.debug('direct child name-->'+ node.getName());
	        List<dom.XmlNode> gc = node.getChildElements();
	        
	        SObject obj = getNewSObject();
	        for(dom.XmlNode gcn : gc) {
	        	//System.debug('ryl->field name-->'+ gcn.getName());
	        	//System.debug('ryl->field name-->'+ gcn.getName());
	        	//System.debug('ryl->field map-->'+ fieldMap.get(gcn.getName().toLowerCase()));
	        	//System.debug('ryl->field type-->'+ fieldMap.get(gcn.getName().toLowerCase()).getType());
	        	String fType = fieldMap.get(gcn.getName().toLowerCase()).getType().name();
	        	//System.debug('field Type-->'+ fType);
	        	try {
		        	if(fieldMap.get(gcn.getName().toLowerCase()).getType() == Schema.DisplayType.Boolean && !al.StringUtils.isEmpty(gcn.getText())) {
		        		obj.put(gcn.getName(),Boolean.valueof(gcn.getText()));
		        	}
		        	else if(fieldMap.get(gcn.getName().toLowerCase()).getType() == Schema.DisplayType.Currency && !al.StringUtils.isEmpty(gcn.getText())) {
		        		obj.put(gcn.getName(),Decimal.valueof(gcn.getText()));
		        	}
		        	else if(fieldMap.get(gcn.getName().toLowerCase()).getType() == Schema.DisplayType.Integer && !al.StringUtils.isEmpty(gcn.getText())) {
		        		obj.put(gcn.getName(),Integer.valueof(gcn.getText()));
		        	}
		        	else if(fieldMap.get(gcn.getName().toLowerCase()).getType() == Schema.DisplayType.Double && !al.StringUtils.isEmpty(gcn.getText())) {
		        		obj.put(gcn.getName(),Double.valueof(gcn.getText()));
		        	}
		        	else {
		        		obj.put(gcn.getName(),gcn.getText());
		        	}
	        	} catch(Exception e) {
	        		//System.debug('loadData exception ' + e.getMessage() + ' field name=' + gcn.getName() + ' value =' + gcn.getText());
	        	}
	        	
	        	
	        }
	    	
	    	objs.add(obj);
	    }
		//System.debug('list->'+ objs);
		postProcess(objs);
        
	}
}