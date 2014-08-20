public with sharing class cc_ctrl_Footer extends cc_ctrl_CloudCraze{
  //==================================================
  // INSTANCE PROPERTIES
  //==================================================
  public String contentBody {get; private set;}
  //==================================================
  // CONSTRUCTOR
  //==================================================
  public cc_ctrl_Footer() {
  	super();
  	contentBody = ApexPages.currentPage().getParameters().get('contentBody');
  }
  
  public cc_ctrl_Footer(cc_ctrl_HomePage c) {
    this();
  }

  public cc_ctrl_Footer(ApexPages.StandardController c) {
  	this();
  }
}