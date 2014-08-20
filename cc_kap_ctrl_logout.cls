public with sharing class cc_kap_ctrl_logout {

	public PageReference clearCookies(){
		PageReference logout = null;
		if(!cc_util_CloudCraze.isGuest()){
			Cookie cartId1 = new Cookie('currentCartID', '', null, -1, false);
			Cookie cartId2 = new Cookie('currentCartId', '', null, -1, false);
			Cookie lastAddedId = new Cookie('lastAddedId', '', null, -1, false);
			ApexPages.currentPage().setCookies(new Cookie[]{cartId1, cartId2, lastAddedId});
			logout = new PageReference('/secur/logout.jsp');
		}
		return logout;
	}
}