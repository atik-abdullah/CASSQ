//
//  Connection.m
//  CASSQ
//
//  Created by Abdullah Atik on 2/14/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "Connection.h"

@interface Connection ()
@property (nonatomic, strong) NSMutableData *container;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic,strong) NSURLConnection *internalConnection;
@end
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
    // We are just checking to make sure we are getting the XML
    NSString *xmlCheck = [[NSString alloc] initWithData:self.container
                                               encoding:NSUTF8StringEncoding];
    NSLog(@"xmlCheck = %@", xmlCheck);
}

@end
