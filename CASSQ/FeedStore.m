//
//  FeedStore.m
//  CASSQ
//
//  Created by Abdullah Atik on 2/14/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FeedStore.h"
#import "Connection.h"

@implementation FeedStore

+ (FeedStore *)sharedStore
{
    static FeedStore *feedStore = nil;
    if (!feedStore)
        feedStore = [[FeedStore alloc] init];
    return feedStore;
}

- (void)fetchRSSFeedWithCompletion:(void (^)(NSError *err))block
{
    NSString *urlString = @"http://54.247.115.29/cass/MobileIO/XMLGen.php?uid=t26bd1bf56d4";
    NSURL *url = [NSURL URLWithString:urlString];        
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    // Create a connection "actor" object that will transfer data from the server
    Connection *connection = [[Connection alloc] initWithRequest:req];
    // When the connection completes, this block from the controller will be called
    [connection setCompletionBlock:block];
    // Begin the connection
    [connection start];
}
@end
