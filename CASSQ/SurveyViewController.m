//
//  SurveyViewController.m
//  CASSQ
//
//  Created by Abdullah Atik on 2/14/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "SurveyViewController.h"
#import "Connection.h"

@interface SurveyViewController ()
@end

@implementation SurveyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchEntries];
}



#pragma mark - Private function

- (void)fetchEntries
{
    Connection *connection = [[Connection alloc] init];
    // Begin the connection
    [connection start];
}

@end
