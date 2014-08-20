public with sharing class cc_kapmp_util_Locale {
	public static final String USER_TYPE_GUEST = 'Guest';
    public static Set<String> SUPPORTED_LANGUAGE_CODES = new Set<String>{
        'zh-cn'         //Chinese (Simplified)
        ,'zh-tw'        //Chinese (Traditional)
        ,'nl-nl'        //Dutch
        ,'en-us'        //English
        ,'fi'           //Finnish
        ,'fr'           //French
        ,'de'           //German
        ,'it'           //Italian
        ,'ja'           //Japanese
        ,'ko'           //Korean
        ,'pl'           //Polish
        ,'pt-br'        //Portuguese (Brazilian)
        ,'ru'           //Russian
        ,'es'           //Spanish
        ,'sv'           //Swedish
        ,'th'           //Thai
        ,'cs'           //Czech
        ,'da'           //Danish
        ,'hu'           //Hungarian
        ,'in'           //Indonesian
        ,'tr'           //Turkish
    };
    public static String normalizeLocale(String s)
    {
    	String returnLocale = null;
    	String[] tokens = al.StringUtils.split(s,'-');
    	if(tokens != null){
    		if(tokens.size() == 1)
    		{
    			returnLocale = tokens[0];
    		}
    		else if(tokens.size() == 2)
    		{
    			returnLocale = tokens[0];
    			returnLocale += '_';
    			returnLocale += al.StringUtils.upperCase(tokens[1]);
    		}
        }
        return returnLocale;
    }    
    public static Map<String,String> DEFAULTS = new Map<String,String>{
        'en'=>'en-us'
        ,'zh'=>'zh-cn'
        ,'nl'=>'nl-nl'
        ,'pt'=>'pt-br'
    };

    public static String getLangCodeByBrowser(){
        final String LANGUAGES_FROM_BROWSER_AS_STRING = ApexPages.currentPage().getHeaders().get('Accept-Language');
        //System.debug('--- LANGUAGES_FROM_BROWSER_AS_STRING=' + LANGUAGES_FROM_BROWSER_AS_STRING);
        final List<String> LANGUAGES_FROM_BROWSER_AS_LIST = splitAndFilterAcceptLanguageHeader(LANGUAGES_FROM_BROWSER_AS_STRING);
        if(LANGUAGES_FROM_BROWSER_AS_LIST != null && LANGUAGES_FROM_BROWSER_AS_LIST.size() > 0){
            for(String languageFromBrowser : LANGUAGES_FROM_BROWSER_AS_LIST){
            	languageFromBrowser = al.StringUtils.lowerCase(languageFromBrowser);
                if(DEFAULTS.containsKey(languageFromBrowser)){
                    languageFromBrowser = DEFAULTS.get(languageFromBrowser);
                }
                if(SUPPORTED_LANGUAGE_CODES.contains(languageFromBrowser)){
                    return normalizeLocale(languageFromBrowser);
                }
            }               
        }
        return null;
    }
   //==================================================
   // STATIC SERVICE METHODS
   //==================================================
   	public static List<String> splitAndFilterAcceptLanguageHeader(String header){
        List<String> returnList = new List<String>();
        String[] tokens = al.StringUtils.split(header,',');
        if(tokens != null){
            for(String token : tokens){
                if(token != null ){
                    if(token.contains(';')){
                        token = token.substring(0,token.indexOf(';',0));
                    }
                    returnList.add(token);
                    if(al.StringUtils.length(token) > 2){
                        returnList.add(al.StringUtils.substring(token,0,2));
                    }
                }
            }       
        }
        return returnList;
    }
    
	public static String getUserLanguage() {
		String language;
   		if(USER_TYPE_GUEST.equals(UserInfo.getUserType())) {
   			language=getLangCodeByBrowser();
   			if(language == null) {
   				language = UserInfo.getLocale();
   			}
   		} else {
   			language = Userinfo.getLocale();
   		}
   		return language;
	}	

}