//
//  QuestionViewController.h
//  CASSQ
//
//  Created by Abdullah Atik on 2/15/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Survey.h"
#import "Item.h"

@interface QuestionViewController : UITableViewController

@property(nonatomic, strong) Survey *survey;   // Assigned when this view contoller is pushed
@property(nonatomic, strong) NSMutableArray *items; // Data source for this view controller

- (id)initWithSurvey:(Survey *)survey;

@end
