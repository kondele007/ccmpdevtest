public with sharing virtual class cc_excn_AccountGroupException extends Exception {
    public String accountGroupName { get; set; }
    
    public cc_excn_AccountGroupException(String accountGroupName, String msg) {
        this(msg);
        this.accountGroupName = accountGroupName;
    }
}