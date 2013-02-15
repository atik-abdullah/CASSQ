//
//  Item.h
//  CASSQ
//
//  Created by Abdullah Atik on 2/14/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Option, Survey;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSNumber * answered;
@property (nonatomic, retain) NSString * answerText;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * max;
@property (nonatomic, retain) NSString * maxLabel;
@property (nonatomic, retain) NSString * min;
@property (nonatomic, retain) NSString * minLabel;
@property (nonatomic, retain) id photo;
@property (nonatomic, retain) NSString * q_id;
@property (nonatomic, retain) NSString * question;
@property (nonatomic, retain) NSString * selectedAID;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * visible;
@property (nonatomic, retain) NSSet *option;
@property (nonatomic, retain) Survey *survey;
@end

@interface Item (CoreDataGeneratedAccessors)

- (void)addOptionObject:(Option *)value;
- (void)removeOptionObject:(Option *)value;
- (void)addOption:(NSSet *)values;
- (void)removeOption:(NSSet *)values;

@end
