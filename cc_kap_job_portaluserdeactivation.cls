global with sharing class cc_kap_job_portaluserdeactivation implements Schedulable{
    global void execute(SchedulableContext ctx) {
       /**** List<E_CategorySpec__c> specList = [select spec__r.name, category__r.categoryId__c, specValue__c, id
                                      from e_categorySpec__c spec
                                      where category__r.categoryId__c in ( '113','116','255','256','2610','2537','2249','2476','998','1187','1218','1280','1802','1854','1931','2182','2184','2185','2193','2270','2478','2345','2529','2123','2253','2520','2192','2189','2615','2502','2463','2462','2522','2467','2648','2650','2513','2614','2194','2617','2514')
                                      and spec__r.name = 'DeliveryType'];
        for(Integer i=0;i<specList.size();i++) {                                                                                                
            System.debug (specList[i].spec__r.name  + ' ' + specList[i].category__r.categoryId__c + ' ' + specList[i].specValue__c);
            specList[i].specValue__c = '3';
        }
        update(specList);
        
        specList = [select spec__r.name, category__r.categoryId__c, specValue__c, id
                                      from e_categorySpec__c spec
                                      where category__r.categoryId__c in ('2268','1856','1919')
                                      and spec__r.name = 'DeliveryType'];
        for(Integer i=0;i<specList.size();i++) {                                                                                                
            System.debug (specList[i].spec__r.name  + ' ' + specList[i].category__r.categoryId__c + ' ' + specList[i].specValue__c);
            specList[i].specValue__c = '4';
        }
        update(specList);
        
        specList = [select spec__r.name, category__r.categoryId__c, specValue__c, id
                                      from e_categorySpec__c spec
                                      where category__r.categoryId__c in ('2126','158' )
                                      and spec__r.name = 'DeliveryType'];
        for(Integer i=0;i<specList.size();i++) {                                                                                                
            System.debug (specList[i].spec__r.name  + ' ' + specList[i].category__r.categoryId__c + ' ' + specList[i].specValue__c);
            specList[i].specValue__c = '6';
        }
        update(specList);
        
        specList = [select spec__r.name, category__r.categoryId__c, specValue__c, id
                                      from e_categorySpec__c spec
                                      where category__r.categoryId__c in ('669','2617','2618','1282','2613','2301','2319','2025','2122','2616')
                                      and spec__r.name = 'DeliveryType'];
        for(Integer i=0;i<specList.size();i++) {                                                                                                
            System.debug (specList[i].spec__r.name  + ' ' + specList[i].category__r.categoryId__c + ' ' + specList[i].specValue__c);
            specList[i].specValue__c = '7';
        }
        update(specList);
        
        specList = [select spec__r.name, category__r.categoryId__c, specValue__c, id
                                      from e_categorySpec__c spec
                                      where category__r.categoryId__c in ('2087','2088','2134','2303','2306','2328' )
                                      and spec__r.name = 'DeliveryType'];
        for(Integer i=0;i<specList.size();i++) {                                                                                                
            System.debug (specList[i].spec__r.name  + ' ' + specList[i].category__r.categoryId__c + ' ' + specList[i].specValue__c);
            specList[i].specValue__c = '11';
        }
        update(specList);*****************/
        
        deactivateUsers();             
    }
    
    @future
    // Use @future to avoid mixed DML exception
    public static void deactivateUsers() {
        // De-activate Users who have not logged in in the past 3 hours
        datetime myDateTime = datetime.now();
        datetime newDateTime = myDateTime.addHours(-3);

        System.debug('current time:' + myDateTime);
        System.debug('newDateTime time:' + newDateTime);

        Boolean done = false;
        Integer soqlCount = 0;
        // Max SOQL limit per apex is 100
        // Max DML per apex is 10000. Each loop runs upto 150 DMLs so keep the loop to 65 to keep some buffer (65*150<1000)
        while ((done == false) && (soqlCount < 65)) {
            List<User> users = [select id,email,lastLoginDate from User where isPortalSelfRegistered = true and isActive = true and lastLoginDate < :newDateTime limit 150];
            soqlCount = soqlCount + 1;   
            if (users.isEmpty()) {
                System.debug('No users found');
                done = true;
            } else {
                System.debug (users.size() + ' user account(s) will be updated');
                for(User u : users) {
                    u.isActive = false;
                    //System.debug(u.id + ' ' + u.email + ' will be deactivated' + u.lastLoginDate);
                }
                update users;         
            }    
        }  
    }
}