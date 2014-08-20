public with sharing class OpportunityServices
{
	public static void populateTaxInformationLookup( List<Opportunity> incomingOpportunities )
	{
		Set<Id> accountIds = new Set<Id>();
		Set<String> zipCodes = new Set<String>();
		for( Opportunity anOpportunity : incomingOpportunities )
		{
			accountIds.add( anOpportunity.AccountId );
			zipCodes.add( anOpportunity.Shipping_Zip__c );
		}

		Map<Id, Account> accounts = new Map<Id, Account>([ SELECT Id, BillingPostalCode FROM Account WHERE Id IN :accountIds ]);
		for( Account anAccount : accounts.values() )
		{
			if( !String.isBlank( anAccount.BillingPostalCode ) )
			{
				anAccount.BillingPostalCode = anAccount.BillingPostalCode.left(5);
				zipCodes.add( anAccount.BillingPostalCode );
			}
		}

		Map<String, Id> taxInformationByName = new Map<String, Id>();
		for( Tax_Information__c aTaxInformation : [ SELECT Id, Name FROM Tax_Information__c WHERE Name IN :zipCodes ] )
		{
			taxInformationByName.put( aTaxInformation.Name, aTaxInformation.Id );
		}

		for( Opportunity anOpportunity : incomingOpportunities )
		{
			if( taxInformationByName.containsKey( anOpportunity.Shipping_Zip__c ) )
			{
				anOpportunity.Taxation_Zip_Code__c = taxInformationByName.get( anOpportunity.Shipping_Zip__c );
			}
			else if( accounts.containsKey( anOpportunity.AccountId ) )
			{
				anOpportunity.Taxation_Zip_Code__c = taxInformationByName.get( accounts.get(anOpportunity.AccountId).BillingPostalCode );
			}
		}
	}

	public static void touchOLIsOnShippingRateUpdate( Map<Id, Opportunity> incomingOpportunities, Map<Id, Opportunity> oldOpportunities )
	{
		List<Opportunity> changedOpportunities = new List<Opportunity>();
		for( Opportunity anOpportunity : incomingOpportunities.values() )
		{
			if( anOpportunity.Shipping_Rate__c != oldOpportunities.get( anOpportunity.Id ).Shipping_Rate__c
				|| anOpportunity.Shipping_Zip__c != oldOpportunities.get( anOpportunity.Id ).Shipping_Zip__c )
			{
				changedOpportunities.add( anOpportunity );
			}
		}

		if( !changedOpportunities.isEmpty() )
		{
			List<OpportunityLineItem> targetOLIs = [ SELECT Id, OpportunityId FROM OpportunityLineItem WHERE OpportunityId IN :changedOpportunities ];
			try
			{
				update targetOLIs;
			}
			catch( System.DmlException ex )
			{
				for( Integer errorIndex = 0; errorIndex < ex.getNumDml(); errorIndex++ )
				{
					Id errorId = targetOLIs[ ex.getDmlIndex(errorIndex) ].OpportunityId;
					incomingOpportunities.get( errorId ).addError( ex.getDmlMessage(errorIndex) );
				}
			}
		}
	}
}