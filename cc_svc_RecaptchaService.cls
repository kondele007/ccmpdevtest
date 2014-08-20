public class cc_svc_RecaptchaService {

    //==================================================
    // STATIC PROPERTIES
    //==================================================
    private static cc_svc_RecaptchaService instance;

    public static final String KEY_PRIVATE_KEY = 'Recaptcha.PrivateKey';
    public static final String KEY_PUBLIC_KEY  = 'Recaptcha.PublicKey';
    public static final String KEY_BASE_URL    = 'Recaptcha.BaseUrl';

    //==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public String privateKey {get; private set;}
    public String publicKey  {get; private set;}
    public String baseUrl    {get; private set;}

    //==================================================
    // CONSTRUCTOR  
    //==================================================
    private cc_svc_RecaptchaService(){
        final Map<String,Global_Variable__c> all = Global_Variable__c.getAll();
        privateKey = retrieveString(KEY_PRIVATE_KEY, all);
        publicKey  = retrieveString(KEY_PUBLIC_KEY, all);
        baseUrl    = retrieveString(KEY_BASE_URL, all);
    }

    //==================================================
    // DERIVED PROPERTIES
    //==================================================
    public Boolean enabled {get{ 
        return al.StringUtils.isNotBlank(publicKey)
            && al.StringUtils.isNotBlank(privateKey)
            && al.StringUtils.isNotBlank(baseUrl)
        ; 
    }}

	public String remoteHost{ get{ 
		String returnValue = '127.0.0.1';
	    Map<String,String> headers = null;
	    if(ApexPages.currentPage() != null){
	    	headers = ApexPages.currentPage().getHeaders();
	    }
	    headers = headers == null ? new Map<String,String>() : headers;
	    if(headers.containsKey('x-original-remote-addr')){
	    	returnValue = headers.get('x-original-remote-addr');
	    } else if(headers.containsKey('X-Salesforce-SIP')){
            returnValue = headers.get('X-Salesforce-SIP');
	    }
	    return returnValue;
	}}
	
    //==================================================
    // SERVICE METHODS
    //==================================================
    public Boolean isInvalidResponse(final String challenge, final String response){
        if(!enabled){ throw new al.IllegalStateException('Service is not enabled'); }
        if(al.StringUtils.isBlank(challenge)){ throw new al.IllegalArgumentException('challenge parameter cannot be null'); }
        if(al.StringUtils.isBlank(response)){ throw new al.IllegalArgumentException('response parameter cannot be null'); }

	    final HttpRequest httpRequest = new HttpRequest();   
	    httpRequest.setEndpoint(baseUrl);
	    httpRequest.setMethod('POST');
	    httpRequest.setBody(al.MapUtils.joinMap(new Map<String,String>{
             'privatekey' => privateKey 
            ,'remoteip'   => remoteHost  
            ,'challenge'  => challenge
            ,'response'   => response
            ,'error'      => 'incorrect-captcha-sol'      
        },'=','&'));
        debug(httpRequest);
        String rawResponse = null;
        if(Test.isRunningTest()){
            rawResponse = popTest();
            System.debug('### (TEST) RESPONSE: ' + rawResponse);
        } else {
            //this line will throw an exception during unit tests, hence the workarounds
            final HttpResponse httpResponse = (new Http()).send(httpRequest);
            if(httpResponse != null){ 
            	debug(httpResponse);
            	rawResponse = httpResponse.getBody(); 
            }
        }
        return rawResponse == null || !al.StringUtils.contains(rawResponse,'true');
    }
    
    //==================================================
    // STATIC HELPER METHODS
    //==================================================
 
    public static cc_svc_RecaptchaService getInstance(){
        if(instance == null){
            instance = new cc_svc_RecaptchaService();
        }
        return instance;
    }
    
    private static String retrieveString(String key, Map<String,Global_Variable__c> all){
        String returnValue = null;
        if(all != null && !al.StringUtils.isBlank(key) && all.get(key) != null){
            returnValue = all.get(key).value__c;
        }
        return returnValue;
    }

    //==================================================
    // TESTING HELPER METHODS
    //==================================================
    private static final List<String> testResponseStack = new List<String>();
    public static void pushTest(String testResponse){ testResponseStack.add(testResponse); }
    private static String popTest(){ return testResponseStack.isEmpty() ? '' : testResponseStack.remove(0); }

    public static void debug(HttpRequest request){
        System.debug(toStr(request));
    }
    
    public static String toStr(HttpRequest request){
        String returnValue = '';
        if(request != null){
            returnValue = '\n'
                + '\n###########################################################'
                + '\nHTTP REQUEST: ' 
                + '\n###########################################################'
                + '\nCompressed:   ' + request.getCompressed()
                + '\nEndpoint:     ' + request.getEndpoint()
                + '\nContent-Type: ' + request.getHeader('Content-Type')
                + '\nSOAPAction:   ' + request.getHeader('SOAPAction')
                + '\nMethod:       ' + request.getMethod()
                + '\nBody: '
                + '\n' + request.getBody()
                + '\n'
                + '\n';
        }
        return returnValue;
    }
    
    public static void debug(HttpResponse response){
        if(response != null){
            System.debug('\n'
                + '\n###########################################################'
                + '\nHTTP RESPONSE: ' 
                + '\n###########################################################'
                + '\nHeaders:    ' + retrieveHeaders(response)
                + '\nStatusCode: ' + response.getStatusCode()
                + '\nStatus:     ' + response.getStatus()
                + '\nBody: '
                + '\n' + response.getBody()
                + '\n'
                + '\n'
            );
        }
    }

    public static String retrieveHeaders(HttpResponse response){
        String returnValue = '';
        if(response != null && response.getHeaderKeys() != null && response.getHeaderKeys().size() > 0){
            final Map<String,String> headers = new Map<String,String>();
            for(String key : response.getHeaderKeys()){
                if(key != null){
                    headers.put(key,response.getHeader(key));
                }
            }
            returnValue = al.MapUtils.joinMap(headers,'=',',');
        }
        returnValue = '[' + returnValue + ']';
        return returnValue;
    }    

}