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
private class XMLDomTest {

    static testMethod void parseShipmentConfirmResponseTest() {
        xmldom theXMLDom = new xmldom('<?xml version="1.0" ?><ShipmentConfirmResponse><Response><TransactionReference><CustomerContext>guidlikesubstance</CustomerContext><XpciVersion>1.0001</XpciVersion></TransactionReference><ResponseStatusCode>0</ResponseStatusCode><ResponseStatusDescription>success</ResponseStatusDescription></Response><ShipmentIdentificationNumber>1Z123X670299567041</ShipmentIdentificationNumber><ShipmentDigest>12345</ShipmentDigest></ShipmentConfirmResponse>');
    	system.assert(theXMLDom != null);
    }
    
    
    static testMethod void parseUpsStringsTest() {
    	String sampleInvoice1 = '<?xml version="1.0" encoding="UTF-8"?><InvoiceBridge><Invoice><Company>TBD</Company><Division>TBD</Division><PickticketCtlNbr>1234567</PickticketCtlNbr><Warehouse>TBD</Warehouse><OrderNbr>1234567</OrderNbr><OrderType>RG</OrderType><InvoiceHeaderFields><OriginalShipVia>box</OriginalShipVia><ShipTo>EDL</ShipTo><ShipVia>box</ShipVia><ShipDate>2011-02-07 00:00:00</ShipDate></InvoiceHeaderFields><ListOfInvoiceDetails><InvoiceDetail><PickticketLineNbr>00</PickticketLineNbr><PktSku><PktQty>1</PktQty><ShippedQty>1</ShippedQty></PktSku><InvoiceDetailFields><OriginalOrderQuantity>1</OriginalOrderQuantity><OriginalPickticketQty>1</OriginalPickticketQty></InvoiceDetailFields></InvoiceDetail></ListOfInvoiceDetails><ListOfCartons><Carton><CartonNbr>001</CartonNbr><CartonHeaderFields><TrackingNbr>abc123</TrackingNbr><ActualWeight>5.4</ActualWeight></CartonHeaderFields><ListOfCartonDetails><CartonDetail><CartonLineNbr>1</CartonLineNbr><CtnSku><SkuDefinition><Company>TBD</Company><Division>TBD</Division></SkuDefinition><UnitsPacked>1</UnitsPacked></CtnSku><CartonDetailFields><PickticketLineNbr>1</PickticketLineNbr></CartonDetailFields><ListOfSerialNbrDetails><SerialNbrDetail><SerialNbrDetailFields><SerialNbr>001</SerialNbr></SerialNbrDetailFields></SerialNbrDetail></ListOfSerialNbrDetails></CartonDetail></ListOfCartonDetails></Carton></ListOfCartons></Invoice></InvoiceBridge>';
    	String sampleInvoice2 = '<?xml version="1.0" encoding="UTF-8"?><InvoiceBridge><Invoice><Company>TBD</Company><Division>TBD</Division><PickticketCtlNbr>1234567</PickticketCtlNbr><Warehouse>TBD</Warehouse><OrderNbr>1234567</OrderNbr><OrderType>RG</OrderType><InvoiceHeaderFields><OriginalShipVia>box</OriginalShipVia><ShipTo>EDL</ShipTo><ShipVia>box</ShipVia><ShipDate>2011-02-07 00:00:00</ShipDate></InvoiceHeaderFields><ListOfInvoiceDetails><InvoiceDetail><PickticketLineNbr>00</PickticketLineNbr><PktSku><PktQty>1</PktQty><ShippedQty>1</ShippedQty></PktSku><InvoiceDetailFields><OriginalOrderQuantity>0</OriginalOrderQuantity><OriginalPickticketQty>0</OriginalPickticketQty></InvoiceDetailFields></InvoiceDetail></ListOfInvoiceDetails><ListOfCartons><Carton><CartonNbr>001</CartonNbr><CartonHeaderFields><TrackingNbr>abc123</TrackingNbr><ActualWeight>5.4</ActualWeight></CartonHeaderFields><ListOfCartonDetails><CartonDetail><CartonLineNbr>1</CartonLineNbr><CtnSku><SkuDefinition><Company>TBD</Company><Division>TBD</Division></SkuDefinition><UnitsPacked>0</UnitsPacked></CtnSku><CartonDetailFields><PickticketLineNbr>1</PickticketLineNbr></CartonDetailFields><ListOfSerialNbrDetails><SerialNbrDetail><SerialNbrDetailFields><SerialNbr>001</SerialNbr></SerialNbrDetailFields></SerialNbrDetail></ListOfSerialNbrDetails></CartonDetail></ListOfCartonDetails></Carton></ListOfCartons></Invoice></InvoiceBridge>';
    	String samplePix1 = '<?xml version="1.0" encoding="UTF-8"?><PIXBridge><PIX><TransactionType>transactiontype</TransactionType><TransactionCode>transactioncode</TransactionCode><TransactionNumber>100</TransactionNumber><SequenceNumber>50</SequenceNumber><SKUDefinition><Company>TBD</Company><Division>TBD</Division><SizeDesc>sizedesc</SizeDesc></SKUDefinition><PIXFields><DateCreated>2011-02-07 00:00:00</DateCreated><Warehouse>TBD</Warehouse><UnitsShipped>5</UnitsShipped><UnitsReceived>7</UnitsReceived><Reference1>reference1</Reference1><ActionCode>null</ActionCode></PIXFields></PIX><PIXBridge>';
    	String samplePix2 = '<?xml version="1.0" encoding="UTF-8"?><PIXBridge><PIX><TransactionType>transactiontype</TransactionType><TransactionCode>transactioncode</TransactionCode><TransactionNumber>100</TransactionNumber><SequenceNumber>50</SequenceNumber><SKUDefinition><Company>TBD</Company><Division>TBD</Division><SizeDesc>sizedesc</SizeDesc></SKUDefinition><PIXFields><DateCreated>2011-02-07 00:00:00</DateCreated><Warehouse>TBD</Warehouse><UnitsShipped>5</UnitsShipped><UnitsReceived>7</UnitsReceived><Reference1>reference1</Reference1><ActionCode>null</ActionCode></PIXFields></PIX><PIXBridge>';
    	
    	xmldom invoice1Dom = new xmldom(sampleInvoice1);
    	xmldom invoice2Dom = new xmldom(sampleInvoice2);
    	xmldom samplePix1Dom = new xmldom(samplePix1);
    	xmldom samplePix2Dom = new xmldom(samplePix2);
    	system.assert(samplePix2Dom != null);
    }
    
