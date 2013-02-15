//
//  FeedStore.m
//  CASSQ
//
//  Created by Abdullah Atik on 2/14/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FeedStore.h"
#import "Connection.h"
#import "AppDelegate.h"

@implementation FeedStore

@synthesize fetchedResultsController = fetchedResultsController_;

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

#pragma mark- Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController_ != nil) {
        return fetchedResultsController_;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Survey" inManagedObjectContext:[(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext] ];
    
    //Set the Entity for the fetchRequest
    [fetchRequest setEntity:entity];
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    //Set the sort Descriptor for the Fetch Request
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext] sectionNameKeyPath:nil cacheName:@"Root"];
    self.fetchedResultsController = aFetchedResultsController;
    
    
    NSError *error = nil;
    if (![fetchedResultsController_ performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return fetchedResultsController_;
}
@end
