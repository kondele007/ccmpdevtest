/**
// * @Description: Contorller to handle punch-in to the cart and add to cart from external sites.
// * @Author: 1.0
// * @File: cc_kap_ctrl_PunchIn
// * =======================================================================================
// * 2012/08/13 1.1 IL -  Created
// **/
public without sharing class cc_kap_ctrl_PunchIn extends cc_ctrl_CloudCraze {
    public boolean isFreeEvent { get; set; }
    public boolean shippable { get; set; }
    public String programCode { get; set; }
    public String currentCartId {get; set; }
    
    /*
     * Instantiates/setups all necessary objects and settings.
     */
    public cc_kap_ctrl_PunchIn() {
        super();
    }
    
    /*
     * Handles the punch in action from an external site.  The
     * external site passes the sku or list of skus via the url, and 
     * this will add this and then redirect to the cart page.  If no 
     * skus provided, will redirect to cart page without adds.
     */
    public PageReference punchIn() {
        String punchInProduct = ApexPages.currentPage().getParameters().get('punchInProductId');
        String currCartId = cc_kap_utils_AppUtils.retrieveCookie(cc_kap_utils_AppConstants.COOKIE_CURR_CART_ID);
        boolean cartContainsProduct = false;
        String currProdId;
        boolean isAddtoCart = false;
        Set<String> nonOrderables = new Set<String>();
        Set<String> invalidSkus = new Set<String>();
        String miscError;
        String lastSKUAdded;
        String lastProductAdded;
        isFreeEvent = false;
        List<E_Product__c> addedProducts = new List<E_Product__c>();
        if (!al.StringUtils.isBlank(punchInProduct)) {
            isAddtoCart = true;
            currProdId = punchInProduct;
            cc_api_Cart cc_api_Cart = new cc_api_Cart();
            List<String> skuList = al.StringUtils.split(currProdId, ',');
            Set<String> foundSkuList = new Set<String>();
            List<E_Product__c> productList = cc_dao_Product.readProductForStore(skuList, cc_util_Locale.getUserLanguage(), storefront.Name);
            for (E_Product__c product: productList) {
                if (product.ProductStatus__c == cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED){
                    try {
                        if(currCartId != null)
                            cartContainsProduct = cc_kap_utils_Cart.cartContainsProduct(currCartId, product.Id, product.ProductType__c);
                        currCartId = cc_api_Cart.addToCart(product.SKU__c, currCartId, 1, storefront.Name);
                        currentCartId = currCartId;
                        lastSKUAdded = product.Id;
                        lastProductAdded = product.Name;
                        addedProducts.add(product);
                    }
                    catch (cc_excn_CartException ex) {
                        miscError = ex.getMessage();
                    }
                }
                else if (!nonOrderables.contains(product.SKU__c))
                    nonOrderables.add(product.SKU__c);
                foundSkuList.add(product.SKU__c);
            }
            invalidSkus.addAll(skuList);
            invalidSkus.removeAll(foundSkuList);
            if (lastSKUAdded != null)
                cc_kap_utils_AppUtils.setCookie(cc_kap_utils_AppConstants.COOKIE_LAST_ADDED_ID, lastSKUAdded);
            if (lastProductAdded != null)
                cc_kap_utils_AppUtils.setCookie(cc_kap_utils_AppConstants.COOKIE_LAST_ADDED_PRODUCT, lastProductAdded);
            cc_kap_utils_AppUtils.setCookie(cc_kap_utils_AppConstants.COOKIE_CURR_CART_ID, currCartId);
            isFreeEvent = cc_kap_utils_Cart.isFreeEventCart(currCartId);
        }
        if (isFreeEvent) {
            shippable = false;
            Map<String, List<E_ProductSpecIndex__c>> transientSpecMap = cc_hlpr_LoadProductSpecRealTime.getRealTimeProductSpecIndices(addedProducts);
            for (E_Product__c addedProduct: addedProducts) {
                for (E_ProductSpecIndex__c spec: transientSpecMap.get(String.valueOf(addedProduct.Id))) {
                    if (spec.Spec__r.Name == cc_kap_utils_AppConstants.SPEC_PROGRAM_CODE)
                        programCode = spec.SpecValue__c;
                    else if (spec.Spec__r.Name == cc_kap_utils_AppConstants.SPEC_SHIPPABLE && spec.SpecValue__c == '1')
                        shippable = true;
                }
            }
            return null;
        }
        else
            return setupRedirectPage(currCartId, currProdId, nonOrderables, invalidSkus, lastSKUAdded, miscError, cartContainsProduct);
    }
    
    /*
     * Constructs the page reference used for redirecting the punchin request.
     * @param currCartId cart id
     * @param currProdId products being added
     * @param nonOrderableSkus products that could not be added
     * @return PageReference
     */
    private PageReference setupRedirectPage(String currCartId, String currProdId, Set<String> nonOrderableSkus, Set<String> invalidSkus, String lastSKUAdded, String miscError, boolean cartContainsProduct) {
        PageReference redirectTo = Page.Cart;
        //PageReference redirectTo = Page.cartredirect;
        Map<String, String> params = redirectTo.getParameters();

        String sbu = ' ';
        String productNames = ' ';

        params.put('cartID', currCartId);
        params.put('viewState', 'CartView');
        if (al.StringUtils.isBlank(currProdId))
            params.put('productID', currProdId);
        params.put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, ipAddressLocationKey);
        Integer counter = 0;
        for (String sku : nonOrderableSkus) {
            counter++;
            params.put('notOrdsku' + counter, sku);
        }
        params.put('notOrdskuCount', String.valueOf(counter));
        Integer invalidCount = 0;
        for (String sku : invalidSkus) {
            invalidCount++;
            params.put('sku' + invalidCount, sku);
        }
        if (invalidCount > 0)
            params.put('skuTextCount', String.valueOf(invalidCount));
        if (lastSKUAdded != null)
            params.put('lastSKUAdded', lastSKUAdded);
        if (miscError != null)
            params.put('miscError', miscError);
        if(cartContainsProduct)
            params.put('cartContainsProduct', 'true');

        if(String.isNotEmpty(currCartId)){
            List<E_CartItem__c> cartItems = cc_dao_cart.getDisplayCartItems(currCartId);
            if(cartItems != null){

                cc_kap_api_rules_CartRules cartRulesAPI = new cc_kap_api_rules_CartRules(cartItems);
                productNames = cartItems.get(0).Product__r.Name;

                for(integer i = 1; i < cartItems.size(); i++){
                    productNames = productNames + ', ' + cartItems.get(i).Product__r.Name;
                }
                sbu = getSpecs(cartRulesAPI.getSpecValues(cc_kap_utils_AppConstants.SPEC_SBU), false);

                Cookie productNamesCookie = new Cookie('ccprodnames', productNames,null,-1,false);
                Set<String> specValues = cartRulesAPI.getSpecValues(cc_kap_utils_AppConstants.SPEC_KBS_PROGRAM_CODE);
                Cookie kbsProgramCodesCookie = new Cookie('cckpgid',getSpecs(specValues, true),null,-1,false);
                Cookie sbuCookie = new Cookie('ccbuid',sbu,null,-1,false);

                params.put('cckpgid', getSpecs(specValues, false));
                params.put('ccpgid', getSpecs(cartRulesAPI.getSpecValues(cc_kap_utils_AppConstants.SPEC_PROGRAM_CODE), false)); 
                params.put('ccbuid', sbu);

                ApexPages.currentPage().setCookies(new Cookie[]{kbsProgramCodesCookie, sbuCookie, productNamesCookie});

            }
        }
        
        redirectTo.setRedirect(true);
        return redirectTo;
    }
    
    /*
     * Constructs the page reference used for redirecting the punchin request to SSO.
     * @param currCartId cart id
     * @param currProdId products being added
     * @param nonOrderableSkus products that could not be added
     * @return PageReference
     */
    public PageReference setupFreeEventRedirectPage() {
        PageReference redirectTo = null;
        if (storefront.Use_SSO_For_Auth__c)
            redirectTo = cc_kap_utils_Cart.setupSSORedirect(currentCartId, storefront.PingFederate_URL__c, ipAddressLocationKey);
        else {
            redirectTo = Page.CCSiteLogin;
            Map<String, String> params = redirectTo.getParameters();
            params.put('cartID', currentCartId);
            params.put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, ipAddressLocationKey);
            redirectTo.setRedirect(true);
        }
        redirectTo.getParameters().put('freeEvent', 'true');
        return redirectTo;
    }

    private static String getSpecs(Set<String> specValuesSet, boolean getAll){ 
        String specs = ' ';         
        List<String> specValuesList = new List<String>(); 

        if (specValuesSet != null) {
            specValuesList.addAll(specValuesSet);  
            specs = specValuesList.get(0);      

            if(getAll){
                specs = specValuesList.get(specValuesList.size()-1);
                for(integer i = specValuesList.size() - 2; i >= 0; i--){
                    specs = specs + ', ' + specValuesList.get(i);
                }
            }                       
        }       
        return specs;
    }
    
}