    static testMethod void otherFunctionsTest() {
    	String xmlString = '<?xml version="1.0" encoding="UTF-8"?><InvoiceBridge><Invoice><Company>TBD</Company><Division>TBD</Division><PickticketCtlNbr>1234567</PickticketCtlNbr><Warehouse>TBD</Warehouse><OrderNbr>1234567</OrderNbr><OrderType>RG</OrderType><InvoiceHeaderFields><OriginalShipVia>box</OriginalShipVia><ShipTo>EDL</ShipTo><ShipVia>box</ShipVia><ShipDate>2011-02-07 00:00:00</ShipDate></InvoiceHeaderFields><ListOfInvoiceDetails><InvoiceDetail><PickticketLineNbr>00</PickticketLineNbr><PktSku><PktQty>1</PktQty><ShippedQty>1</ShippedQty></PktSku><InvoiceDetailFields><OriginalOrderQuantity>1</OriginalOrderQuantity><OriginalPickticketQty>1</OriginalPickticketQty></InvoiceDetailFields></InvoiceDetail></ListOfInvoiceDetails><ListOfCartons><Carton><CartonNbr>001</CartonNbr><CartonHeaderFields><TrackingNbr>abc123</TrackingNbr><ActualWeight>5.4</ActualWeight></CartonHeaderFields><ListOfCartonDetails><CartonDetail><CartonLineNbr>1</CartonLineNbr><CtnSku><SkuDefinition><Company>TBD</Company><Division>TBD</Division></SkuDefinition><UnitsPacked>1</UnitsPacked></CtnSku><CartonDetailFields><PickticketLineNbr>1</PickticketLineNbr></CartonDetailFields><ListOfSerialNbrDetails><SerialNbrDetail><SerialNbrDetailFields><SerialNbr>001</SerialNbr></SerialNbrDetailFields></SerialNbrDetail></ListOfSerialNbrDetails></CartonDetail></ListOfCartonDetails></Carton></ListOfCartons></Invoice></InvoiceBridge>';
    	xmldom dom = new xmldom(xmlString);
    	
    	String backToXmlString = dom.toXmlString();
    	System.assert(backToXmlSTring != null);
    	
    	XMLDom.Element element = null;
    	element = dom.getElementByTagName('Invoice');
    	
    	XMLDom.Element newElement = new XMLDom.Element();
    	element.getAttribute('Invoice');
    	element.appendChild(newElement);
    	element.removeChild(newElement);
    	element.getElementsByTagName('Invoice');
    	
    	element.dump();
    	element.dump('Invoice');
    	element.dumpAll();
    	element.dump('Invoice');
    	String testDump = element.toXmlString();
    	List<XMLDom.Element> elements = new List<XMLDom.Element>();
    	elements = element.getElementsByPath('/InvoiceBridge/Invoice');
    	System.debug('ryl-->' + elements);
    	String testPath = element.path();
    	System.debug('ryl-->' + testPath);
    	XMLDom.Element firstChild = element.firstChild();
    	String textContent = element.textContent();
    	Boolean hasChildNodes = element.hasChildNodes();
    	Boolean isEqualNode = element.isEqualNode(newElement);
    	XMLDom.Element clonedElement = element.cloneNode();
    	Boolean hasAttributes = element.hasAttributes();
    	Boolean isSameNode = element.isSameNode(newElement);
    	XMLDom.Element ownerDocument = element.ownerDocument();
    	
    	elements = dom.getElementsByTagName('Invoice');
    	system.assert(elements.size() != 0);
    }
    
    static testMethod void unitTest1() {
    	String xmlString = '<?xml version="1.0" encoding="utf-8" ?><a><result>0</result><position>0</position><items><item value="1"/><item value="3"/><item value="7"/><item value="11"/></items></a>';
    	xmldom dom = new xmldom(xmlString);
    	XMLDom.Element element = dom.getElementByTagName('a');
    	List<XMLDom.Element> elements = new List<XMLDom.Element>();
    	elements = element.getElementsByPath('/a/result');
    	system.assert(elements.size() != 0);
    }
    
}