public class cc_hlpr_BundleProduct extends cc_hlpr_CompositeProductHelperBase {
	//==================================================
    // DERIVED METHODS
    //==================================================
    public override Decimal calAggregatedPrice(E_CartItem__c item)
	{ 
		//use aggregated extended price
		Decimal ret = 0.0;
		ret = item.SubAmount__c;
		return ret; 
	}
	public override void addComponentProductsToCart(E_CartItem__c majorItem, ID accountID, Date targetDate, 
		String currencyCode, String customerType, Boolean fillPrice, Map<String, String> selectedAggregate) {
		Id pId = majorItem.Product__c;
		List<E_CompositeProduct__c> bps = [Select e.Quantity__c, e.Optional__c, e.Name, e.Id, e.Component__r.UnitOfMeasure__c, e.Composite__r.UnitOfMeasure__c, e.Component__r.ProductType__c,
				e.Component__c, e.Component__r.sku__c, e.Component__r.name, e.Component__r.ShortDesc__c, e.Category__c, e.Category__r.name, e.Composite__c, e.Composite__r.sku__c , 
				e.Composite__r.name From E_CompositeProduct__c e where e.Composite__c = :pId and e.Optional__c = false];
		List<E_CartItem__c> cartItemList = new List<E_CartItem__c>();
		for(E_CompositeProduct__c bp : bps)
		{
			E_CartItem__c ci = new E_CartItem__c();
			ci.StoreId__c = majorItem.StoreID__c;
            ci.Cart__c=majorItem.Cart__c;
            ci.price__c = 0.0;
            ci.cartItemType__c='Minor';
            ci.Product__c = bp.Component__c;
            if(bp.Component__r.ProductType__c == 'Aggregated')
			{
				ci.Product__c = selectedAggregate.get(bp.Component__c);
			}
            ci.Category__c = bp.category__c;
            ci.Quantity__c = bp.Quantity__c;                
            ci.RequestDate__c = Date.today();
            ci.SubAmount__c =  0.0;
            ci.SubAmount__c = ci.SubAmount__c.setScale(2, System.RoundingMode.UP);
            ci.UnitOfMeasure__c = bp.Component__r.UnitOfMeasure__c;
            ci.ParentCartItem__c=majorItem.Id;
            cartItemList.add(ci);
		}
		insert cartItemList;
	}
}