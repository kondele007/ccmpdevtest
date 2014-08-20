public class CreateImplementationController
{
    private Opportunity detailOpp;
    private Account acc;
    private List<Deliverable_Product__c> delvProdObjs = new List<Deliverable_Product__c>();
    private ApexPages.StandardController standardCont;
    public List<Id> productId2List = new List<String>();
    public Set<String> controlIdList = new Set<String>();

    public CreateImplementationController(ApexPages.StandardController stdController)
    {
        if( !Test.isRunningTest() )
        {
            stdController.addFields( new List<String>(OpportunityToImplementationFields__c.getAll().keySet()) );
        }
        this.detailOpp = (Opportunity) stdController.getRecord();
        this.acc = [ SELECT Id, BillingState, Region__c FROM Account WHERE Id = :this.detailOpp.AccountId ];
        this.standardCont = stdController;
    }

    public PageReference createImplementation()
    {
        Id ownerId = getOwnerId(acc);
        if(detailOpp != null)
        {
            Implementation__c newImplObj = new Implementation__c();

            newImplObj.Opportunity__c = detailOpp.Id;
            newImplObj.Implementation_Contact_Name__c = String.isBlank(detailOpp.Implementation_Contact__c) ? '' : detailOpp.Implementation_Contact__c.escapeHtml4();
            newImplObj.Account__c = detailOpp.AccountId;
            if(ownerId != null)
            {
                newImplObj.OwnerId = ownerId;
            }
            else
            {
                newImplObj.OwnerId = UserInfo.getUserId();
            }
            newImplObj.Region__c = acc.Region__c;
            newImplObj.P_O__c = String.isBlank(detailOpp.P_O__c) ? '' : detailOpp.P_O__c.escapeHtml4();
            newImplObj.CloseDate__c = detailOpp.CloseDate;

            Map<String, OpportunityToImplementationFields__c> mappingSettings = OpportunityToImplementationFields__c.getAll();
            Map<String, Schema.SObjectField> opportunityFields = Schema.SobjectType.Opportunity.fields.getMap();
            Map<String, Schema.SObjectField> implementationFields = Schema.SobjectType.Implementation__c.fields.getMap();
            for( OpportunityToImplementationFields__c aSetting : mappingSettings.values() )
            {
                if( opportunityFields.containsKey( aSetting.Name )
                    && !String.isBlank( aSetting.Implementation_Field__c )
                    && implementationFields.containsKey( aSetting.Implementation_Field__c ) )
                {
                    newImplObj.put( aSetting.Implementation_Field__c, detailOpp.get( aSetting.Name ) );
                }
            }

            newImplObj.Service_Notes__c = String.isBlank(detailOpp.Service_Notes__c) ? '' : detailOpp.Service_Notes__c.escapeHtml4();
            newImplObj.Implementation_Contact_Title__c = String.isBlank(detailOpp.Implementation_Title__c) ? '' : detailOpp.Implementation_Title__c.escapeHtml4();
            newImplObj.Implementation_Contact_Email__c = detailOpp.Implementation_Email__c;
            newImplObj.Implementation_Contact_Phone__c = detailOpp.Implementation_Phone__c;
            newImplObj.K12_Order_ID__c = String.isBlank(detailOpp.K12_Order_ID__c) ? '' : detailOpp.K12_Order_ID__c.escapeHtml4();

            newImplObj.Name = (detailOpp.Implementation_Name__c + '-' + System.now().format('MM/dd/yyyy')).escapeHtml4();
            insert newImplObj;

            createTasks(newImplObj);
            createDeliverableProducts(detailOpp.Id, newImplObj.Id);
            buildControlIds();
            createDeliverables(newImplObj.Id, newImplObj.OwnerId);

            return new PageReference('/' + newImplObj.Id);
        }
        return this.standardCont.view();
    }

    private void createTasks(Implementation__c implObj)
    {
        Task tskObj = new Task();
        tskObj.Subject = 'New Implementation Assigned';
        tskObj.WhatId = implObj.id;
        tskObj.OwnerId = implObj.OwnerId;
        tskObj.ActivityDate = Date.today();
        insert tskObj;
    }

    private void createDeliverables(String implId, String ownId)
    {
        List<Deliverables__c> delvObjs = new List<Deliverables__c>();

        if(controlIdList.size() > 0)
        {
            for(String typeControlId: controlIdList)
            {
                Deliverables__c delvObj = new Deliverables__c();
                delvObj.Type_Control__c = typeControlId;
                delvObj.Implementation__c = implId;
                delvObj.OwnerId = ownId;
                delvObjs.add(delvObj);
            }
            insert delvObjs;
        }

        //populate deliverableobjects with deliverable Ids
        if(delvObjs.size() > 0)
        {
            for(Deliverables__c delvObj: delvObjs)
            {
                for(Deliverable_Product__c dpObj: delvProdObjs)
                {
                    if(delvObj.Type_Control__c == dpObj.Type_Control__c)
                    {
                        dpObj.Deliverables__c = delvObj.id;
                    }

                }
                createDeliverableTasks(delvObj.Type_Control__c, delvObj.id, implId);
            }
            insert delvProdObjs;
        }
    }

    private void createDeliverableProducts(String oppId, String implId)
    {
        OpportunityLineItem[] oppLineItems = [Select Id, PricebookEntry.Product2Id, Quantity From OpportunityLineItem where OpportunityId = : this.detailOpp.Id];

        if(oppLineItems != null && oppLineItems.size() > 0)
        {
            Set<Id> productIds = new Set<Id>();
            for(OpportunityLineItem anOLI : oppLineItems)
            {
                productIds.add(anOLI.PricebookEntry.Product2Id);
            }

            Map<Id, String> typeControlMap = getTypeControlIdForProductMap(productIds); //retrieving all type control ids

            for(OpportunityLineItem opliObj: oppLineItems)
            {
                if(typeControlMap.containsKey(opliObj.PricebookEntry.Product2Id))
                {
                    Deliverable_Product__c dpcObj = new Deliverable_Product__c();

                    dpcObj.Implementation__c = implId;
                    dpcObj.Quantity__c = opliObj.Quantity;
                    dpcObj.Product2__c = opliObj.PricebookEntry.Product2Id;
                    dpcObj.Type_Control__c = typeControlMap.get(dpcObj.Product2__c);

                    delvProdObjs.add(dpcObj);
                    productId2List.add(dpcObj.Product2__c);
                }
            }
        }
    }

    private void createDeliverableTasks(String typeControlId, String deliverableId, String ImplementationId)
    {
        List<Deliverable_Tasks__c>  delivTasks = new List<Deliverable_Tasks__c>();

        String status = 'Not Started';

        Task_Control__c[] taskControlObjs = [Select Id, Name, Sequence__c From Task_Control__c where Type_Control__c = : typeControlId];
        if(taskControlObjs != null && taskControlObjs.size() > 0)
        {
            for(Task_Control__c tccObj: taskControlObjs)
            {
                Deliverable_Tasks__c dtask = new Deliverable_Tasks__c();
                dtask.Name = tccObj.Name;
                dtask.Sequence__c = tccObj.Sequence__c;
                dtask.Deliverables__c = deliverableId;
                dtask.Implementation__c = implementationId;
                dtask.Status__c = status;

                delivTasks.add(dtask);
            }
            insert delivTasks;
        }
    }

    private Id getOwnerId(Account acc)
    {
        List<Territory_Control__c> trc = [Select User__c From Territory_Control__c where Name = : acc.BillingState];
        if( !trc.isEmpty() )
        {
            return trc[0].User__c;
        }
        else
        {
            throw new CreateImplementationException('There is no Territory control record for the account billing state: ' + acc.BillingState);
        }
    }

    private Map<Id, String> getTypeControlIdForProductMap(Set<Id> productIds)
    {
        Map<Id, String> typeControlMap = new Map<Id, String>();
        Product2[] pd2s = [Select Id, Type_Deliverable__c From Product2 where Id IN :productIds];
        if(!pd2s.isEmpty())
        {
            Set<String> deliverableTypes = new Set<String>();
            for(Product2 pd2Obj: pd2s)
            {
                deliverableTypes.add(pd2Obj.Type_Deliverable__c);
            }

            Map<String, Type_Control__c> typeDeliverableToTypeControl = new Map<String, Type_Control__c>();
            for( Type_Control__c aTypeControl : [Select Id, Name From Type_Control__c where Name IN :deliverableTypes] )
            {
            	typeDeliverableToTypeControl.put( aTypeControl.Name, aTypeControl );
            }

            if(!typeDeliverableToTypeControl.isEmpty())
            {
                for(Product2 pd2Obj: pd2s)
                {
                    if( typeDeliverableToTypeControl.containsKey( pd2Obj.Type_Deliverable__c ) )
                    {
                    	Type_Control__c tccObj = typeDeliverableToTypeControl.get( pd2Obj.Type_Deliverable__c );
                        String typeControlId = String.valueOf(tccObj.Id).substring(0, 15);
                        typeControlMap.put(pd2Obj.Id, typeControlId);
                    }
                    else
                    {
                        throw new CreateImplementationException('There is no Type Control Id for product Id ' + pd2Obj.Id);
                    }
                }
            }
        }
        return typeControlMap;
    }

    private void buildControlIds()
    {
        if( !productId2List.isEmpty() )
        {
            Map<Id, String> controlListMap = getTypeControlIdForProductMap(new Set<Id>(productId2List));
            controlIdList.addAll( controlListMap.values() );
        }
    }

    public class CreateImplementationException extends Exception{}
}