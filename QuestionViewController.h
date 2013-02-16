//
//  QuestionViewController.h
//  CASSQ
//
//  Created by Abdullah Atik on 2/15/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

// Import and Header
#import <UIKit/UIKit.h>
#import "Survey.h"
#import "Item.h"

@interface QuestionViewController : UITableViewController

// Properties
@property(nonatomic, strong) Survey *survey;   // Assigned when this view contoller is pushed
@property (nonatomic, copy) NSDictionary *selection;

- (id)initWithSurvey:(Survey *)survey;

@end
