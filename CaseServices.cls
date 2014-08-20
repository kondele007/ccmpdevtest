public class CaseServices
{
    public static final String OVERSEAS_CASE_TYPE = 'Paying for my program';
    public static final String OVERSEAS_CASE_DETAIL = 'Balance payment/inquiry';
    public static final String OVERSEAS_QUEUE_NAME = 'Oversea_Payments';
    public static final String OVERSEAS_CASE_STATUS = 'New';
    public static final String OVERSEAS_CASE_ORIGIN = 'Web to Case';
    public static final String OVERSEAS_CASE_RECORDTYPE = 'International_Cases';

    public static void mapCaseToPersonByStudentID( List<Case> incomingCases )
    {
        Set<String> studentIds = new Set<String>();
        for( Case aCase : incomingCases )
        {
            if( !String.isBlank( aCase.Student_Id__c ) && !String.isBlank( aCase.Payment_Mode__c ) )
            {
                studentIds.add( aCase.Student_Id__c );
            }
        }

        if( !studentIds.isEmpty() )
        {
            Map<String, Id> studentIdToAccount = new Map<String, Id>();
            
            for( Account anAccount : [ SELECT Id, Student_ID_Display__c FROM Account WHERE Student_ID_Display__c IN :studentIds ] )
            {
                studentIdToAccount.put( anAccount.Student_ID_Display__c, anAccount.Id );
            }

            Group overseasQueue = [ SELECT Id FROM Group WHERE DeveloperName = :OVERSEAS_QUEUE_NAME AND Type = 'Queue' ];
            RecordType overseasRecordType = [ SELECT Id FROM RecordType WHERE DeveloperName = :OVERSEAS_CASE_RECORDTYPE AND SObjectType = 'Case' ];
            for( Case aCase : incomingCases )
            {
                if( !String.isBlank( aCase.Student_Id__c ) && !String.isBlank( aCase.Payment_Mode__c ) )
                {
                    aCase.OwnerId = overseasQueue.Id;
                    aCase.Type = OVERSEAS_CASE_TYPE;
                    aCase.Type_Detail__c = OVERSEAS_CASE_DETAIL;
                    aCase.Status = OVERSEAS_CASE_STATUS;
                    aCase.Origin = OVERSEAS_CASE_ORIGIN;
                    aCase.AccountId = studentIdToAccount.get( aCase.Student_Id__c );
                    aCase.RecordTypeId = overseasRecordType.Id;
                }
            }
        }
    }
}