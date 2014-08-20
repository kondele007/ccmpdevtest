public with sharing class cc_kap_bean_GetRealResponseBean {

    //This is the http response code
    public Integer responseStatusCode{get; set;}
    
    //This is the GetReal result code
    public String resultStatusCode{get; set;}
    
    //Map of client_sys_id to enrollment_id
    public Map<String,String> enrollmentIds{get; set;}
    
    //This is GetReal Student Id
   public String StudentId{get; set;}

}