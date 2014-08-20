//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public virtual class cc_hlpr_Paginator {
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
	
	public al.ObjectPaginator paginator {get; set;} 
	
	public Integer skipPage {
		get{
			if(skipPage < 0){
				skipPage = 0;
			}
			return skipPage;
		}
		set;
	}
	//==================================================
    // SERVICE METHODS
    //==================================================
	public void skipToLocation(){
		if(paginator != null){
			paginator.skipToPage(skipPage);
		}
	}
	public List<SelectOption> pageSizeOptions {
		get {
			if (pageSizeOptions == null) {
				pageSizeOptions = new List<SelectOption>();
				pageSizeOptions.add(new SelectOption('2','2'));
				pageSizeOptions.add(new SelectOption('4','4'));
				pageSizeOptions.add(new SelectOption('20','20'));
				pageSizeOptions.add(new SelectOption('50','50'));
				pageSizeOptions.add(new SelectOption('100','100'));
			}
			return pageSizeOptions;
		}
		set;
	}
	
    private static testmethod void testHundredObjects(){
		cc_hlpr_Paginator pg = new cc_hlpr_Paginator();	
		pg.paginator = new al.ObjectPaginator();
		al.ObjectPaginator paginator = pg.paginator;

        Integer RECORD_COUNT = 100;
        List<Object> records = createTestObject(RECORD_COUNT);
        paginator.setRecords(records);
        System.assertNotEquals(null,paginator.all);
        System.assertEquals(RECORD_COUNT,paginator.all.size());
        System.assertEquals(RECORD_COUNT,paginator.recordCount);
        System.assertNotEquals(null,paginator.page);
        System.assertEquals(al.ObjectPaginator.DEFAULT_PAGE_SIZE,paginator.page.size());
        System.assertEquals(al.ObjectPaginator.DEFAULT_PAGE_SIZE,paginator.pageSize);
        System.assertEquals(al.ObjectPaginator.DEFAULT_PAGE_SIZE,paginator.getPageSize());
        System.assertEquals(0,paginator.pageNumber);
        System.assertEquals(Math.ceil(RECORD_COUNT/al.ObjectPaginator.DEFAULT_PAGE_SIZE).intValue(), paginator.pageCount);
        System.assertEquals(true,paginator.hasNext);
        System.assertEquals(false,paginator.hasPrevious);
        for(Integer i = 0; i < al.ObjectPaginator.DEFAULT_PAGE_SIZE; i++){
            System.assertEquals(i, ((al.DecimalRange)paginator.page.get(i)).min());
        }
        
        paginator.next();
        System.assertNotEquals(null,paginator.all);
        System.assertEquals(RECORD_COUNT,paginator.all.size());
        System.assertNotEquals(null,paginator.page);
        System.assertEquals(al.ObjectPaginator.DEFAULT_PAGE_SIZE,paginator.page.size());
        System.assertEquals(al.ObjectPaginator.DEFAULT_PAGE_SIZE,paginator.pageSize);
        System.assertEquals(1,paginator.pageNumber);
        System.assertEquals(Math.ceil(RECORD_COUNT/al.ObjectPaginator.DEFAULT_PAGE_SIZE).intValue(), paginator.pageCount);
        System.assertEquals(true,paginator.hasNext);
        System.assertEquals(true,paginator.hasPrevious);
        for(Integer i = 0; i < al.ObjectPaginator.DEFAULT_PAGE_SIZE; i++){
            System.assertEquals(i, ((al.DecimalRange)paginator.page.get(i)).min()-al.ObjectPaginator.DEFAULT_PAGE_SIZE);
        }
        
        pg.skipPage = 2;
        System.debug('--- paginator.page before skipToLocation = ' + paginator.page);
        pg.skipToLocation();
        System.debug('--- paginator.page after skipToLocation = ' + paginator.page);
        pg.skipPage = -1;
        System.assertEquals(0, pg.skipPage);
        
        List<SelectOption> pageSizeOptions = pg.pageSizeOptions;
        System.assertEquals(5, pageSizeOptions.size());
    }

	private static List<Object> createTestObject(Integer count){
        List<Object> records = new List<Object>();
        for(Integer i = 0; i < count; i++){
            records.add(new al.DecimalRange(i,i));
        }
        return records;
    }
	
}