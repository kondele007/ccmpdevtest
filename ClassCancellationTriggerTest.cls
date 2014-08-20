@isTest
public class ClassCancellationTriggerTest{
   
  static testMethod void Setupdata(){
        //Create and Account/Enrollment/CC Product..
      /******Account Creation****/
      String Specvalue=Label.Specid;
      if( Kaplan_Custom_Config__c.getInstance('Kaplan Custom Config') == null )
        {
            Kaplan_Custom_Config__c newCustomSetting = new Kaplan_Custom_Config__c();
            newCustomSetting.Name = 'Kaplan Custom Config';
            newCustomSetting.ETL_Load_Username__c = 'someusername';
            System.runAs( KapTestUtil.ADMIN_USER )
            {
                insert newCustomSetting;
            }
        }    
      
     Recordtype accntRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SobjectType='Account' LIMIT 1];
       Account acc = new Account();
           acc.FirstName='TestFirst';
           acc.LastName='TestLast';
           acc.RecordTypeId=accntRecordType.Id;
        insert acc;   
      /*****Enrollment Creation****/  
      Enrollment__c enroll = new Enrollment__c(Enrollment_Id__c='99999999',Account__c=acc.id,Status__c='Active',Class_Code__c='GATON');
        insert enroll;
      System.debug('The value of Enroll is'+enroll);
      /*****CCproduct Creation****/
      Date StartDate = Date.newInstance(2013, 10, 1);
      Date EndDate= Date.newInstance(2014, 10, 1);
      E_Product__c CCProd = new E_Product__c(Name='Test Prod',Code__c='GATON',SKU__c='SRP1000',Quantityperunit__c=1,StartDate__c= StartDate,EndDate__c=EndDate,ProductStatus__c='In Creation'); 
        insert CCProd;
      /*********CCSpec Creation******/
    //  E_Spec__c testSpec = new E_Spec__c(Name='Test Spec',DisplayName__c='SBU',Locale__c='en_US');
    //    insert testSpec;
        /********CCProduct Spec ******/
      E_ProductSpec__c Eps= new E_ProductSpec__c(Product__c=CCProd.id,Spec__c=Specvalue,SpecValue__c='3');
        insert Eps;
      /********CCProduct Spec Index******/
      E_ProductSpecIndex__c psi= new E_ProductSpecIndex__c(Product__c=CCProd.id,ProductSpecIndexId__c='TestA1',Spec__c=Specvalue,SpecValue__c='3');
        insert psi;
      /*********CCCategory******/
      E_Category__c cat = new E_Category__c(Name='GATON Event',CategoryID__c='Txt100',StartDate__c=StartDate,EndDate__c=EndDate,Sequence__c=4501);
       insert cat;
      /********CC Product Category(Junction Object for CCProduct ad CCCategory)*******/
      E_ProductCategory__c pcat=new E_ProductCategory__c(Category__c=cat.id,Product__c=CCProd.id,StartDate__c=StartDate,EndDate__c=EndDate);
      insert pcat;
      System.debug('The value of CCProd is'+CCprod);
      
      //Query for Inserted Product and Update the CC Product Details..
      E_Product__c CCProdDb=[Select Id,Code__c from E_Product__c where Code__c='GATON'];
      System.debug('The value of CCProdDb is'+CCprodDb);
    if(CCProdDb!=Null){
      Test.startTest();
          CCProdDb.ProductStatus__c='Cancelled';
          Update CCProdDb;
      System.debug('The value of CCProdDb AfterUpdate is'+CCprodDb);
     Test.stopTest();
      }
          
    }
}