//
//  SurveyViewController.m
//  CASSQ
//
//  Created by Abdullah Atik on 2/14/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "SurveyViewController.h"
#import "FeedStore.h"

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
    [[FeedStore sharedStore] fetchRSSFeedWithCompletion:
     ^( NSError *err) {
         // When the request completes, this block will be called.
         if (!err) {
         } else {
             // If things went bad, show an alert view
             UIAlertView *av = [[UIAlertView alloc]
                                initWithTitle:@"Error"
                                message:[err localizedDescription]
                                delegate:nil
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil];
             [av show];
         }
     }];
}

@end
