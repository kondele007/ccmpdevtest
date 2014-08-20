@IsTest
private class cc_svc_test_RecaptchaService {

    private static testmethod void testEnabled(){
        enable(true);
        System.assertEquals('test1', cc_svc_RecaptchaService.getInstance().privateKey);
        System.assertEquals('test2', cc_svc_RecaptchaService.getInstance().publicKey);
        System.assertEquals('test3', cc_svc_RecaptchaService.getInstance().baseUrl);
    }

    private static testmethod void testNotEnabled(){
        enable(false);
        System.assertEquals(null, cc_svc_RecaptchaService.getInstance().privateKey);
        System.assertEquals(null, cc_svc_RecaptchaService.getInstance().publicKey);
        System.assertEquals(null, cc_svc_RecaptchaService.getInstance().baseUrl);
    }

    private static testmethod void test_ILLEGAL_STATE(){
        enable(false);
        Boolean exceptionCaught = false;
        try{
             cc_svc_RecaptchaService.getInstance().isInvalidResponse(null,null);
        }catch(al.IllegalStateException e){
            exceptionCaught = true;
        }
        System.assert(exceptionCaught == true,'IllegalStateException not thrown');
    }

    private static testmethod void test_ILLEGAL_ARGUMENT1(){
        enable(true);
        Boolean exceptionCaught = false;
        try{
             cc_svc_RecaptchaService.getInstance().isInvalidResponse(null,null);
        }catch(al.IllegalArgumentException e){
            exceptionCaught = true;
        }
        System.assert(exceptionCaught == true,'IllegalArgumentException not thrown');
    }

    private static testmethod void test_ILLEGAL_ARGUMENT2(){
        enable(true);
        Boolean exceptionCaught = false;
        try{
             cc_svc_RecaptchaService.getInstance().isInvalidResponse('abc',null);
        }catch(al.IllegalArgumentException e){
            exceptionCaught = true;
        }
        System.assert(exceptionCaught == true,'IllegalArgumentException not thrown');
    }

    private static testmethod void testIsInvalidResponse_FALSE(){
        enable(true);
        cc_svc_RecaptchaService.pushTest('true');
        System.assertEquals(false, cc_svc_RecaptchaService.getInstance().isInvalidResponse('abc','123'));
    }

    private static testmethod void testIsInvalidResponse_TRUE(){
        enable(true);
        cc_svc_RecaptchaService.pushTest('false');
        System.assertEquals(true, cc_svc_RecaptchaService.getInstance().isInvalidResponse('abc','123'));
    }

    private static void enable(Boolean enable){
        final Map<String,String> theVariables = new Map<String,String>{
             cc_svc_RecaptchaService.KEY_PRIVATE_KEY => enable ? 'test1' : null
            ,cc_svc_RecaptchaService.KEY_PUBLIC_KEY  => enable ? 'test2' : null
            ,cc_svc_RecaptchaService.KEY_BASE_URL    => enable ? 'test3' : null
        };
        for(String key : theVariables.keySet()){
            cc_util_GlobalVariableTest.ensureGlobalVariableExists(new Global_Variable__c(name=key,Value__c=theVariables.get(key)));
        }
    }

}