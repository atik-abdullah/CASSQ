//
//  FeedStore.h
//  CASSQ
//
//  Created by Abdullah Atik on 2/14/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedStore : NSObject

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

+ (FeedStore *)sharedStore;
- (void)fetchRSSFeedWithCompletion:(void (^)(NSError *err))block;

@end
