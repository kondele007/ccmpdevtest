public with sharing class AccountServices
{
	public static final String MANUAL_ROWCAUSE = 'Manual';
	public static final List<Schema.SObjectField> LOOKUP_SHARE_FIELDS = new List<Schema.SObjectField>{ Account.Health_Program_Mngr__c,
																										Account.Regional_Acct_Dir__c,
																										Account.Regional_Med_Prog_Dir__c,
																										Account.Med_Program_Consultant__c };

	public static void updateAccountSharesForLookups( Map<Id, Account> incomingAccounts, Map<Id, Account> oldAccounts )
	{
		Map<Id, Set<Id>> accountToUsersToAdd = new Map<Id, Set<Id>>();
		Map<Id, Set<Id>> accountToUsersToRemove = new Map<Id, Set<Id>>();
		Set<Id> allUserIds = new Set<Id>();
		for( Account anAccount : incomingAccounts.values() )
		{
			Set<Id> presentIds = new Set<Id>();
			Set<Id> removedIds = new Set<Id>();
			for( Schema.SObjectField aField : LOOKUP_SHARE_FIELDS )
			{
				String fieldName = aField.getDescribe().getName();

				if( anAccount.get(fieldName) == null &&
					oldAccounts != null && oldAccounts.get(anAccount.Id).get(fieldName) != null )
				{
					removedIds.add( (Id)oldAccounts.get(anAccount.Id).get(fieldName) );
				}
				else if( oldAccounts != null &&
						anAccount.get(fieldName) != oldAccounts.get(anAccount.Id).get(fieldName) )
				{
					presentIds.add( (Id)anAccount.get(fieldName) ); // will need to add new id
					removedIds.add( (Id)oldAccounts.get(anAccount.Id).get(fieldName) ); // will need to remove old id
				}
				else if( anAccount.get(fieldName) != null )
				{
					presentIds.add( (Id)anAccount.get(fieldName) );
				}
			}
			removedIds.removeAll( presentIds ); // do not remove any ids that are going to be added anyway
			allUserIds.addAll( presentIds );
			allUserIds.addAll( removedIds );

			accountToUsersToAdd.put( anAccount.Id, presentIds );
			accountToUsersToRemove.put( anAccount.Id, removedIds );
		}

		if( !allUserIds.isEmpty() )
		{
			Map<Id, Map<Id, AccountShare>> accountToExistingShares = new Map<Id, Map<Id, AccountShare>>();
			for( AccountShare aShare : [ SELECT Id, AccountId, UserOrGroupId FROM AccountShare
										WHERE UserOrGroupId IN :allUserIds AND AccountId IN :incomingAccounts.keySet() AND RowCause = :MANUAL_ROWCAUSE ] )
			{
				if( !accountToExistingShares.containsKey( aShare.AccountId ) )
				{
					accountToExistingShares.put( aShare.AccountId, new Map<Id, AccountShare>() );
				}
				accountToExistingShares.get( aShare.AccountId ).put( aShare.UserOrGroupId, aShare );
			}

			List<AccountShare> sharesToCreate = new List<AccountShare>();
			List<AccountShare> sharesToDelete = new List<AccountShare>();
			for( Account anAccount : incomingAccounts.values() )
			{
				Map<Id, AccountShare> existingShares = accountToExistingShares.get( anAccount.Id );
				for( Id newId : accountToUsersToAdd.get( anAccount.Id ) )
				{
					if( existingShares == null || !existingShares.containsKey( newId ) )
					{
						AccountShare newShare = new AccountShare();
						newShare.AccountId = anAccount.Id;
						newShare.UserOrGroupId = newId;
						newShare.AccountAccessLevel = 'Edit';
						newShare.OpportunityAccessLevel = 'Read';
						sharesToCreate.add( newShare );
					}
				}
				for( Id oldId : accountToUsersToRemove.get( anAccount.Id ) )
				{
					if( existingShares != null && existingShares.containsKey( oldId ) )
					{
						sharesToDelete.add( existingShares.get( oldId ) );
					}
				}
			}

			System.Savepoint sp = Database.SetSavePoint();
			try
			{
				insert sharesToCreate;
				try
				{
					delete sharesToDelete;
				}
				catch( System.DmlException ex )
				{
					Database.rollback( sp );
					for( Integer errorIndex = 0; errorIndex < ex.getNumDml(); errorIndex++ )
					{
						incomingAccounts.get( sharesToDelete[errorIndex].AccountId ).addError( ex.getDmlMessage( errorIndex ) );
					}
				}
			}
			catch( System.DmlException ex )
			{
				for( Integer errorIndex = 0; errorIndex < ex.getNumDml(); errorIndex++ )
				{
					incomingAccounts.get( sharesToCreate[errorIndex].AccountId ).addError( ex.getDmlMessage( errorIndex ) );
				}

			}
		}
	}
}