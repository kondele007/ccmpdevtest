public with sharing class cc_bean_AddressBook {
    
    public class AddressTypeInfo {
        public Boolean isDefault {get;set;}
        public String addressType {get;set;}
        
        public AddressTypeInfo(String addressType, Boolean isDefault) {
            this.addressType = addressType;
            this.isDefault = isDefault;
        }
    }
    
    //==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public cc_bean_MockContactAddress addressBean {get;set;}
    public List<cc_bean_AddressBook.AddressTypeInfo> addressTypes {get;set;}

    //==================================================
    // CONSTRUCTOR
    //==================================================
    public cc_bean_AddressBook() {
        // empty address book
        addressBean = new cc_bean_MockContactAddress();
        addressTypes = new List<AddressTypeInfo>();
    }

    public cc_bean_AddressBook(E_AddressBook__c ebook) {
        this();

        if(ebook != null) {
            if(ebook.E_ContactAddress__r != null) {
                addressBean = new cc_bean_MockContactAddress(ebook.E_ContactAddress__r);
            }
            
            System.debug('--- cc_bean_AddressBook: ebook=' + ebook);
            cc_bean_AddressBook.AddressTypeInfo info = new cc_bean_AddressBook.AddressTypeInfo(ebook.AddressType__c, ebook.Default__c);
            addressTypes.add(info);
        }
    }
}