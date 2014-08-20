public without sharing class cc_util_Chatter {
	final static public string DefaultFollowerGroup = 'LeadOpportunity';
	final static public string appName = 'CloudCraze';
	public static string getFollowerGroup() {
		String chatterFollowerGroup = cc_util_Chatter.DefaultFollowerGroup;
		if((E_ApplicationSettings__c.getInstance(appName) != null) && 
				!al.StringUtils.isBlank(E_ApplicationSettings__c.getInstance(appName).ChatterFollowerGroup__c) ) {
					chatterFollowerGroup = cc_util_CloudCraze.application.ChatterFollowerGroup__c;
			}
		return chatterFollowerGroup;
	}
	public static List<EntitySubscription> addFollowersToObjects( final list<sobject> objectsToFollow, 
                                             final List<Id> subscribers){
        list<id> objIds = new list<id>();
        for(sobject so : objectsToFollow) {
        	objIds.add((Id)so.get('Id'));
        }
        return addFollowersToObjects(objIds, subscribers);
    }
    
    public static List<EntitySubscription> addGroupToObjects( final list<sobject> objectsToFollow, 
                                             final string groupName){
       list<id> objIds = new list<id>();
        for(sobject so : objectsToFollow) {
        	objIds.add(string.valueOf(so.get('Id')));
        }
       return addGroupToObjects(objIds, groupName);                                      	
    }
	public static List<EntitySubscription> addFollowersToObjects( final list<ID> objectsToFollow, 
                                             final List<Id> subscribers){
        List<EntitySubscription> followers =null;
        if(objectsToFollow != null && subscribers != null && !subscribers.isEmpty() && !objectsToFollow.isEMpty()){
        	followers = new List<EntitySubscription>();
        	for(Id objId : objectsToFollow) {
		        for(Id subscriber : subscribers){
		        	followers.add(new EntitySubscription(parentId = objId,subscriberid = subscriber));  
		        }
		    }
        }
        return followers;
    }
    
    public static List<EntitySubscription> addFollowersToObjects( final list<ID> objectsToFollow, 
                                             final List<User> subscribers){
       list<id> userIds = new list<id>();
       for(user u : subscribers) {
       	userIds.add(u.id);
       }     
       return  addFollowersToObjects(objectsToFollow, userIds);                                	
    }
    
    public static List<EntitySubscription> addGroupToObjects( final list<ID> objectsToFollow, 
                                             final string groupName){        
                   	
       String userKeyPrefix = User.sObjectType.getDescribe().getKeyPrefix();                                       	
       list<id> polymorphicIds = new list<id>();
		for(GroupMember g: [ Select g.UserOrGroupId From GroupMember g where g.groupid in (Select g.Id From Group g where g.name=:groupName)]) {
			polymorphicIds.add(g.UserOrGroupId);
		}  
		list<id> userIds = new list<id>();
		for(string pId : polymorphicIds) {
			if(pId.startsWith(userKeyPrefix)) {
				userIds.add(pId);
			}
		}  
		
		//list<user> u = [select id from user where username = :groupName];
		List<EntitySubscription> k = addFollowersToObjects(objectsToFollow, userIds);
		if(k != null && !k.isEmpty()) {
			insert k;
		}
       return  k;                                	
    }
    
    public static void pushFeed(list<FeedItem> items) {
    	insert items;
    } 
    public static FeedItem addObjectFeedItem(SObject obj, string title, string msg) {
    	FeedItem post = new FeedItem();
    	Id parentId = (Id) obj.get('Id');
		post.ParentId = parentId;
		post.Body = msg;
		post.LinkUrl = '/'+parentId;
		post.title=title;
		return post;
    }
    
}