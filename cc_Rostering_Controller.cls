public class cc_Rostering_Controller {

    public E_Rostering_Master__c rm;
    public String aFailMessage;

    public Blob contentFile{get;set;}
    String[] filelines = new String[]{};
    List <CC_Rostering_Detail__c> rdList;
    public String nameFile {get;set;}
    String rosterFileName;
    
    public cc_Rostering_Controller() { 
        String OppId = ApexPages.currentPage().getParameters().get('id');
        System.debug(LoggingLevel.INFO, '$$Roster ID=' + OppId);
        System.debug(LoggingLevel.INFO, '$$Roster rm=' + rm);
        rm = new E_Rostering_Master__c();
        rm.Opportunity__c = OppId;
        System.debug(LoggingLevel.INFO, '$$Roster rm2=' + rm);
    }

    public Pagereference ReadFile(){
        String OppId = rm.Opportunity__c;
        System.debug(LoggingLevel.INFO, '$$Roster ReadFile ID=' + OppId);
        System.debug(LoggingLevel.INFO, '$$Roster ReadFile rm.Opportunity__c=' + rm.Opportunity__c);
        System.debug(LoggingLevel.INFO, '$$Roster contentFile=' + contentFile);
        if(contentFile == null){
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured. No file has been selected.');
            ApexPages.addMessage(errormsg);
            return null;  
        }else{
            try{      
                rm.Upload_Date__c = System.now();
                rosterFileName = nameFile;
                rm.Name = rosterFileName;               
                insert rm;
            }
            catch (Exception e){
                ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured, on creation of Roster Master record.');
                ApexPages.addMessage(errormsg);
                return null; 
            }
        }
        System.debug(LoggingLevel.INFO, '$$Roster nameFile before=' + nameFile);
        nameFile=contentFile.toString();
        filelines = nameFile.split('\r');
        System.debug(LoggingLevel.INFO, '$$Roster nameFile=' + nameFile);
        System.debug(LoggingLevel.INFO, '$$Roster contentFile=' + contentFile);
        System.debug(LoggingLevel.INFO, '$$Roster filelines=' + filelines.size());

        rdList= new List<CC_Rostering_Detail__c>();
        
        for (Integer i=1;i<filelines.size();i++)
        {
            aFailMessage = '';
            String[] inputvalues = new String[]{};
            inputvalues = filelines[i].split(',');
            CC_Rostering_Detail__c rd = new CC_Rostering_Detail__c();
            System.debug(LoggingLevel.INFO, '$$Roster inputvalues=' + inputvalues.size());
            System.debug(LoggingLevel.INFO, '$$Roster rm.Name=' + rm.Id);
            rd.CC_Rostering_Master__c = rm.Id;
            if(inputvalues.size() < 23){
                rd.Status__c = 'Fail';
                rd.Notes__c = 'The record should have minimum data elements to process the record. - '+inputvalues;
                rdList.add(rd);
                continue;
            }
            
            // First Name
            if(validateField(inputvalues[0], 'First Name')){
                rd.First_Name__c = inputvalues[0];
            }
            // Last Name
            if(validateField(inputvalues[1], 'Last Name')){
                rd.Last_Name__c = inputvalues[1];
            }
            // Email
            if(validateField(inputvalues[2], 'Email')){
                rd.Email__c = inputvalues[2];
            }
            // Street Addres Line 1
            if(validateField(inputvalues[3], 'Street Address Line 1')){
                rd.Street_Address_Line_1__c = inputvalues[3];
            }
            // Street Addres Line 2
            //if(validateField(inputvalues[4], 'Street Addres Line 2')){
                rd.Street_Address_Line_2__c = inputvalues[4];
            //}
            // City
                System.debug(LoggingLevel.INFO, '$$Roster city=' + inputvalues[5]);
            if(validateField(inputvalues[5], 'City')){
                rd.City__c = inputvalues[5];
            }
            // State
            if(validateField(inputvalues[6], 'State')){
                rd.State__c = inputvalues[6];
            }
            // Zipcode
            if(validateField(inputvalues[7], 'Zipcode')){
                rd.Zipcode__c = inputvalues[7];
            }
            // Country
            //if(validateField(inputvalues[8], 'Country')){
                rd.Country__c = inputvalues[8];
            //}
            // Phone
            //if(validateField(inputvalues[9], 'Phone')){
                rd.Phone__c = inputvalues[9];
            //}
            // Programs Of Interest
            if(validateField(inputvalues[10], 'Programs Of Interest')){
                rd.Program_Of_Interest__c = inputvalues[10];
            }
            // Class Code
            if(validateField(inputvalues[11], 'Class Code')){
                rd.Class_Code__c = inputvalues[11];
            }
            // Transaction Code
            if(validateField(inputvalues[12], 'Transaction Code')){
                rd.Transaction_Code__c = inputvalues[12];
            }

            // Balance Due
            if(validateField(inputvalues[13], 'Balance Due')){
                rd.Balance_Due__c = Decimal.valueOf(inputvalues[13]);
            }
            // Start Date
            System.debug(LoggingLevel.INFO, '$$Roster Start Date=' + inputvalues[14]); 
            if(validateField(inputvalues[14], 'Start Date')){

                Date tempDate = convertStringToDate(inputvalues[14],'Start Date');
                if(tempDate != null){
                    rd.Start_Date__c = tempDate;
                }
            }
            // End Date
            //if(validateField(inputvalues[15], 'End Date')){
            System.debug(LoggingLevel.INFO, '$$Roster End Date=' + inputvalues[15]);
                if (inputvalues[15] != 'null'){
                    Date tempDate = convertStringToDate(inputvalues[15],'End Date');
                   if(tempDate != null){
                        rd.End_Date__c = tempDate;
                    } 
                }      
            //}
            // Graduation Year
            //if(validateField(inputvalues[16], 'Graduation Year')){
                System.debug(LoggingLevel.INFO, '$$Roster Graduation Date=' + inputvalues[16]);
                System.debug(LoggingLevel.INFO, '$$Roster length=' + inputvalues[16].trim().length());
                if(inputvalues[16].trim().length() > 4){
                    aFailMessage = aFailMessage + 'Graduation Year Field Validation Failed. ';
                }else{
                    if(inputvalues[16].trim() != '' && !pattern.matches('[a-zA-Z]+',inputvalues[16])){
                        rd.Graduation_Year__c = Decimal.valueOf(inputvalues[16]);
                    } 
                }
            //}
            // School Id
            //if(validateField(inputvalues[17], 'School Id')){
                System.debug(LoggingLevel.INFO, '$$Roster rd.Graduation_Year__c' + rd.Graduation_Year__c);
                rd.School_Id__c = inputvalues[17];
                System.debug(LoggingLevel.INFO, '$$Roster rd.School_Id__c' + rd.School_Id__c);
                if(rd.Graduation_Year__c != null && (rd.School_Id__c == null || rd.School_Id__c == '')){
                    aFailMessage = aFailMessage + 'School ID is required if Graduation Year is provided. ';
                }
            //}
            // Channel
            if(validateField(inputvalues[18], 'Channel')){
                rd.Channel__c = Decimal.valueOf(inputvalues[18]);
            }
            // Lead Source Id
            if(validateField(inputvalues[19], 'Lead Source Id')){
                rd.Lead_Source_ID__c = Decimal.valueOf(inputvalues[19]);
            }
            // Center Code
            if(validateField(inputvalues[20], 'Center Code')){
                rd.Center_Code__c = inputvalues[20];
            }
            // Student Id
            //if(validateField(inputvalues[21], 'Student Id')){
                if(inputvalues[21].trim() != '' && !pattern.matches('[a-zA-Z]+',inputvalues[21])){
                    rd.Student_Id__c = Decimal.valueOf(inputvalues[21]);
                }   
            //}
            // Do Not Email
            if(inputvalues[22] == 'N' || inputvalues[22] == 'No' || inputvalues[22] == '0' || inputvalues[22].trim() == ''){
                rd.Do_Not_Email__c = false;
            }else{
                rd.Do_Not_Email__c = true;
            }
            // Do Not Call
            if(inputvalues[23] == 'N' || inputvalues[23] == 'No' || inputvalues[23] == '0' || inputvalues[23].trim() == ''){
                rd.Do_Not_Call__c = false;
            }else{
                rd.Do_Not_Call__c = true;
            }
            if(aFailMessage == ''){
                rd.Status__c = 'Loaded';            
            }else{
                rd.Status__c = 'Fail';
                rd.Notes__c = aFailMessage;
            }
            rdList.add(rd);         

        }
        System.debug(LoggingLevel.INFO, '$$Roster rdList1=' + rdList);
        if(rdList != null){
            insert rdList;

            String status = 'Loaded';
            String query = 'select Id,  First_Name__c, Last_Name__c, Email__c, Street_Address_Line_1__c, Street_Address_Line_2__c, State__c, City__c, Zipcode__c, CC_Rostering_Master__c, Country__c, Phone__c, Program_Of_Interest__c, School_Id__c, Graduation_Year__c, Student_Id__c, Center_Code__c, Do_Not_Email__c, Do_Not_Call__c, Channel__c, Start_Date__c, End_Date__c, Class_Code__c, Transaction_Code__c, Balance_Due__c, Lead_Source_ID__c, Status__c, Notes__c from CC_Rostering_Detail__c where CC_Rostering_Master__c = \'' + rm.Id + '\' and Status__c = \''+status+'\'';
            rdList = Database.query(query);
            System.debug(LoggingLevel.INFO, '$$Roster rdList3=' + rdList.isEmpty());
            if(!rdList.isEmpty()){
               
                cc_RosterScheduler rosterSched = new cc_RosterScheduler(query,OppId,rosterFileName,rm.Id, 'cc_Roster_Preprocessor');
                Datetime dt = Datetime.now().addSeconds(10);
                String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
                System.debug(LoggingLevel.INFO, '$$Roster timeForScheduler=' + timeForScheduler);
                Id schedId = System.Schedule('RosterPreProcessor'+timeForScheduler,timeForScheduler,rosterSched);
                System.debug(LoggingLevel.INFO, '$$Roster schedId=' + schedId);
                System.debug(LoggingLevel.INFO, '$$Roster aFailMessage=' + aFailMessage);
                ApexPages.Message successMsg = new ApexPages.Message(ApexPages.severity.INFO,'The Batch Job to upload the roster file has been submitted. You will recieve an email when it is completed.');
                ApexPages.addMessage(successMsg);
             }else{
                ApexPages.Message successMsg = new ApexPages.Message(ApexPages.severity.INFO,'All the records in the roster file failed. Please check the roster master object for details.');
                ApexPages.addMessage(successMsg);
             }
            PageReference pageRef = new PageReference('/'+rm.Id);
            pageRef.setRedirect(true);
            return pageRef;
        }
        return null;
    }

    public boolean validateField(String aField, String aFieldName){
        if(aField != null && aField.trim() != ''){
            return true;
        }else{
            aFailMessage = aFailMessage + aFieldName + ' Validation Failed. ';
            return false;
        }

    }


    public Date convertStringToDate(String dt, String aFieldName){
        Date tempDate;
        if(dt == '' || dt == null){
            return null;
        }
        String[] tempStr = dt.split('/');
        System.debug(LoggingLevel.INFO, '$$Roster tempStr=' + tempStr);
        Integer d = Integer.valueOf(tempStr[1]);
        Integer m = Integer.valueOf(tempStr[0]);
        Integer y = Integer.valueOf(tempStr[2]);
        try{
            tempDate = Date.newInstance(y,m,d);
            System.debug(LoggingLevel.INFO, '$$Roster tempDate1=' + tempDate);
            //tempDate = Date.valueOf(y+'-'+m+'-'+d);
            //System.debug(LoggingLevel.INFO, '$$Roster tempDate2=' + tempDate);
        }catch(Exception e){
            System.debug(LoggingLevel.INFO, '$$Roster convertStringToDate Exception=');
            aFailMessage = aFailMessage + aFieldName + ' Validation Failed. ';
        }
        return tempDate;
    
    }

    public Blob getcontentFile() {
        return contentFile;
    }

    public E_Rostering_Master__c getrm() {
        return rm;
    } 
}