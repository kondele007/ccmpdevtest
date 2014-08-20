public class KapParserInteractions {

    private Account account;

    public List<Interaction__c> inteList = new List<Interaction__c>();

    public KapParserInteractions(ApexPages.StandardController controller) {
        this.account = (Account) controller.getRecord();
     }

    public PageReference init() {
        getInteractions();
        PageReference pg ;
        pg = new PageReference('/'+account.Id);
        pg.getParameters().put('nooverride','1');
        return pg;
    }

     public void getInteractions() {

         Account acc = [Select Id,Student_ID_Display__c from Account where Id = : this.account.Id];

         // Delete Case Close and open to avoid problems with upsert
         inteList= [select i.User_Name__c, i.User_Id__c, i.SystemModstamp, i.Student_Id__c, i.Reason__c, i.Outbound_Window_Close__c, i.Name, i.Legacy_Modified_On__c, i.Legacy_Created_On__c, i.LastModifiedDate, i.LastModifiedById, i.IsDeleted, i.Interaction_Type__c, i.Interaction_Id__c, i.Interaction_Date__c, i.Inbound_Window_Close__c, i.Id, i.CreatedDate, i.CreatedById, i.Contact_Type__c, i.Comment__c from interaction__c i where i.account__r.id=:this.account.Id and (i.Interaction_Type__c='Case Closed' or i.Interaction_Type__c='Case Opened')];
         delete inteList;

         KapEngineWS kapEngine = new KapEngineWS();
         kapXmlResponseWS response;
         try
         {
         	response = kapEngine.getInteractions(acc.Student_ID_Display__c);
         }
         catch( Exception ex )
         {
         	System.debug(ex);
         }
         String xmlBody;
         if(response!=null){
            xmlBody=response.xmlBody;
            Integer statusCode=response.statusCode;
            System.debug('response from the webservice xmlBody:'+xmlBody);

            Dom.Document doc = new Dom.Document();
            try {
	            doc.load(Xmlbody);
	            List<Map<String, String>> sObjList = parseXMLDoc(doc);

	            system.debug('-------------sObjList:'+sObjList);
                for(Map<String, String> fieldMap : sObjList) {

                    Set<String> keySet = fieldMap.keySet();

                    Interaction__c inte = new Interaction__c();
                    inte.Comment__c = fieldMap.get('comments');
                    inte.Legacy_Created_On__c =  nullSafeDate(fieldMap.get('createdOn'));
                    inte.Interaction_Date__c = nullSafeDate(fieldMap.get('interactionDate'));
                    inte.Interaction_Type__c = fieldMap.get('interactionType');
                    inte.Interaction_Id__c = fieldMap.get('kbsInteractionId');
                    //inte. = fieldMap.get('kbsInterestId');
                    inte.Student_Id__c = nullSafeInteger(fieldMap.get('kbsStudentId'));
                    inte.Legacy_Modified_On__c = nullSafeDate(fieldMap.get('modifiedOn'));
                    inte.User_Id__c = fieldMap.get('userId');
                    inte.User_Name__c = fieldMap.get('username');
                    inte.Account__c = this.account.id;
                    inteList.add(inte);
                    System.debug('integration list is'+inteList);
                }
                System.debug('integration list is'+inteList);
                upsert inteList Interaction_Id__c;
            } catch (DMLException e) {
                System.debug('retry!');
            } catch( System.XMLException ex ) {
            	System.debug(ex);
            }
        }

   }

   private Date nullSafeDate(String strDate) {
       if(strDate != null) {
           return Date.valueOf(strDate);
       }
       return null;
   }

   private Integer nullSafeInteger(String strDate) {
       if(strDate != null) {
           return Integer.valueOf(strDate);
       }
       return null;
   }

   private List<Map<String,String>> parseXMLDoc(Dom.Document doc) {

        List<Map<String, String>> sObjList = new List<Map<String, String>> ();
        Map<String, String> sObj = new Map<String, String>();
        Dom.XmlNode rootNode = doc.getRootElement();
        if(rootNode.getChildren() != null) {
            DOM.Xmlnode[] interactionNodeList = rootNode.getChildren();
            for(Integer j=0;j<interactionNodeList.size();j++) {
                sObj = parseChild(interactionNodeList[j]);
                sObjList.add(sObj);
            }
        }
        return sObjList;
   }

   private Map<String, String> parseChild(Dom.XmlNode node) {
         Map<String, String> sObj = new Map<String, String>();
         Dom.XmlNode[] childNodeList = node.getChildren();

         for(Integer i=0;i<childNodeList.size();i++) {
             String name = childNodeList[i].getName();
             String value = childNodeList[i].getText();
             sObj.put(name,  value);
         }
         return sObj;
   }
}