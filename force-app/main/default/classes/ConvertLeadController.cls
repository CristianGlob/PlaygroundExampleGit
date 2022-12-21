public with sharing class ConvertLeadController {
        @InvocableMethod
        public static void LeadAssign(List<Id> LeadIds){
     
         LeadStatus CLeadStatus = [
             SELECT Id, MasterLabel 
             FROM LeadStatus
             WHERE IsConverted = true
             LIMIT 1
         ];
         List<Database.LeadConvert> MassLeadconvert = new List<Database.LeadConvert>();
         for(id currentlead: LeadIds){
             Database.LeadConvert Leadconvert = new Database.LeadConvert();
             Leadconvert.setLeadId(currentlead);
             Leadconvert.setConvertedStatus(CLeadStatus.MasterLabel);
         //  Leadconvert.setDoNotCreateOpportunity(TRUE);
             MassLeadconvert.add(Leadconvert);
         }
         if (!MassLeadconvert.isEmpty()) {
             List<Database.LeadConvertResult> lcr = Database.convertLead(MassLeadconvert);        
         }
    }
}