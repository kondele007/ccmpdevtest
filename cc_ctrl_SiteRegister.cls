//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
/**
 * An apex class that creates a portal user
 */
public without sharing class cc_ctrl_SiteRegister extends cc_ctrl_CloudCraze {
    public cc_ctrl_SiteRegister getSiteRegisterController() { return this; }
    // PORTAL_ACCOUNT_ID is the account on which the contact will be created on and then enabled as a portal user.
    // you need to add the account owner into the role hierarchy before this will work - please see Customer Portal Setup help for more information.       
    //private static Id PORTAL_ACCOUNT_ID = '0018000000URqE3'; // moved to E_StorefrontSettings__c
    //==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public User thisUser {get; set; }
    public String viewState {get; set; }
    public String currentProductId {get; set; }
    public String userId {get;set;}
    public String StartUrl {get; set;}
    public String PageTitle {get; set;}
    public String metaKeywords{get; set;}
    public String metaDescription {get; set;}
    
    public Boolean selectedFlag { get; set; }
    public List<SelectOption> shippingStateOptions {get; private set;}
    public List<SelectOption> billingStateOptions {get; private set;}
    
    public String recaptchaChallenge  {get; set;}
    public String recaptchaResponse   {get; set;}
    public cc_svc_RecaptchaService recaptchaSvc {get{ 
        Try{
            return  cc_svc_RecaptchaService.getInstance();
        }
        Catch(Exception e){
            System.debug('Exception in recaptcha>>>>'+e.getmessage());
            return null;
        }
        Finally{
            System.debug('cc_svc_RecaptchaService.getInstance()>>>>'+cc_svc_RecaptchaService.getInstance());
        }    
    }}
    
    public void initTestData() {
        firstName = 'roy';
        lastName = 'lou';
        if(storefront.eCommerceType__c == 'B2B') {
            companyname='edl';
        }
        mobilePhone='111-22-3333';
        username='roy.lou14@76demo.com';
        password='northbrook5';
        confirmPassword='northbrook5';
        billStreet1='123 test';
        billStreet2='';
        billStreet3='';
        billCity='northbrook';
        billState='IL';
        billStateCA='';
        billStateText='IL';
        billPostalCode='60062';
        billCountry='US';
        
        shipStreet1='123 test';
        shipStreet2='';
        shipStreet3='';
        shipCity='northbrook';
        shipState='IL';
        shipStateCA='';
        shipStateText='IL';
        shipPostalCode='60062';
        shipCountry='US';
        
    }
    
    public String ipAddressLocationKey { 
        get {
            return cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY;
        } set; } 
    
    public String currentCartID {get; set;}
    public String ipAddressLocation{get; set; }

    public E_ContactAddr__c billToAddress {get; set; }
    public E_ContactAddr__c shipToAddress {get; set; }
    public String username {get; set;}
    public String firstName {get; set;}
    public String lastName {get; set;}
    public String password {get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
    public String communityNickname {get; set { communityNickname = value == null ? value : value.trim(); } }
    public Id accountId { get; set; }
    public String userSalutation { get; set; }
    public String position_title {get; set; }
    public String department {get; set; }
    public String companyName {get; set; }
    public String companyType {get; set;}
    public String usercontactTypeRole {get; set; }
    public String language {get; set;}
    public String currencyCode {get; set;}

    public List<String> reRenderList {get; set; }
    public Boolean sameasbilling {get; set; }
    public String userIndustry {get; set; }
    public String shipStreet1 {get; set; }
    public String shipStreet2 { get; set; }
    public String shipStreet3 {get; set; }
    public String shipCity {get; set; }
    public String shipState {get; set; }
    public String shipStateCA {get; set; }
    public String shipStateText {get; set; }        
    public String shipPostalCode {get; set; }
    public String shipCountry {get;
        set {
            System.debug('--- cc_ctrl_SiteRegister.setShipCountry: setting to: ' + value);
            shipCountry = value;
        }
    }
   
    public String billStreet1 {get; set; }
    public String billStreet2 { get; set; }
    public String billStreet3 {get; set; }
    public String billCity {get; set; }
    public String billState {get; set; }
    public String billStateCA {get; set; }
    public String billStateText {get; set; }
    public String billPostalCode {get; set; }
    public String billCountry {get;set;}
    public String mobilePhone {get; set;}
    
    //==================================================
    // CONSTRUCTORS
    //==================================================    
    public cc_ctrl_SiteRegister(ApexPages.StandardController controller) { this(); }
    
    public cc_ctrl_SiteRegister () {
        super();
        sameasbilling = false;
        ipAddressLocation = Apexpages.currentPage().getParameters().get(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY);
        currentCartID=Apexpages.currentPage().getParameters().get('cartID');                   
        if(this.shipToAddress == null) {
            this.shipToAddress = new E_ContactAddr__c();
        }
        if(this.billToAddress == null) {
            this.billToAddress = new E_ContactAddr__c();
        }
        this.recaptchaChallenge = null;
        this.recaptchaResponse = null; 
        this.billCountry = 'US';
        this.shipCountry = 'US';
        department = ''; // Defaulting Department Name to None
        viewState = Apexpages.currentPage().getParameters().get('viewState');
        startUrl = Apexpages.currentPage().getParameters().get('startURL');
        currentCartID=Apexpages.currentPage().getParameters().get('cartID');
        currentProductId = Apexpages.currentPage().getParameters().get('productID');
        
        PageTitle = storefront.SEO_Title_Site__c + '  |  ' + storefront.SEO_Title_Detail__c;
        metaKeywords = storefront.SEO_Keywords__c;
        metaDescription = storefront.SEO_Description__c;
        System.debug('--- cc_ctrl_SiteRegister constructor: billCountry=' + billCountry + ', shipCountry=' + shipCountry);
        
        System.debug('--- cc_ctrl_SiteRegister apex pages post variable ship country =' + ApexPages.currentPage().getParameters().get('shipCountry') + ', billCountry=' + ApexPages.currentPage().getParameters().get('billCountry'));
        System.debug('--- cc_ctrl_SiteRegister apex pages parms:' + ApexPages.currentPage().getParameters());
             
        
        this.shippingStateOptions = cc_util_Picklist.getStateOptionsList(shipCountry);
        this.billingStateOptions = cc_util_Picklist.getStateOptionsList(billCountry);
        //initTestData();
    }
    
    //==================================================
    // HELPER METHODS
    //==================================================    
    public List<SelectOption> getStateOptionsUS(){
       return cc_util_Picklist.getStateOptionsList('US');
    }
     
    public List<SelectOption> getStateOptionsCanada(){
       return cc_util_Picklist.getStateOptionsList('CA');
    }
    
    private boolean isValidPassword() {
        //JLL debug code to get past SSO
        System.debug(LoggingLevel.INFO, 'KAPPERF Passwords = ' + password + ' === ' + confirmPassword);
        if(al.StringUtils.isEmpty(password) || al.StringUtils.isEmpty(confirmPassword)){
            //return false;
        }
        //return password == confirmPassword;
        return true;
    }
    
    public List<SelectOption> getLanguageOptions(){
        return cc_util_Picklist.getLanguageOptionsList(this.storefront);
    } 
   
    public List<SelectOption> getCountryOptions(){
       return cc_util_Picklist.getCountryOptionsList();
    }
    
    public List<SelectOption> getSalutation(){
        return cc_util_Picklist.getUserSalutations();
    }
    public List<SelectOption> getIndustry(){
        return cc_util_Picklist.getUserIndustries();
    }
    
    public List<SelectOption> getCompanyTypes(){
      return cc_util_Picklist.getCompanyTypes();
    }
    
    public List<SelectOption> getItems() {
        Account a = cc_util_CloudCraze.getAccountByName(storefront.Customer_Portal_Account_Name__c);
        //System.debug('--- adding account: Id=' + a.Id + ', Name=' + a.Name + ' ---');
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new Selectoption(a.Id, a.Name));
        
        return options;
    }

    public List<SelectOption> getContactTypeRole(){
        return cc_util_Picklist.getUserContactTypes();
    }
    private Boolean wasCartAnonymous;
    public String determineStartUrl(){
        wasCartAnonymous = true;
        //System.debug('Current Cart ID before Start URL'+currentCartID);
        if(currentCartID == null || currentCartID == ''){
            List<E_Cart__c> lastActiveCart  = cc_dao_Cart.getActiveCartOwnedByUserName(username);
            /*
            [Select EncryptedID__c 
                                                from E_Cart__c 
                                                where Owner.Username = :username 
                                                And ActiveCart__c = true 
                                                And isDeleted = false
                                               limit 1 ];
                                               */
            //System.debug('Last Active Cart List'+lastActiveCart);
            if(lastActiveCart != null && lastActiveCart.size() > 0){
                currentCartID = lastActiveCart[0].EncryptedID__c;
                wasCartAnonymous = false;
            }
        }
        PageReference startPageRef = System.Page.HomePage;
        
        if(viewState == 'wishlists'){
            startPageRef = System.Page.MyAccount;
            startPageRef.getParameters().put('viewstate', 'wishlists');
        }
        if(viewState == 'checkout'){
            startPageRef = System.Page.CheckOutNew;
            startPageRef.getParameters().put('viewstate', 'InfoView');
        }
        //System.debug('-----cc_ctrl_SiteRegister.determineStartUrl-startPage : ' + startPage);
        if(startUrl == null || startUrl == '') {
             startPageRef.getParameters().put('store', storefront.Name);
             startPageRef.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, ipAddressLocation);
             startPageRef.getParameters().put('cartID', currentCartID);
             startUrl = startPageRef.getUrl();
        }
            
        //System.debug('-----cc_ctrl_SiteRegister.determineStartUrl-startUrl : ' + startUrl);
    return startUrl;
    }
    public void cartProcessing(){
        List<User> loggedInUsers = [Select id from User where UserName = :username limit 1];
        User loggedinUser = null;
        if(loggedInUsers.size()>0){
            loggedinUser = loggedInUsers[0];
        }
        
        if(loggedinUser==null){
            return;
        }
        
        if(viewState != null && viewState == 'wishlists'){
                cc_api_Cart cc_api_Cart = new cc_api_Cart();
                cc_api_Cart.addToWishList(currentProductID, 1, loggedinUser.id);
            }
        if(currentCartID != null && currentCartID != '' && wasCartAnonymous){
                List<E_Cart__c> updateCart = new List<E_Cart__c>();
                
                List<E_Cart__c> activateCurrentCart = new List<E_Cart__C> {cc_dao_Cart.retrieveCartHeader(currentCartID)}; 
                /*
                [Select ActiveCart__c, OwnerId, Account__c, AnonymousID__c, EncryptedID__c from E_Cart__c where EncryptedID__c = :currentCartID];
                */
                if(activateCurrentCart != null && activateCurrentCart.size() > 0){
                    E_Cart__c thisCart = activateCurrentCart[0];
                    thisCart.ActiveCart__c = true;
                    thisCart.OwnerId = loggedinUser.Id;
                    thisCart.AnonymousID__c = false;
                    //thisCart.CartStatus__c = cc_util_CloudCraze.getIDByDecode('CartStatus', 'Open');
                    thisCart.CartStatus__c=cc_cnst_PickListConstants.CARTSTATUS_OPEN;
                    thisCart.Account__c = cc_util_CloudCraze.getAccountID();
                    updateCart.add(thisCart);
                        
                    
                }
                
                List<E_Cart__c> deactiveOldCart = cc_dao_Cart.getActiveCartOwnedBy(loggedinUser.Id);
                /*
                [Select EncryptedID__c, ActiveCart__c  from E_Cart__c where OwnerId = :loggedinUser.Id];
                */
                if(deactiveOldCart != null && deactiveOldCart.size() > 0){
                    for(E_Cart__c thisCart : deactiveOldCart){
                        if(thisCart.EncryptedID__c != currentCartID){
                            thisCart.ActiveCart__c = false;
                            updateCart.add(thisCart);
                        }
                        
                    }
                }
                
                    update updateCart;
                    
                    
                    
                }
    }
    
    private void validate(){
        if (!isValidPassword()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match));
        }
        if(al.StringUtils.isEmpty(this.firstName)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.AccountInformation_RequiredField_FirstName));
        }
        if(al.StringUtils.isEmpty(this.lastName)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.AccountInformation_RequiredField_LastName));
        }
        if(al.StringUtils.isEmpty(mobilePhone)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.AccountInformation_RequiredField_PrimaryPhoneNumber));
        }
        /* address book mod BEGIN by roy lou */
        /* Company Name & Type are required only if ecommerce type equals B2B */
        if((storefront.eCommerceType__c == cc_cnst_CloudCraze.ECommType_B2B) && al.StringUtils.isEmpty(this.companyName)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.AccountInformation_RequiredField_CompanyName));
        }
        if((storefront.eCommerceType__c == cc_cnst_CloudCraze.ECommType_B2B) && al.StringUtils.isEmpty(this.companyType)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.SiteRegistration_CompanyTypeRequired));
        }
        /* address book mod END by roy lou */
        if(al.StringUtils.isEmpty(this.language)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.AccountInformation_RequiredField_Language));
        }
        if(al.StringUtils.isEmpty(this.currencyCode)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.AccountInformation_RequiredField_Currency));
        }
        if(al.StringUtils.isEmpty(this.username)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.AccountInformation_RequiredField_UsernameEmail));
        }
        if( cc_svc_RecaptchaService.getInstance().enabled ){
            System.debug('recaptchaChallenge>>>>'+recaptchaChallenge);
            System.debug('recaptchaResponse>>>>'+recaptchaResponse);
            if(al.StringUtils.isBlank(recaptchaChallenge)|| al.StringUtils.isBlank(recaptchaResponse)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.SecurityCodeRequired));
            } else if(cc_svc_RecaptchaService.getInstance().isInvalidResponse(recaptchaChallenge,recaptchaResponse) //<-- and security code doesn't match
            ){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.SecurityCodesDoNotmatch)); 
            }
        }
        
      
        validateBillingAddress();
        validateShippingAddress();
    }
    
    private void validateBillingAddress(){
        if((('Please Select One'.equalsIgnoreCase(billState)) || 
           (al.StringUtils.isEmpty(billState)))  && (this.billingStateOptions!=null && this.billingStateOptions.size()>1)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.SiteRegistration_BillingStateRequired));
        }
        if(al.StringUtils.isEmpty(this.billPostalCode)  && al.StringUtils.equals('US',this.billCountry)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_RequiredField_BillingPostalCode));
        }
        if(al.StringUtils.isEmpty(this.billStreet1)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_RequiredField_BillingAddress1));
        }
        if(al.StringUtils.isEmpty(this.billCity)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_RequiredField_BillingCity));
        }
        if(al.StringUtils.isEmpty(this.billCountry)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_RequiredField_BillingCountry));
        }
    }
    
    private void validateShippingAddress(){
        if((('Please Select One'.equalsIgnoreCase(shipState)) || (al.StringUtils.isEmpty(shipState))) && (this.shippingStateOptions!=null && this.shippingStateOptions.size()>1)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.SiteRegistration_ShippingStateAddress));
        }
        if(al.StringUtils.isEmpty(this.shipPostalCode)  && al.StringUtils.equals('US',this.shipCountry)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_RequiredField_ShippingPostalCode));
        }
        if(al.StringUtils.isEmpty(this.shipStreet1)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_RequiredField_ShippingAddress1));
        }
        if(al.StringUtils.isEmpty(this.shipCity)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_RequiredField_ShippingCity));
        }
        if(al.StringUtils.isEmpty(this.shipCountry)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_RequiredField_ShippingCountry));
        }
        if(al.StringUtils.isEmpty(this.shipPostalCode)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_RequiredField_ShippingPostalCode));
        }   
    }
    
    //==================================================
    // SERVICE METHODS
    //==================================================    
     
     /**
     * Handles all processing for registering the user.  Includes validation, creation 
     * of user, account for user, user addresses and portal user with contact.
     */
    public PageReference registerUser() {
        validate();
        if (ApexPages.hasMessages(ApexPages.Severity.ERROR) && !Test.isRunningTest()) {
            System.debug('ryl error messages-->');
            System.debug(ApexPages.getMessages());
            return ApexPages.currentPage();
        }
        Savepoint sp = Database.setSavepoint();

        /*
        ********Begin Kaplan Customization***************
        ********Use PersonAccount************************
        */  

        /* Setup addresses */
        String shipCountryName = '';
        String billCountryName = '';
        for (SelectOption opt:this.getCountryOptions()) {
            if (this.shipCountry.equals(opt.getValue()))
                shipCountryName = opt.getLabel();
            if (this.billCountry.equals(opt.getValue()))
                billCountryName= opt.getLabel();
        }
        shipToAddress = buildContactAddresses(shipStreet1, shipStreet2, shipStreet3, shipCity, shipState, shipStateCA, shipStateText, shipCountry, shipCountryName, shipPostalCode, mobilePhone);
        billToAddress = buildContactAddresses(billStreet1, billStreet2, billStreet3, billCity, billState, billStateCA, billStateText, billCountry, billCountryName, billPostalCode, mobilePhone);
        List<E_ContactAddr__c> contactAddresses = new List<E_ContactAddr__c>();
        contactAddresses.add(shipToAddress);
        contactAddresses.add(billToAddress);
        
        /* Create the new user and new account for the user.  Then generate the portal user. 
            Once these are created, save the addresses so that the address book can be created. */
        //String accountId = createUserPersonalAccount(shipToAddress, billToAddress);
        System.debug('--- CCSiteRegisterContoller.registerUser: accountId=' + accountId);
        //String accountId = cc_util_CloudCraze.getAccountIdByName(storefront.Customer_Portal_Account_Name__c); //PORTAL_ACCOUNT_ID;
        //Account portalAccount = cc_util_CloudCraze.getAccountByName(storefront.Customer_Portal_Account_Name__c);
        //TODO JLL - refacor this query out into cc_util_CloudCraze, remove hard coding
        User owner = [select id from user where usertype = 'Standard' limit 1];     
        //System.debug('--- CCSiteRegisterContoller.registerUser: accountId=' + portalAccount.id);
        //userId = Site.createPortalUser(u, accountId, password);
        //createUser(cc_util_CloudCraze.getAccountIdByName(storefront.Customer_Portal_Account_Name__c));
        User u = createUser();

        /*
        * Kaplan - don't use createPortUser, but createPersonAccountPortalUser
        */
        //userId = Site.createPortalUser(u, portalAccount.id, password);
        userId = Site.createPersonAccountPortalUser(u, owner.id, password);
        
        if(userId != null) {
            System.debug('--- CCSiteRegisterContoller.registerUser: userId=' + userId);
            //change addresses' owner
            //shipToAddress.OwnerId = userId;
            //billToAddress.OwnerId = userId;
            insert contactAddresses;
            String shippingAddress = JSON.serialize(contactAddresses.get(0));
            String billingAddress = JSON.serialize(contactAddresses.get(1));
            //createPersonAccount(userId, shippingAddress, billingAddress, companyName, storefront.CustomerPortalAcctGroupName__c, storefront.eCommerceType__c, portalAccount.OwnerId);
            createPersonAccount(userId, shippingAddress, billingAddress, companyName, storefront.CustomerPortalAcctGroupName__c, storefront.eCommerceType__c, userId);
        }
        
      

        /* If the user is created, then determine the URL to redirect to, otherwise, rollback
            the transaction. */
        /*
        * Kaplan - customization. Send user info to Kaplan services. If that fails, also roll back
        */
        Boolean bKaplanIntegrationSuccess = cc_kap_api_services.sendCustomerInfoToKaplan(userId);
        PageReference page = null;
        if (userId != null) { 
            if (password != null && password.length() > 1) {
                startUrl = determineStartUrl();
                //Kaplan - don't even try to log them in if integration failed
                if(bKaplanIntegrationSuccess)
                    page = Site.login(username, password, startUrl);
                System.debug('--- cc_ctrl_SiteRegister.registerUser: page after login=' + page);
                if (page == null || !bKaplanIntegrationSuccess)
                    Database.rollBack(sp);
                else
                    cartProcessing();
            } else {
                page = system.page.CCSiteRegisterConfirm;
                //page = new PageReference('/apex/CCSiteRegisterConfirm');
                page.setRedirect(true);
                System.debug('--- cc_ctrl_SiteRegister.registerUser: register confirm page=' + page);
            }
        }
        return page;
    }
    
    /**
     * Constructs a contact address object using data supplied from the UI.
     * Logic to determine state code and country.  Returns the address.
     */
    private E_ContactAddr__c buildContactAddresses(String addr1, String addr2, String addr3, String city, String state, String stateCA, String stateText, String country, String countryName, String postal, String phone) {
        E_ContactAddr__c address = new E_ContactAddr__c();
        address.FirstName__c = this.firstName;
        address.LastName__c = this.lastName;
        address.AddressFirstline__c = addr1;
        address.AddressSecondline__c = addr2;
        address.AddressThirdline__c = addr3;
        address.City__c = city;
        address.PostalCode__c = postal;
        address.CompanyName__c = this.companyName;
        if (country == 'US')
            address.StateISOCode__c = state;
        else if (country == 'CA')
            address.StateISOCode__c = stateCA;
        else
            address.StateISOCode__c = stateText;
        address.CountryISOCode__c = country;
        address.Country__c = countryName;
        //address book mod BEGIN by roy
        address.DaytimePhone__c = phone;
        //address book mod END by roy
        return address;
    }
    
    
    public User createUser() {
        User u = new User();
        u.Username = username;
        u.Email = username;
        u.FirstName = firstname;
        u.LastName = lastName;
        u.CommunityNickname = username + String.valueOf(System.currentTimeMillis()/1000000);
        u.Department = department;
        u.Title = position_title;
        u.CompanyName = companyName;
        u.User_Salutation__c = userSalutation;
        u.User_Industry__c = userIndustry;
        u.ContactTypeRole__c = usercontactTypeRole;
        u.CC_CurrencyCode__c = currencyCode;
        u.LocaleSidKey = language;
        u.LanguageLocaleKey = cc_util_CustomSettings.getLanguageCodeByLocale(storefront, language);
        u.CompanyType__c = companyType;
        u.MobilePhone = mobilePhone;
        if (userinfo.isMultiCurrencyOrganization()) {
            sObject uObj = u;
            uObj.put('DefaultCurrencyIsoCode', currencyCode);
        }
        return u;
     }
     
    /*
    Salesforce categorizes objects into so called setup and non-setup objects. User is a setup object while Contact is a non-setup object. 
    Salesforce restricts DML operations so that both kinds of objects can't be manipulated in the same context.
    The workaround of this problem is placing DML code for conflicting object to a @future method.
    
    createPersonAccount is a future function that perform following tasks
        1. Create an account which will be tied to B2C portal user's contact
        2. Create shipping and billing address entries in address book for newly created account
    Note: for some reason, maybe undocumented feature, this newly created account's isCustomerPortal is set to true once
    it has been assigned to portal user's contact.
    */
    /*
    * Kaplan - following method has been modified to work with PersonAccount
    */
    @future 
    public static void createPersonAccount (Id userId, string shipping, string billing, string companyName, string portalAccountGroupName, string eCommerceType, Id ownedId) {
        try{
            E_ContactAddr__c shippingAddress = (E_ContactAddr__c) JSON.deserialize(shipping, E_ContactAddr__c.class);
            E_ContactAddr__c billingAddress = (E_ContactAddr__c) JSON.deserialize(billing, E_ContactAddr__c.class);
            //User u = [Select u.Username, u.Contact.IsPortalUser__c, u.Contact.FirstName, u.Contact.LastName, u.ContactId, u.Contact.id From User u where u.id = :userId];
            User u = [Select u.Username, u.AccountId, u.Contact.IsPortalUser__c, u.Contact.FirstName, u.Contact.LastName, u.ContactId, u.Contact.id From User u where u.id = :userId];
            //Account userAccount = new Account();
            String accountId = u.AccountId;
            Account userAccount = [Select a.E_AccountGroup__c from Account a where a.Id =: accountId];
            /* address book mod BEGIN by roy */
            /* Set account's name to company name if ecommerce type is B2B and companyname is not null/empty */
            /*
            if (eCommerceType == cc_cnst_CloudCraze.ECommType_B2B && companyName != null && companyName.length() > 1){
                userAccount.Name = companyName;
            } else {
                userAccount.Name = u.Contact.FirstName + ' ' + u.Contact.LastName;
                userAccount.Description = u.Username;
            }
            */
            /* address book mod END by roy */

            u.Contact.MailingStreet = userAccount.ShippingStreet = shippingAddress.AddressFirstline__c + ', ' + shippingAddress.AddressSecondline__c;
            u.Contact.MailingCity = userAccount.ShippingCity = shippingAddress.City__c;
            u.Contact.MailingState = userAccount.ShippingState = shippingAddress.StateISOCode__c;
            u.Contact.MailingPostalCode = userAccount.ShippingPostalCode = shippingAddress.PostalCode__c;
            u.Contact.MailingCountry = userAccount.ShippingCountry = shippingAddress.Country__c;
            u.Contact.OtherStreet = userAccount.BillingStreet = billingAddress.AddressFirstline__c + ', ' + billingAddress.AddressSecondline__c;
            u.Contact.OtherCity = userAccount.BillingCity = billingAddress.City__c;
            u.Contact.OtherState = userAccount.BillingState = billingAddress.StateISOCode__c;
            u.Contact.OtherPostalCode = userAccount.BillingPostalCode = billingAddress.PostalCode__c;
            u.Contact.OtherCountry = userAccount.BillingCountry = billingAddress.Country__c;
            u.Contact.Phone = shippingAddress.DaytimePhone__c;

            string log = cc_util_logging.debug('portalAccountGroupName=' + portalAccountGroupName);
            userAccount.E_AccountGroup__c = cc_util_CloudCraze.getAccountGroupIdByName(portalAccountGroupName);
            system.debug('userAccount.E_AccountGroup__c=' + userAccount.E_AccountGroup__c);
            //userAccount.OwnerId = ownedId;
            //insert userAccount;
            //update userAccount;
            //u.Contact.AccountId = userAccount.id;
            //update u.Contact;
        cc_api_AddressBook.createAddressBookEntries(userAccount.id, shippingAddress, billingAddress, userId);
        }
        finally 
        {
            
        }
    }
   
    
     /**
     * Redesigned to use the picklist utils to get this list.
     */
    public List<SelectOption> getCurrencyOptions() {
        return cc_util_Picklist.getCurrencyOptions(Schema.sObjectType.User.fields.getMap(), storefront);
    }
     
     
    public PageReference rerenderShippingStates(){
        this.shippingStateOptions = cc_util_Picklist.getStateOptionsList(shipCountry);
        return null;
    }
    
    public PageReference rerenderBillingStates(){
        this.billingStateOptions = cc_util_Picklist.getStateOptionsList(billCountry);
        return null;
    } 
     
     
    
}