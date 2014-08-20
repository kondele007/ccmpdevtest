public with sharing class cc_hlpr_CloudCrazeSorter {
	//==================================================
    // SERVICE METHODS
    //==================================================	
    public static List<Object> IntrospectionSort(List<Object> theList, Integer start, Integer count, cc_util_ObjectComparator comparator) 
    {
      Sorter introSpectionSorter=new Sorter(theList, comparator).IntrospectionSort(start, start + count);
      return introSpectionSorter.getSorterList();
    }
     
    
     public static List<cc_bean_ProductListViewData> sortStandard(List<cc_bean_ProductListViewData> toBeSorted) {
        List<cc_bean_ProductListViewData> sortedList = new List<cc_bean_ProductListViewData>();
    
        /* Create a map of amount to Object collection */
        Map<Decimal, List<cc_bean_ProductListViewData>> objectMap = new Map<Decimal, List<cc_bean_ProductListViewData>>();
        
        for(cc_bean_ProductListViewData o:toBeSorted) {        	
            if(objectMap.get(o.sortRank) == null) { objectMap.put(o.sortRank, new List<cc_bean_ProductListViewData>()); }
            objectMap.get(o.sortRank).add(o);
        }
        
        List<Decimal> keys = new List<Decimal>(objectMap.keySet());
        
        /* Leverage the standard, primitive collection sort method */
        keys.sort();
        
        for(Decimal key:keys) { sortedList.addAll(objectMap.get(key)); }
        
        return sortedList;
    }

    public  void InsertionSort(List<Object> theList, Integer start, Integer count, cc_util_ObjectComparator comparator)
    {
      new Sorter(theList, comparator).InsertionSort(start, start + count);
    }

    public void QuickSort(List<Object> theList, Integer start, Integer count, cc_util_ObjectComparator comparator) 
    {
      
      Sorter s = new Sorter(theList, comparator);
      s.QuickSort(start, start + count);
    }
   
    public void HeapSort(List<Object> theList, Integer start, Integer count, cc_util_ObjectComparator comparator) 
    {
      new Sorter(theList, comparator).HeapSort(start, start + count);
    }

	//==================================================
    // INNER CLASS
    //==================================================	
    class Sorter
    {
      //==================================================
      // INSTANCE VARIABLES
      //==================================================	
      List<Object> theList;

      cc_util_ObjectComparator comparator;
      
      //==================================================
      // CONSTRUCTOR
      //==================================================	
      Sorter(List<Object> theList, cc_util_ObjectComparator comparator) { this.theList = theList; this.comparator = comparator; }

	  //==================================================
      // HELPER METHODS
      //==================================================	
      public List<Object> getSorterList(){
      	return theList;
      } 
       
       
      Sorter IntrospectionSort(Integer f, Integer b) 
      {
        if (b - f > 31)
        {
          Integer depth_limit = Math.floor(2.5 * Math.ceil( (double)Math.log ( (double)b - f ) / Math.log(2))).intValue();

          IntrospectionSort(f, b, depth_limit);
        }
        else {
          QuickSort(f, b-1);
          InsertionSort(f, b);
	    }
	    return this;
      }

      private void IntrospectionSort(Integer f, Integer b, Integer depth_limit) 
      {
        Integer size_threshold = 14;//24;

        if (depth_limit-- == 0)
          HeapSort(f, b);
        else if (b - f <= size_threshold) {
          QuickSort(f, b-1);
          InsertionSort(f, b);
        } else
        {
          Integer p = partition(f, b);

          IntrospectionSort(f, p, depth_limit);
          IntrospectionSort(p, b, depth_limit);
        }
      }
      
      private Integer partition(Integer f, Integer b) 
      {
        Integer bot = f, mid = (b + f) / 2, top = b - 1;
        Object abot = theList[bot], amid = theList[mid], atop = theList[top];

        if (comparator.compare(abot, amid) < 0)
        {
          if (comparator.compare(atop, abot) < 0)//atop<abot<amid
          { theList[top] = amid; amid = theList[mid] = abot; theList[bot] = atop; }
          else if (comparator.compare(atop, amid) < 0) //abot<=atop<amid
          { theList[top] = amid; amid = theList[mid] = atop; }
          //else abot<amid<=atop
        }
        else
        {
          if (comparator.compare(amid, atop) > 0) //atop<amid<=abot
          { theList[bot] = atop; theList[top] = abot; }
          else if (comparator.compare(abot, atop) > 0) //amid<=atop<abot
          { theList[bot] = amid; amid = theList[mid] = atop; theList[top] = abot; }
          else //amid<=abot<=atop
          { theList[bot] = amid; amid = theList[mid] = abot; }
        }

        Integer i = bot, j = top;

        while (true)
        {
          while (comparator.compare(theList[++i], amid) < 0) ;

          while (comparator.compare(amid, theList[--j]) < 0) ;

          if (i < j)
          {
            Object tmp = theList[i]; theList[i] = theList[j]; theList[j] = tmp;
          }
          else
            return i;
        }
        return i;
      }

	private void swap(Integer i, Integer j)
	{
		Object T;
		T = theList[i];
		theList[i] = theList[j];
		theList[j] = T;
	}

	private void QuickSort(Integer l, Integer r) 
   {
	Integer M = 4;
	Integer i;
	Integer j;
	Object v;

	if ((r-l)>M)
	{
		i = (r+l)/2;
		if(comparator.compare(theList[l],theList[i]) > 0) swap(l,i);
		if(comparator.compare(theList[l],theList[r]) > 0) swap(l,r);
		if(comparator.compare(theList[i],theList[r]) > 0) swap(i,r);
		
		j = r-1;
		swap(i,j);
		i = l;
		v = theList[j];
		for(;;)
		{
			while(comparator.compare(theList[++i],v)<0);
			while(j>0 && comparator.compare(theList[--j],v)<0);
			if (j<i) break;
			swap (i,j);			
		}
		swap(i,r-1);		
		QuickSort(l,j);
		QuickSort(i+1,r);
	}
}

	private void InsertionSort(Integer lo0, Integer hi0) 
	{
		Integer i;
		Integer j;
		Object v;

		for (i=lo0+1;i<hi0;i++)
		{
			v = theList[i];
			j=i;
			while ((j>lo0) && (comparator.compare(theList[j-1],v)>0))
			{
				theList[j] = theList[j-1];				
				j--;
			}
			theList[j] = v;
	 	}
	}


      void HeapSort(Integer f, Integer b) 
      {

        for (Integer i = (b + f) / 2; i >= f; i--) heapify(f, b, i);

        for (Integer i = b - 1; i > f; i--)
        {
          Object tmp = theList[f]; theList[f] = theList[i]; theList[i] = tmp;
          heapify(f, i, f);
        }
      }
      
      


      private void heapify(Integer f, Integer b, Integer i)
      {
        Object pv = theList[i], lv, rv, max = pv;
        Integer j = i, maxpt = j;

        while (true)
        {
          Integer l = 2 * j - f + 1, r = l + 1;

          if (l < b && comparator.compare(lv = theList[l], max) > 0) { maxpt = l; max = lv; }

          if (r < b && comparator.compare(rv = theList[r], max) > 0) { maxpt = r; max = rv; }

          if (maxpt == j)
            break;

          theList[j] = max;
          max = pv;
          j = maxpt;
        }

        if (j > i)
          theList[j] = pv;
      }
    
    }

}