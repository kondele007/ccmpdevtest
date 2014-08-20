//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_hlpr_InitDataSet {
	public static void initialize()
	{
		/*
		delete [Select e.Id From E_AccountGroupPriceList__c e LIMIT 2000];
		delete [Select e.Id From E_PriceList__c e LIMIT 2000];
	  	delete [Select a.Id From Account a where name in ('PortalAccount','Anonymous')];
		delete [Select e.Id From E_AccountGroup__c e LIMIT 2000];
        */
	}

    public static void loadAccountGroup()
    {
    	cc_api_dl_accountGroups accountGroups = new cc_api_dl_accountGroups();
    	accountGroups.loadData();
    	/*
    	List<E_AccountGroup__c> accountgroupList=[Select a.Id From E_AccountGroup__c a where name in ('PortalAccount','Anonymous')];
    	if(Test.isRunningTest()) {
    		delete accountgroupList;
    		accountgroupList = null;
    	}
    	if(accountgroupList==null || accountgroupList.size()==0){
	        List<E_AccountGroup__c> accountGroups = new List<E_AccountGroup__c>();
	        accountGroups.add(new E_AccountGroup__c(Name='PortalAccount', ACCOUNTGROUPID__C='1', PriceListSelectionMethod__c='Best Price'));
	        accountGroups.add(new E_AccountGroup__c(Name='Anonymous', ACCOUNTGROUPID__C='2', PriceListSelectionMethod__c='Best Price'));
	        insert accountGroups;
	    }
	    */
    }

/*
	public static void loadAccountGroup()
	{
		List<E_AccountGroup__c> accountGroups = new List<E_AccountGroup__c>();
		PageReference pr = new PageReference('/resource/' + cc_util_CloudCraze.localNamespace + 'CC_Data/InitData/AccountGroup.xml');
  		Blob content = pr.getContent(); 
  		Dom.Document doc = new Dom.Document();
		doc.load(content.toString());
		dom.XmlNode rootNode = doc.getRootElement();
		List<dom.XmlNode> children = rootNode.getChildElements();
		for(dom.XmlNode node : children)
		{
			dom.XmlNode nameNode = node.getChildElement('NAME', null);
			//System.debug('---------------loadAccountGroup------------------' + nameNode.getText());
			if(nameNode != null)
		 	{
		 		dom.XmlNode valueNode = node.getChildElement('ACCOUNTGROUPID__C', null);
		 		if(valueNode != null)
		 		{
		 			//System.debug('---------------loadAccountGroup------------------' + valueNode.getText());
		 			accountGroups.add(new E_AccountGroup__c(Name=nameNode.getText(), ACCOUNTGROUPID__C=valueNode.getText()));
		 		}
		 	}
		 	
		 }
		 insert accountGroups;
	}
*/	

    public static void loadAccount()
    {
    	cc_api_dl_accounts accounts = new cc_api_dl_accounts();
    	accounts.loadData();    	
    	
    }

/*
	public static void loadAccount()
	{
		List<Account> accounts =  [Select a.Id From Account a where name in ('PortalAccount','Anonymous')];
		if(accounts.size() == 0)
		{
			accounts = new List<Account>();
			PageReference pr = new PageReference('/resource/' + cc_util_CloudCraze.localNamespace + 'CC_Data/InitData/Account.xml');
	  		Blob content = pr.getContent(); 
	  		Dom.Document doc = new Dom.Document();
			doc.load(content.toString());
			dom.XmlNode rootNode = doc.getRootElement();
			List<dom.XmlNode> children = rootNode.getChildElements();
			for(dom.XmlNode node : children)
			{
				dom.XmlNode nameNode = node.getChildElement('NAME', null);
				if(nameNode != null)
			 	{
			 		dom.XmlNode valueNode = node.getChildElement('accountgroupid', null);
			 		if(valueNode != null)
			 		{
			 			E_AccountGroup__c ag = new E_AccountGroup__c(ACCOUNTGROUPID__c = valueNode.getText());
			 			accounts.add(new Account(Name=nameNode.getText(), E_ACCOUNTGROUP__r=ag));
			 		}
			 	}
			 	
			 }
			 insert accounts;
		}
	}
*/

    public static void loadPriceList()
    {
    	cc_api_dl_priceLists priceLists = new cc_api_dl_priceLists();
    	priceLists.loadData();
    	/*
    	if(Test.isRunningTest())
    	{
    		delete [select id from E_PriceList__c where Name in ('PortalAccount', 'Enterprise')];
    	}
    	List<E_PriceList__c> priceLists = new List<E_PriceList__c>();

        priceLists.add(new E_PriceList__c(Name='PortalAccount', Desc__c='PortalAccount Price List', CustomerTypeCode__c='General',
                            CurrencyISOCode__c='USD', PricelistId__c='1'));

        priceLists.add(new E_PriceList__c(Name='Enterprise', Desc__c='Enterprise Price List', CustomerTypeCode__c='General',
                            CurrencyISOCode__c='USD', PricelistId__c='2'));

        insert priceLists;
        */
    }

