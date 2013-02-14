//
//  Connection.m
//  CASSQ
//
//  Created by Abdullah Atik on 2/14/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

// Imports
#import "Connection.h"

// Private
@interface Connection ()
@property (nonatomic, strong) NSMutableData *container;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic,strong) NSURLConnection *internalConnection;
@property (strong, nonatomic)  NSMutableString *characterBuffer;
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
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // Pass the error from the connection to the completionBlock
    if ([self completionBlock])
        [self completionBlock](error);
    
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
        NSLog(@"username, %@",[attributeDict objectForKey:@"username"]);
        NSLog(@"uid, %@",[attributeDict objectForKey:@"uid"]);
        NSLog(@"surveyId, %@",[attributeDict objectForKey:@"surveyId"]);
        NSLog(@"surveyCount, %@",[attributeDict objectForKey:@"surveyCount"]);
        NSLog(@"surveyTotal, %@",[attributeDict objectForKey:@"surveyTotal"]);
    }
    
    else if ([elementName isEqual:@"item"])
    {
        // Instead of inside init method we create characterBuffer here because
        // every time element "item" is encountered we need a fresh characterBuffer
        self.characterBuffer = [[NSMutableString alloc] init];
        
        NSLog(@"item type, %@",[attributeDict objectForKey:@"type"]);
        NSLog(@"item q_id, %@",[attributeDict objectForKey:@"q_id"]);

        if([attributeDict objectForKey:@"min"] && [attributeDict objectForKey:@"max"])
        {
            NSLog(@"item min, %@",[attributeDict objectForKey:@"min"]);
            NSLog(@"item max, %@",[attributeDict objectForKey:@"max"]);

        }
        if([attributeDict objectForKey:@"minlabel"] && [attributeDict objectForKey:@"maxlabel"])
        {
            NSLog(@"item minlabel, %@",[attributeDict objectForKey:@"minlabel"]);
            NSLog(@"item maxlabel, %@",[attributeDict objectForKey:@"maxlabel"]);

        }
    }
    
    else if ([elementName isEqual:@"option"])
    {
        NSLog(@"option value, %@",[attributeDict objectForKey:@"value"]);
        NSLog(@"option o_id, %@",[attributeDict objectForKey:@"o_id"]);
        NSLog(@"option category, %@",[attributeDict objectForKey:@"category"]);
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
