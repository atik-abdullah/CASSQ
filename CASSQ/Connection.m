//
//  Connection.m
//  CASSQ
//
//  Created by Abdullah Atik on 2/14/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

// Imports
#import "Connection.h"
#import "Survey.h"
#import "Option.h"
#import "Item.h"
#import "AppDelegate.h"

// Private
@interface Connection ()
@property (nonatomic, strong) NSMutableData *container;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic,strong) NSURLConnection *internalConnection;
@property (strong, nonatomic)  NSMutableString *characterBuffer;
@property (strong, nonatomic) Survey *aSurvey;
@property (strong, nonatomic) Item *aItem;
@property (strong, nonatomic) Option *aOption;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

// Static variable
static NSMutableArray *sharedConnectionList = nil;

@implementation Connection

@synthesize completionBlock;


- (id)initWithRequest:(NSURLRequest *)req
{
    self = [super init];
    if (self) {
        [self setRequest:req];
        self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];

    }
    return self;
}

- (void)start
{
    // Initialize container for data collected from NSURLConnection
    self.container = [[NSMutableData alloc] init];
    
    // Spawn connection
    self.internalConnection = [[NSURLConnection alloc] initWithRequest:[self request]
                                                              delegate:self
                                                      startImmediately:YES];
    
    // If this is the first connection started, create the array
    if (!sharedConnectionList)
        sharedConnectionList = [[NSMutableArray alloc] init];
    
    // Add the connection to the array so it doesn't get destroyed
    [sharedConnectionList addObject:self];
}

#pragma mark - NSURLConnection

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.container appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Create a parser with the incoming data and let the root object parse its contents
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.container];
    [parser setDelegate:self];
    [parser parse];
    
    // We are just checking to make sure we are getting the XML
    NSString *xmlCheck = [[NSString alloc] initWithData:self.container
                                               encoding:NSUTF8StringEncoding];
    NSLog(@"xmlCheck = %@", xmlCheck);
    
    if ([self completionBlock])
        [self completionBlock](nil);
        // Now, destroy this connection
        [sharedConnectionList removeObject:self];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // Pass the error from the connection to the completionBlock
    if ([self completionBlock])    
    // Destroy this connection
    [sharedConnectionList removeObject:self];
}

#pragma mark-  NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqual:@"survey"])
    {
        self.aSurvey = (Survey *) [NSEntityDescription insertNewObjectForEntityForName:@"Survey" inManagedObjectContext:self.managedObjectContext];
        self.aSurvey.timeStamp = [[NSDate alloc] init];
        self.aSurvey.username  = [attributeDict objectForKey:@"username"];
        self.aSurvey.uid = [attributeDict objectForKey:@"uid"];
        self.aSurvey.surveyId = [attributeDict objectForKey:@"surveyId"];
        self.aSurvey.surveyCount = [attributeDict objectForKey:@"surveyCount"];
        self.aSurvey.surveyTotal = [attributeDict objectForKey:@"surveyTotal"];
    }
    
    else if ([elementName isEqual:@"item"])
    {
        // Instead of inside init method we create characterBuffer here because
        // every time element "item" is encountered we need a fresh characterBuffer
        self.characterBuffer = [[NSMutableString alloc] init];
        
        self.aItem = (Item *) [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
        
        // set item category
        self.aItem.category  = [attributeDict objectForKey:@"category"];
        
        // Set item visibility
        if([[attributeDict objectForKey:@"category"] isEqual: @"0"]){
            //Entity Defines bool as NSNumber , so you cant directly assign bool values YES or NO , such as aItem.visible = TRUE is not possible.
            self.aItem.visible = [NSNumber numberWithBool:YES];
        }
        else
            self.aItem.visible = [NSNumber numberWithBool:NO];
        
        // Set item type
        self.aItem.type  = [attributeDict objectForKey:@"type"];
        
        // Set item q_id
        self.aItem.q_id  = [attributeDict objectForKey:@"q_id"];
        
        // Set item min and max
        if([attributeDict objectForKey:@"min"] && [attributeDict objectForKey:@"max"])
        {
            self.aItem.min  = [attributeDict objectForKey:@"min"];
            self.aItem.max  = [attributeDict objectForKey:@"max"];
        }
        
        // Set item minlabel and maxlabel
        if([attributeDict objectForKey:@"minlabel"] && [attributeDict objectForKey:@"maxlabel"]){
            self.aItem.minLabel  = [attributeDict objectForKey:@"minlabel"];
            self.aItem.maxLabel  = [attributeDict objectForKey:@"maxlabel"];
        }
    }
    
    else if ([elementName isEqual:@"option"])
    {
        self.aOption = (Option *) [NSEntityDescription insertNewObjectForEntityForName:@"Option" inManagedObjectContext:self.managedObjectContext];
        
        // Set option value
        self.aOption.value = [attributeDict objectForKey:@"value"];
        
        // Set option o_id
        self.aOption.o_id = [attributeDict objectForKey:@"o_id"];
        
        // Set option category
        self.aOption.category = [attributeDict objectForKey:@"category"];
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName{
    
    
    if ([elementName isEqual:@"item"])
    {
        [self.aSurvey addItemObject:self.aItem];
    }
    
    if ([elementName isEqual:@"option"])
    {
        [self.aItem addOptionObject:self.aOption];
    }
    if ([elementName isEqual:@"survey"]) {
        
        //save the whole survey at once, previously I was saving it in wrong places and as a result the last Item was not being added to the survey
        if(![self.managedObjectContext save:nil]){
            abort();
        }
    }
  
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)str
{
    [self.characterBuffer appendString:[NSString stringWithFormat:@"%@",str]];
   
    if (![self stringIsEmpty:str]) {
        NSLog(@"question is %@",self.characterBuffer);
    }
    
}

#pragma mark - Utility methods

//In the objective C there is no elegant way to check if the string is empty, i.e. nil or empty space.
// I found a solution http://i-phone-dev.blogspot.fi/2011/11/iphone-nsstring-operations.html
- (BOOL ) stringIsEmpty:(NSString *) aString {
    
    if ((NSNull *) aString == [NSNull null])
    {
        return YES;
    }
    if (aString == nil)
    {
        return YES;
    }
    else if ([aString length] == 0)
    {
        return YES;
    }
    else
    {
        aString = [aString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([aString length] == 0)
        {
            return YES;
        }
    }
    return NO;
}
@end
