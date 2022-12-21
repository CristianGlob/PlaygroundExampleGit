@isTest
private class ScheduleBatchTest {
    public static final String CRON_EXP = '0 0 8 1/1 * ? *';
    
    @isTest
    static void testScheduledJob() {

        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource('callout:MediaAssociatesAPI/token', 'StaticToken');
        multimock.setStaticResource('callout:MediaAssociatesAPI/productos', 'StaticProduct');
        multimock.setStaticResource('callout:MediaAssociatesAPI/listas', 'StaticPricebook');
        multimock.setStaticResource('callout:MediaAssociatesAPI/precios', 'StaticPrice');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');

        Test.setMock(HttpCalloutMock.class, multimock);

        Test.startTest();
        String jobId = System.schedule('SchedulableBatch',
                                       CRON_EXP,
                                       new SchedulableBatch());
        Test.stopTest();

        CronTrigger ct = [
        SELECT Id, CronExpression, TimesTriggered, NextFireTime 
        FROM CronTrigger 
        WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression,'Is not the same expression');
        System.assertEquals(0, ct.TimesTriggered,'Times triggered are not the expected'); 
    }
}