/**
 * @description This class controls the Specifications Tab on the Product Detail page
 * (cc_SpecificationsTab.component and cc_store_ProductDetailsIncl.page)
 * The setter for the main attribute, productForm, combines the product bean's product specs
 * into a list of Spec Groups for output.
 */
public class cc_ctrl_SpecificationsTab {
  
  public boolean containsSpecGroups {get; set;}
  public Map<String,List<cc_bean_Product.ProductSpec>> specGroups {get; set;}
  
  /**
   * @description Getter and Setter for productForm, the main attribute of the Specifications tab.
   * The setter converts the productForms product specs into a map of spec groups.
   * The map contains a key for every spec group found, and a the value of that key
   * contains a list of all specs under that spec group.
   */
  public cc_bean_ProductForm productForm {
  	get;
  	set{
  	  productForm = value;
  	  specGroups = new Map<String,List<cc_bean_Product.ProductSpec>>();
  	  containsSpecGroups = false;
  	  if(productForm != null && productForm.product != null){
  	    List<cc_bean_Product.ProductSpec> allSpecs = productForm.product.productSpecList;
  	    String specGroup = null; 
  	    List<cc_bean_Product.ProductSpec> specGroupMapping = null;
  	    
  	    /* Loop through all of the product specs in productForm / product bean */
  	    for(cc_bean_Product.ProductSpec spec : allSpecs){
  	      specGroup = spec.specGroup;
  	      if(specGroup != null && !''.equals(specGroup)){
  	      	/* Get the current spec group from the map, if exists */
  	        specGroupMapping = specGroups.get(specGroup);   
  	        
  	        /* Create a new list of specs if no map entry found. */
  	        if(specGroupMapping==null){
  	          specGroupMapping = new List<cc_bean_Product.ProductSpec>();
  	          specGroups.put(specGroup,specGroupMapping);  	
  	        }
  	        
  	        /* Add the spec to the current spec group */
  	        specGroupMapping.add(spec);
  	        containsSpecGroups = true;
  	      }  
  	    }
  	  }
  	}
  }
}