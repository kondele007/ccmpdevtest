public class CaseAttachment
{
    public static final Integer NUM_ATTACHMENTS = 5;

    public Blob contentFile{get;set;}
    public String nameFile{get;set;}
    ApexPages.StandardController controller;
    public List<Attachment> attachments { get; set; }
    public Boolean showblock{get; set;} 
    

    public CaseAttachment(ApexPages.StandardController con)
    {
        this.controller = con;
        this.initializeAttachments();
       
    }

    private void initializeAttachments()
    {
        this.attachments = new List<Attachment>();
        for( Integer index = 0; index < NUM_ATTACHMENTS; index++ )
        {
            this.attachments.add( new Attachment() );
        }
    }
    public void renderDisplay(){
        system.debug('INSIDE RENDER DISPLAY');
        showblock = true;
        system.debug('SHOW BLOCK'+showblock);
    
    }
    public Pagereference ReadFile(){
        System.debug(this.attachments);
        system.debug('NAME'+nameFile);
        system.debug('BODY'+contentFile);
        
        this.controller.save();
        

        Attachment theAttachment = this.attachments[0];
        theAttachment.Name = nameFile;
        theAttachment.Body = contentFile;
        system.debug('CASE ID'+controller.getId());

        List<Attachment> attachmentsToInsert = new List<Attachment>();
        for( Attachment anAttachment : this.attachments )
        {
            if( anAttachment.Body != NULL )
            {
                anAttachment.ParentId = this.controller.getId();
                attachmentsToInsert.add( anAttachment );
            }
        }
        System.debug(this.attachments);
        List<Database.Saveresult> results = Database.Insert(attachmentsToInsert,false);
        for( Database.SaveResult aResult : results )
        {
            if(!aResult.isSuccess())
            {
                for(Database.Error err : aResult.getErrors())
                {
                    ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,'Attachment Insertion failed: ' + err.getMessage()) );
                }
            }
        }

        this.initializeAttachments();
        return Page.OverseasCreditCardThankYou;
    }
}