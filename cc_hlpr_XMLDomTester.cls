/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest 
private class cc_hlpr_XMLDomTester {

    static testMethod void parseShipmentConfirmResponseTest() {
        cc_hlpr_XMLDom theXMLDom = new cc_hlpr_XMLDom('<?xml version="1.0" ?><ShipmentConfirmResponse><Response><TransactionReference><CustomerContext>guidlikesubstance</CustomerContext><XpciVersion>1.0001</XpciVersion></TransactionReference><ResponseStatusCode>0</ResponseStatusCode><ResponseStatusDescription>success</ResponseStatusDescription></Response><ShipmentIdentificationNumber>1Z123X670299567041</ShipmentIdentificationNumber><ShipmentDigest>12345</ShipmentDigest></ShipmentConfirmResponse>');
    }
    
    
    static testMethod void parseUpsStringsTest() {
    	String sampleInvoice1 = '<?xml version="1.0" encoding="UTF-8"?><InvoiceBridge><Invoice><Company>TBD</Company><Division>TBD</Division><PickticketCtlNbr>1234567</PickticketCtlNbr><Warehouse>TBD</Warehouse><OrderNbr>1234567</OrderNbr><OrderType>RG</OrderType><InvoiceHeaderFields><OriginalShipVia>box</OriginalShipVia><ShipTo>EDL</ShipTo><ShipVia>box</ShipVia><ShipDate>2011-02-07 00:00:00</ShipDate></InvoiceHeaderFields><ListOfInvoiceDetails><InvoiceDetail><PickticketLineNbr>00</PickticketLineNbr><PktSku><PktQty>1</PktQty><ShippedQty>1</ShippedQty></PktSku><InvoiceDetailFields><OriginalOrderQuantity>1</OriginalOrderQuantity><OriginalPickticketQty>1</OriginalPickticketQty></InvoiceDetailFields></InvoiceDetail></ListOfInvoiceDetails><ListOfCartons><Carton><CartonNbr>001</CartonNbr><CartonHeaderFields><TrackingNbr>abc123</TrackingNbr><ActualWeight>5.4</ActualWeight></CartonHeaderFields><ListOfCartonDetails><CartonDetail><CartonLineNbr>1</CartonLineNbr><CtnSku><SkuDefinition><Company>TBD</Company><Division>TBD</Division></SkuDefinition><UnitsPacked>1</UnitsPacked></CtnSku><CartonDetailFields><PickticketLineNbr>1</PickticketLineNbr></CartonDetailFields><ListOfSerialNbrDetails><SerialNbrDetail><SerialNbrDetailFields><SerialNbr>001</SerialNbr></SerialNbrDetailFields></SerialNbrDetail></ListOfSerialNbrDetails></CartonDetail></ListOfCartonDetails></Carton></ListOfCartons></Invoice></InvoiceBridge>';
    	String sampleInvoice2 = '<?xml version="1.0" encoding="UTF-8"?><InvoiceBridge><Invoice><Company>TBD</Company><Division>TBD</Division><PickticketCtlNbr>1234567</PickticketCtlNbr><Warehouse>TBD</Warehouse><OrderNbr>1234567</OrderNbr><OrderType>RG</OrderType><InvoiceHeaderFields><OriginalShipVia>box</OriginalShipVia><ShipTo>EDL</ShipTo><ShipVia>box</ShipVia><ShipDate>2011-02-07 00:00:00</ShipDate></InvoiceHeaderFields><ListOfInvoiceDetails><InvoiceDetail><PickticketLineNbr>00</PickticketLineNbr><PktSku><PktQty>1</PktQty><ShippedQty>1</ShippedQty></PktSku><InvoiceDetailFields><OriginalOrderQuantity>0</OriginalOrderQuantity><OriginalPickticketQty>0</OriginalPickticketQty></InvoiceDetailFields></InvoiceDetail></ListOfInvoiceDetails><ListOfCartons><Carton><CartonNbr>001</CartonNbr><CartonHeaderFields><TrackingNbr>abc123</TrackingNbr><ActualWeight>5.4</ActualWeight></CartonHeaderFields><ListOfCartonDetails><CartonDetail><CartonLineNbr>1</CartonLineNbr><CtnSku><SkuDefinition><Company>TBD</Company><Division>TBD</Division></SkuDefinition><UnitsPacked>0</UnitsPacked></CtnSku><CartonDetailFields><PickticketLineNbr>1</PickticketLineNbr></CartonDetailFields><ListOfSerialNbrDetails><SerialNbrDetail><SerialNbrDetailFields><SerialNbr>001</SerialNbr></SerialNbrDetailFields></SerialNbrDetail></ListOfSerialNbrDetails></CartonDetail></ListOfCartonDetails></Carton></ListOfCartons></Invoice></InvoiceBridge>';
    	String samplePix1 = '<?xml version="1.0" encoding="UTF-8"?><PIXBridge><PIX><TransactionType>transactiontype</TransactionType><TransactionCode>transactioncode</TransactionCode><TransactionNumber>100</TransactionNumber><SequenceNumber>50</SequenceNumber><SKUDefinition><Company>TBD</Company><Division>TBD</Division><SizeDesc>sizedesc</SizeDesc></SKUDefinition><PIXFields><DateCreated>2011-02-07 00:00:00</DateCreated><Warehouse>TBD</Warehouse><UnitsShipped>5</UnitsShipped><UnitsReceived>7</UnitsReceived><Reference1>reference1</Reference1><ActionCode>null</ActionCode></PIXFields></PIX><PIXBridge>';
    	String samplePix2 = '<?xml version="1.0" encoding="UTF-8"?><PIXBridge><PIX><TransactionType>transactiontype</TransactionType><TransactionCode>transactioncode</TransactionCode><TransactionNumber>100</TransactionNumber><SequenceNumber>50</SequenceNumber><SKUDefinition><Company>TBD</Company><Division>TBD</Division><SizeDesc>sizedesc</SizeDesc></SKUDefinition><PIXFields><DateCreated>2011-02-07 00:00:00</DateCreated><Warehouse>TBD</Warehouse><UnitsShipped>5</UnitsShipped><UnitsReceived>7</UnitsReceived><Reference1>reference1</Reference1><ActionCode>null</ActionCode></PIXFields></PIX><PIXBridge>';
    	
    	cc_hlpr_XMLDom invoice1Dom = new cc_hlpr_XMLDom(sampleInvoice1);
    	cc_hlpr_XMLDom invoice2Dom = new cc_hlpr_XMLDom(sampleInvoice2);
    	cc_hlpr_XMLDom samplePix1Dom = new cc_hlpr_XMLDom(samplePix1);
    	cc_hlpr_XMLDom samplePix2Dom = new cc_hlpr_XMLDom(samplePix2);
    }
    
