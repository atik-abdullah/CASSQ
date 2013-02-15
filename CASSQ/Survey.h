//
//  Survey.h
//  CASSQ
//
//  Created by Abdullah Atik on 2/14/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface Survey : NSManagedObject

@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSNumber * submitted;
@property (nonatomic, retain) NSString * surveyCount;
@property (nonatomic, retain) NSString * surveyId;
@property (nonatomic, retain) NSString * surveyTotal;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *item;
@end

@interface Survey (CoreDataGeneratedAccessors)

- (void)addItemObject:(Item *)value;
- (void)removeItemObject:(Item *)value;
- (void)addItem:(NSSet *)values;
- (void)removeItem:(NSSet *)values;

@end
