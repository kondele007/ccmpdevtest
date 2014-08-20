@isTest
private class cc_ctrl_SpecificationsTabTest {

    static testMethod void testProductFormSetter() {
    	cc_test_PrepTestData.loadAllCustomSettings();
        cc_ctrl_SpecificationsTab controller = new cc_ctrl_SpecificationsTab();
        cc_bean_ProductForm productForm = new cc_bean_ProductForm();
        
        E_Product__c product = 
          new E_Product__c(
            Sku__c='test123459876',
            ProductStatus__c = cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED
          );
        insert product;
        
        List<E_Spec__c> specs = new List<E_Spec__c>();
        specs.add(new E_Spec__c(DisplayName__c='Apple',SpecGroup__c='Fruit',Locale__c='en_US'));
        specs.add(new E_Spec__c(DisplayName__c='Orange',SpecGroup__c='Fruit',Locale__c='en_US'));    
        specs.add(new E_Spec__c(DisplayName__c='Broccoli',SpecGroup__c='Vegetables',Locale__c='en_US'));
        insert specs;
      
        List<E_ProductSpecIndex__c> specIdxes= new List<E_ProductSpecIndex__c>();
        specIdxes.add(
          new E_ProductSpecIndex__c(
            Spec__c = specs.get(0).id,
            SpecValue__c='Red Delicious',
            Product__c = product.Id,
            ProductSpecIndexId__c = 'test9876'
          )
        );
        specIdxes.add(
          new E_ProductSpecIndex__c(
            Spec__c = specs.get(1).id,
            SpecValue__c='Clementine',
            Product__c = product.Id,
            ProductSpecIndexId__c = 'test4321'
          )
        );
        specIdxes.add(
          new E_ProductSpecIndex__c(
            Spec__c = specs.get(2).id,
            SpecValue__c='Sprouts',
            Product__c = product.Id,
            ProductSpecIndexId__c = 'test1234'
          )
        );
        insert specIdxes;
        
        cc_dao_Product dao = new cc_dao_Product();
        List<E_Product__c> products = dao.readProduct('test123459876');
        
        System.assert(products.size()>0);
        product = products.get(0);
        
        productForm.product = new cc_bean_Product(product);
        controller.productForm = productForm;
        
        //System.assertEquals(2,controller.specGroups.keySet().size());
        //System.assertEquals(2,controller.specGroups.get('Fruit').size());
        //System.assertEquals(1,controller.specGroups.get('Vegetables').size());
        //System.assertEquals('Apple',controller.specGroups.get('Fruit').get(0).specName);
        //System.assertEquals('Red Delicious',controller.specGroups.get('Fruit').get(0).specValue);        
    }
}