    static testMethod void otherFunctionsTest() {
    	String xmlString = '<?xml version="1.0" encoding="UTF-8"?><InvoiceBridge><Invoice><Company>TBD</Company><Division>TBD</Division><PickticketCtlNbr>1234567</PickticketCtlNbr><Warehouse>TBD</Warehouse><OrderNbr>1234567</OrderNbr><OrderType>RG</OrderType><InvoiceHeaderFields><OriginalShipVia>box</OriginalShipVia><ShipTo>EDL</ShipTo><ShipVia>box</ShipVia><ShipDate>2011-02-07 00:00:00</ShipDate></InvoiceHeaderFields><ListOfInvoiceDetails><InvoiceDetail><PickticketLineNbr>00</PickticketLineNbr><PktSku><PktQty>1</PktQty><ShippedQty>1</ShippedQty></PktSku><InvoiceDetailFields><OriginalOrderQuantity>1</OriginalOrderQuantity><OriginalPickticketQty>1</OriginalPickticketQty></InvoiceDetailFields></InvoiceDetail></ListOfInvoiceDetails><ListOfCartons><Carton><CartonNbr>001</CartonNbr><CartonHeaderFields><TrackingNbr>abc123</TrackingNbr><ActualWeight>5.4</ActualWeight></CartonHeaderFields><ListOfCartonDetails><CartonDetail><CartonLineNbr>1</CartonLineNbr><CtnSku><SkuDefinition><Company>TBD</Company><Division>TBD</Division></SkuDefinition><UnitsPacked>1</UnitsPacked></CtnSku><CartonDetailFields><PickticketLineNbr>1</PickticketLineNbr></CartonDetailFields><ListOfSerialNbrDetails><SerialNbrDetail><SerialNbrDetailFields><SerialNbr>001</SerialNbr></SerialNbrDetailFields></SerialNbrDetail></ListOfSerialNbrDetails></CartonDetail></ListOfCartonDetails></Carton></ListOfCartons></Invoice></InvoiceBridge>';
    	cc_hlpr_XMLDom dom = new cc_hlpr_XMLDom(xmlString);
    	
    	String backToXmlString = dom.toXmlString();
    	System.assert(backToXmlSTring != null);
    	 
    	cc_hlpr_XMLDom.Element element = null;
    	element = dom.getElementByTagName('Invoice');
    	
    	cc_hlpr_XMLDom.Element newElement = new cc_hlpr_XMLDom.Element();
    	element.getAttribute('Invoice');
    	element.appendChild(newElement);
    	element.removeChild(newElement);
    	element.getElementsByTagName('Invoice');
    	
    	element.dump();
    	element.dump('Invoice');
    	element.dumpAll();
    	element.dump('Invoice');
    	String testDump = element.toXmlString();
    	List<cc_hlpr_XMLDom.Element> elements = new List<cc_hlpr_XMLDom.Element>();
    	elements = element.getElementsByPath('<Invoice><InvoiceHeaderFields>');
    	String testPath = element.path();
    	System.debug('ryl------------------->' + testPath);
    	cc_hlpr_XMLDom.Element firstChild = element.firstChild();
    	String textContent = element.textContent();
    	Boolean hasChildNodes = element.hasChildNodes();
    	Boolean isEqualNode = element.isEqualNode(newElement);
    	cc_hlpr_XMLDom.Element clonedElement = element.cloneNode();
    	Boolean hasAttributes = element.hasAttributes();
    	Boolean isSameNode = element.isSameNode(newElement);
    	cc_hlpr_XMLDom.Element ownerDocument = element.ownerDocument();
    	
    	elements = dom.getElementsByTagName('Invoice');
    }
}