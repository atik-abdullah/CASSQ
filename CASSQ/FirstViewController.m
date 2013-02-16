//
//  FirstViewController.m
//  CASSQ
//
//  Created by Abdullah Atik on 2/16/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

// Header and Imports
#import "FirstViewController.h"
#import "Item.h"

// Internal Data structure
@interface FirstViewController ()

@end

// Implementation begin
@implementation FirstViewController
@synthesize item;
@synthesize postSelection;
@synthesize question;
@synthesize answer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.item = [self.postSelection objectForKey:@"selectedItem"];
    self.scrollView.contentSize = CGSizeMake(320, 550);
    self.question.text = self.item.question;
    NSLog(@"self.item.question, %@", [self.postSelection objectForKey:@"selectedItem"]);
    self.answer.text = self.item.question;
}

@end