/*
	public static void loadPriceList()
	{
		List<E_PriceList__c> priceLists = new List<E_PriceList__c>();
		PageReference pr = new PageReference('/resource/' + cc_util_CloudCraze.localNamespace + 'CC_Data/InitData/PriceList.xml');
  		Blob content = pr.getContent(); 
  		Dom.Document doc = new Dom.Document();
		doc.load(content.toString());
		dom.XmlNode rootNode = doc.getRootElement();
		List<dom.XmlNode> children = rootNode.getChildElements();
		for(dom.XmlNode node : children)
		{
			dom.XmlNode nameNode = node.getChildElement('NAME', null);
			if(nameNode != null)
		 	{
		 		dom.XmlNode currencyCodeNode = node.getChildElement('CURRENCYISOCODE__C', null);
		 		dom.XmlNode customerTypeNode = node.getChildElement('CUSTOMERTYPECODE__C', null);
		 		dom.XmlNode DescriptionNode = node.getChildElement('DESC__C', null);
		 		dom.XmlNode priceListIdNode = node.getChildElement('PRICELISTID__C', null);
		 				
		 		priceLists.add(new E_PriceList__c(Name=nameNode.getText(), Desc__c=DescriptionNode.getText(),
		 							CustomerTypeCode__c = customerTypeNode.getText(), CurrencyISOCode__c = currencyCodeNode.getText(),
		 							PricelistId__c = priceListIdNode.getText()));
		 	}
		 	
		 }
		 insert priceLists;
	}
*/

    public static void loadAccountGroupPriceList()
    {
    	cc_api_dl_accountGroupPriceLists accountGrpPricelists = new cc_api_dl_accountGroupPriceLists();
    	accountGrpPricelists.loadData();    	
    	/*
        List<E_AccountGroupPriceList__c> priceLists = new List<E_AccountGroupPriceList__c>();

        E_PriceList__c pl = new E_PriceList__c(PricelistId__c='1');
        E_AccountGroup__c ag = new E_AccountGroup__c(AccountGroupID__c='1');
        priceLists.add(new E_AccountGroupPriceList__c(Pricelist__r = pl, AccountGroup__r = ag, Sequence__c=500));

        ag = new E_AccountGroup__c(AccountGroupID__c='2');
        priceLists.add(new E_AccountGroupPriceList__c(Pricelist__r = pl, AccountGroup__r = ag, Sequence__c=500));

        pl = new E_PriceList__c(PricelistId__c='2');
        ag = new E_AccountGroup__c(AccountGroupID__c='1');
        priceLists.add(new E_AccountGroupPriceList__c(Pricelist__r = pl, AccountGroup__r = ag, Sequence__c=500));

        ag = new E_AccountGroup__c(AccountGroupID__c='2');
        priceLists.add(new E_AccountGroupPriceList__c(Pricelist__r = pl, AccountGroup__r = ag, Sequence__c=500));

        insert priceLists;
        */
    }

/*
	public static void loadAccountGroupPriceList()
	{
		List<E_AccountGroupPriceList__c> priceLists = new List<E_AccountGroupPriceList__c>();
		PageReference pr = new PageReference('/resource/' + cc_util_CloudCraze.localNamespace + 'CC_Data/InitData/AccountGroupPriceList.xml');
  		Blob content = pr.getContent(); 
  		Dom.Document doc = new Dom.Document();
		doc.load(content.toString());
		dom.XmlNode rootNode = doc.getRootElement();
		List<dom.XmlNode> children = rootNode.getChildElements();
		for(dom.XmlNode node : children)
		{
			dom.XmlNode accountGroupNode = node.getChildElement('ACCOUNTGROUP__C', null);
			dom.XmlNode priceListNode = node.getChildElement('PRICELIST__C', null);
			dom.XmlNode sequenceNode = node.getChildElement('SEQUENCE__C', null);
			//System.debug('accountGroupNode------------------------------>' + accountGroupNode.getText());
			//System.debug('priceListNode------------------------------>' + priceListNode.getText());
			//System.debug('sequenceNode------------------------------>' + sequenceNode.getText());
			E_PriceList__c pl = new E_PriceList__c(PricelistId__c = priceListNode.getText());
		 	E_AccountGroup__c ag = new E_AccountGroup__c(AccountGroupID__c = accountGroupNode.getText());	
		 	E_AccountGroupPriceList__c agpl = new E_AccountGroupPriceList__c(Sequence__c=Decimal.valueOf(sequenceNode.getText()), Pricelist__r = pl,
		 					AccountGroup__r = ag);		
		 	priceLists.add(agpl);	
		 }
		 insert priceLists;
	}
*/


}