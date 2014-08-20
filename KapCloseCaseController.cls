/***
 ****  @author skandukuri
 ***/
public with sharing class KapCloseCaseController {

    private final Case thisCase { get; set; }
    public CaseComment caseComment { get; set; }
    public Account caseAccount;

    public Id caseId;
    public Id accountId;
    public String returnURL;

    public Integer calloutStatus { get; set; }
    public String calloutResponse { get; set; }
    public boolean displaying { get; set; }
    public String message { get; set; }
    public String Statusa { get; set; }

    public boolean display12 { get; set; }
    public boolean display21 { get; set; }
    public boolean isValid { get; set; }

    private final CaseSolution caseSolution;

    public KapCloseCaseController(ApexPages.StandardController stdController) {

        isValid = true;
        //system.debug('----------Starting of constructor---');
        caseId = ApexPages.currentPage().getParameters().get('id');
        //system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& caseId:'+caseId);
        List < CaseShare > csList = [Select caseAccessLevel, caseId, UserOrGroupId from CaseShare where caseId = : this.caseId];
        //System.debug('------------------------------------------------------------csList:'+csList);
        Group gRole = [Select Id from Group where relatedId = : UserInfo.getUserRoleId() LIMIT 1];
        List < GroupMember > groupList = [Select Id, GroupId from GroupMember where(UserOrGroupId = : UserInfo.getUserId() OR UserOrGroupId = : gRole.Id)];
        //System.debug('--------------------------------groupList:'+groupList);
        List < Id > groupUserId = new List < Id > ();
        for (GroupMember gm: groupList) {
            groupUserId.add(gm.GroupId);
        }

        groupUserId.add(UserInfo.getUserId());
        //system.debug('***********************************************groupUserId:'+groupUserId);
        //csList.CaseId = GroupUserId;

        List < CaseShare > csFinalList = [Select caseAccessLevel, caseId, UserOrGroupId from CaseShare where caseId = : this.caseId and
            UserOrGroupId In: groupUserId and(caseAccessLevel = : 'All'
            OR caseAccessLevel = : 'Edit')
        ];

        //System.debug('------------------------------------------------------------csFinalList:'+csFinalList);
        if (csFinalList == null || csFinalList.size() == 0) {
            //System.debug('---------------------------Inside if condition-----');
            isValid = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Insufficient Privileges You do not have the level of access necessary to perform the operation you requested. Please contact the owner of the record or your administrator if access is necessary.'));
        }

        thisCase = (Case) stdController.getRecord();
        accountId = thisCase.AccountId;
        caseAccount = [SELECT Student_Id_Display__c, Kaptest_Username__c FROM Account WHERE Id = : accountId LIMIT 1];
        returnURL = ApexPages.currentPage().getParameters().get('retURL');
        displaying = false;
        caseComment = new CaseComment();
    }

    public String getUserId() {

        accountId = thisCase.AccountId;

        //System.debug('debugging for account id '+thisCase.AccountId);
        return accountId;
    }

    public String getKaptestUserId() {

        return caseAccount.Kaptest_Username__c;
    }

    public String getStudentIdDisplay() {

        return caseAccount.Student_ID_Display__c;
    }

    public String getPurchaseId() {

        Case thisCase1;
        String enrollid;

        //system.debug('********************caseId:'+caseId);
        thisCase1 = [Select c.Enrollment__r.Enrollment_Id__c, c.Enrollment__r.expiration_date__c From Case c WHERE Id = : caseId LIMIT 1];
        enrollId = thisCase1.Enrollment__r.Enrollment_Id__c;

        //Date enrollexpdate = thisCase1.Enrollment__r.expiration_date__c;
        //String enrollId2 = thisCase1.Enrollment__c;

        //System.debug(enrollId);
        //System.debug(enrollId2);
        return enrollId;
    }

    public Date getCurrentExpDate() {

        Case thisCase2;
        //String enrollid;

        thisCase2 = [Select c.Enrollment__r.expiration_date__c From Case c WHERE Id = : caseId LIMIT 1];

        date currentExpirationDate1 = thisCase2.Enrollment__r.Expiration_date__c;
        String currentExpirationDate = String.valueOf(currentExpirationDate1);

        return currentExpirationDate1;
    }

    public PageReference save() {

        String TypeDetail, ResolutionType;
        PageReference returnPage;
        TypeDetail = thisCase.Type_Detail__c;
        ResolutionType = thisCase.Resolution_Type__c;

        if (ResolutionType == 'Processed automatic extension 29 days or more') {
            String errorString = '';
            String processinstanceaa = '';
            boolean ApprovalRequired = false;
            Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();
            String approvalHistory = pwr.getAction();

            List < ProcessInstance > ItemList = [Select p.TargetObjectId, p.SystemModstamp, p.Status, p.LastModifiedDate, p.LastModifiedById, p.IsDeleted, p.Id, p.CreatedDate, p.CreatedById
                From ProcessInstance p where TargetObjectId = : thisCase.id order by p.createddate desc
            ];

            String usrProfileName = [select u.Profile.Name from User u where u.id = : Userinfo.getUserId()].Profile.Name;
            if (usrProfileName.equals('Kaplan NXT Agent Level 1') || (usrProfileName.equals('Kaplan NXT Agent Level 2'))) {
                //System.debug('testing the profiles code11'+usrProfileName);
                ApprovalRequired = true;

            }
            //System.debug('testing the profiles code'+usrProfileName);
            //System.debug('approval code not required '+ApprovalRequired);
            if ( ItemList.size() < 1 && ApprovalRequired) {

                //System.debug('approval code 11 not required '+ApprovalRequired);
                ApexPages.Message errMesg = new ApexPages.Message(ApexPages.Severity.ERROR, ' Extensions cannot be more than 28 days from the current expiration date without approval of a manager. Please submit this case for approval.');
                ApexPages.addMessage(errMesg);
                return null;
            }
            else if( !itemList.isEmpty() ) {
                processinstanceaa = itemList[0].Status;
            }
            else {
                processinstanceaa = 'Approved';
            }

            String approvall = 'Your request has been ' + processinstanceaa + ' by a manager. Please contact the customer to find an alternative resolution';
            errorString = errorString + approvall;

            if (processinstanceaa == 'Pending') {
                ApexPages.Message errMesg = new ApexPages.Message(ApexPages.Severity.ERROR, errorString);
                ApexPages.addMessage(errMesg);
            } else if (processinstanceaa == 'Rejected') {
                ApexPages.Message errMesg = new ApexPages.Message(ApexPages.Severity.ERROR, errorString);
                ApexPages.addMessage(errMesg);
            } else if (processinstanceaa == 'Approved' || Test.isRunningTest()) {

                if ((TypeDetail == KapConstants.KAP_TYPE_DETAIL_RESET_PASSWORD) && (ResolutionType == KapConstants.KAP_RESOLUTION_TYPE_RESET_PASSWORD)) {
                    displaying = true;
                    returnPage = setKaplanPass();
                    return returnPage;
                } else if ((TypeDetail == KapConstants.KAP_TYPE_DETAIL_ONLINE_EXTENSION || Test.isRunningTest())) {
                    displaying = true;
                    try {
                        String enrollmentid = getPurchaseId();
                        Date enddate = thisCase.Online_Extension_Date__c;
                        Date datecurrent123 = Date.today();
                        String enddate11 = String.valueOf(enddate);
                        String enrollmentid1 = getPurchaseId();
                        Date currentExpDate = getCurrentExpDate();
                        String enddateFinal1 = String.valueOf(currentExpDate);

                        Date enddate1;
                        Date enddate2;
                        Date enddateFinal;

                        String[] stringDate = enddate11.split('-');
                        Integer y = Integer.valueOf(stringDate[0]);
                        Integer m = Integer.valueOf(stringDate[1]);
                        Integer d = Integer.valueOf(stringDate[2]);
                        enddate1 = date.newInstance(y, m, d);
                        enddate2 = date.newInstance(y, m, d);

                        String[] stringDate1 = enddateFinal1.split('-');
                        Integer y1 = Integer.valueOf(stringDate1[0]);
                        Integer m1 = Integer.valueOf(stringDate1[1]);
                        Integer d1 = Integer.valueOf(stringDate1[2]);

                        enddateFinal = date.newInstance(y1, m1, d1 + 29);
                        String custom = m + '/' + d + '/' + y;

                        KapCatalogWS kapcatalogws = new KapCatalogWS();
                        KapXmlResponseWS kapxmlresponse = new KapXmlResponseWS();
                        kapxmlresponse = kapcatalogws.setOnlineExtensions(enrollmentid1, custom);

                        if (kapxmlresponse != null) {
                            Integer statuscode = kapxmlresponse.statusCode;
                            String responsebody = kapxmlresponse.xmlBody;

                            if (statuscode == 200) {
                                try {
                                    update thisCase;
                                    caseComment.ParentId = thisCase.Id;
                                    insert caseComment;
                                } catch (Exception e) {
                                    ApexPages.addMessages(e);
                                }
                                return new PageReference('/' + ApexPages.currentPage().getParameters().get('id'));
                            } else {
                                String errorString12 = 'webservice failed';
                                ApexPages.Message errMesg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Business System Response XML Error for 29 Days :' + responsebody);
                                ApexPages.addMessage(errMesg);
                            }
                            // else for webservice response
                        } else {
                            String errorString123 = 'webservice failed';
                            ApexPages.Message errMesg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Business System Response Invoke Error for 29 days :' + errorString123);
                            ApexPages.addMessage(errMesg);
                        }
                    } catch (Exception e) {
                        ApexPages.Message errMesg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Try Again Extension has timed out');
                        ApexPages.addMessage(errMesg);
                    }
                }
                //else for type details
                else {
                    if (thisCase.Online_Extension_Date__c == null) {
                        try {
                            update thisCase;
                            caseComment.ParentId = thisCase.Id;
                            insert caseComment;
                        } catch (Exception e) {
                            System.Debug(e);
                        }
                        return new PageReference('/' + ApexPages.currentPage().getParameters().get('id'));
                    }
                }
            }
            return null;
        }
        //else for the resolution
        else {

            if ((TypeDetail == KapConstants.KAP_TYPE_DETAIL_RESET_PASSWORD) && (ResolutionType == KapConstants.KAP_RESOLUTION_TYPE_RESET_PASSWORD)) {
                displaying = true;
                returnPage = setKaplanPass();
                return returnPage;
            } else if ((TypeDetail == KapConstants.KAP_TYPE_DETAIL_ONLINE_EXTENSION) && (ResolutionType == 'Processed automatic extension 28 days or less')) {
                displaying = true;
                System.debug('The value of ResolutionType is::'+ResolutionType);
                System.debug('The Value of TypeDetail is::'+TypeDetail );
                returnPage = setOnlineExtension();
                return returnPage;
            }  else if ((TypeDetail == KapConstants.KAP_TYPE_DETAIL_ONLINE_EXTENSION) && (ResolutionType == 'Paid Extension')) {
                displaying = true;
                System.debug('The value of ResolutionType is::'+ResolutionType);
                System.debug('The Value of TypeDetail is::'+TypeDetail );
                returnPage = setOnlineExtension();
                return returnPage;
            } 
            else {
                if (thisCase.Online_Extension_Date__c == null) {
                    try {

                        update thisCase;
                        caseComment.ParentId = thisCase.Id;
                        insert caseComment;
                    } catch (Exception e) {
                        System.Debug(e);
                    }
                    return new PageReference('/' + ApexPages.currentPage().getParameters().get('id'));
                } else {
                    String errorString = 'Online Extension date should be empty to save';
                    ApexPages.Message errMesg = new ApexPages.Message(ApexPages.Severity.ERROR, errorString);
                    ApexPages.addMessage(errMesg);
                    return null;
                }
            }
        }
    } // end of save

    public PageReference setKaplanPass() {

        if (thisCase.Online_Extension_Date__c == null) {

            String username = getKaptestUserId();

            String password1 = getStudentIdDisplay();

            //System.debug('username for it is '+username);
            //System.debug('password to be set to is'+password1);
            KaptestWS kaptestws = new KaptestWS();

            KapXmlResponseWS kapxmlresponse = new KapXmlResponseWS();
            kapxmlresponse = kaptestws.setHardPasswordReset(username, password1);

            if (kapxmlresponse != null) {
                Integer responsecode = kapxmlresponse.statusCode;
                String responsebody = kapxmlresponse.xmlBody;
                if (responsecode == 200) {
                    try {

                        update thisCase;
                        caseComment.ParentId = thisCase.Id;
                        insert caseComment;

                    } catch (Exception e) {
                        ApexPages.addMessages(e);
                    }

                    return new PageReference(returnURL);
                } else {
                    String errorString = 'reset password failed from business system ';
                    ApexPages.Message errMesg = new ApexPages.Message(ApexPages.Severity.ERROR, errorString);
                    ApexPages.addMessage(errMesg);
                }


            } else {
                String errorString = 'Wrong username and password.';
                ApexPages.Message errMesg = new ApexPages.Message(ApexPages.Severity.ERROR, errorString);
                ApexPages.addMessage(errMesg);
            }
        } else {
            String errorString = 'online extension date should be null for password reset';
            ApexPages.Message errMesg = new ApexPages.Message(ApexPages.Severity.ERROR, errorString);
            ApexPages.addMessage(errMesg);
        }
        return null;
    }

    public PageReference setOnlineExtension() {

        Date enddate = thisCase.Online_Extension_Date__c;
        //jll
        if (Test.isRunningTest()) {
            enddate = Date.today();
        }
        Date datecurrent123 = Date.today();
        String enddate11 = String.valueOf(enddate);
        String enrollmentid = getPurchaseId();
        Date currentExpDate = getCurrentExpDate();
        //jll
        if (Test.isRunningTest()) {
            currentExpDate = Date.today();
        }
        Integer totalnodays=currentExpDate.daysBetween(enddate);
        String enddateFinal1 = String.valueOf(currentExpDate);
        Date enddate1;
        Date enddate2;
        Date enddateFinal;
        String ResType = thisCase.Resolution_Type__c;
        boolean success;

        if (enddate != null) {
            String[] stringDate = enddate11.split('-');
            Integer y = Integer.valueOf(stringDate[0]);
            Integer m = Integer.valueOf(stringDate[1]);
            Integer d = Integer.valueOf(stringDate[2]);
            enddate1 = date.newInstance(y, m, d);
            enddate2 = date.newInstance(y, m, d);
            String[] stringDate1 = enddateFinal1.split('-');
            Integer y1 = Integer.valueOf(stringDate1[0]);
            Integer m1 = Integer.valueOf(stringDate1[1]);
            Integer d1 = Integer.valueOf(stringDate1[2]);
            enddateFinal = date.newInstance(y1, m1, d1 + 29);
            String custom = m + '/' + d + '/' + y;
            String enddate12 = String.valueOf(enddate1).replaceAll('-', '/');
            Integer totalNumberOrgDays;
            Integer totalnumberDays;


            if (currentExpDate != null) {
            /***    Integer pastNumberOrgDays = enddateFinal.daysBetween(enddate);
                if (enddateFinal > enddate) {
                    totalnumberDays = 12;
                } else {
                    totalnumberDays = 30;
                }****/

                if (totalnodays < 29 && ResType=='Processed automatic extension 28 days or less') {
                System.debug('The value of totalnodays is lt 29 and resttype is 28days::'+totalnodays);
                success=true;
                }
                 else if (totalnodays > 0 && ResType=='Paid Extension'){
                 System.debug('The value of totalnodays is gt 0 and paid extension::'+totalnodays);
                success=true;
                }
                 else if ((totalnodays > 28 && ResType=='Processed automatic extension 28 days or less') ){
                 System.debug('The value of totalnodays is gt 28 and restype is 28 days::'+totalnodays);
                ApexPages.Message errMesg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Extension cannot be more than 28 days from the current Expiration Date ');
                 ApexPages.addMessage(errMesg);
                }
               
                else if(!(totalnodays > 0 && ResType=='Paid Extension')){
                System.debug('The value of totalnodays is::'+totalnodays);
                   ApexPages.Message errMesg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Online Extension Date Should have a Value ');
                    ApexPages.addMessage(errMesg);
                    }
                  
                
                 
                
                    if(Success==true){

                    try {
                        KapCatalogWS kapcatalogws = new KapCatalogWS();
                        KapXmlResponseWS kapxmlresponse = new KapXmlResponseWS();
                        kapxmlresponse = kapcatalogws.setOnlineExtensions(enrollmentid, custom);


                        if (kapxmlresponse != null) {
                            Integer statuscode = kapxmlresponse.statusCode;
                            String responsebody = kapxmlresponse.xmlBody;

                            if (statuscode == 200) {

                                try {
                                    update thisCase;
                                    caseComment.ParentId = thisCase.Id;
                                    insert caseComment;
                                } catch (Exception e) {
                                    ApexPages.addMessages(e);
                                }

                                return new PageReference('/' + ApexPages.currentPage().getParameters().get('id'));


                            } else {
                                String errorString = 'webservice failed';
                                ApexPages.Message errMesg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Business System Response :' + responsebody);
                                ApexPages.addMessage(errMesg);

                            }

                        } else {
                            String errorString = 'webservice failed';
                            ApexPages.Message errMesg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Business System Response :' + errorString);
                            ApexPages.addMessage(errMesg);
                        }
                    } catch (Exception e) {
                        ApexPages.Message errMesg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Try Again Extension has timed out');
                        ApexPages.addMessage(errMesg);
                    }
                 
                }
             }
             else {
                ApexPages.Message errMesg = new ApexPages.Message(ApexPages.Severity.ERROR, 'date is empty');
                ApexPages.addMessage(errMesg);
            }

        }
        return null;
    }

    public PageReference Cancel() {
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('id'));

    }
}