//
//  EighthViewController.m
//  CASSQ
//
//  Created by Abdullah Atik on 2/16/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "EighthViewController.h"
#import "Item.h"

@interface EighthViewController ()
@property (nonatomic, strong) Item *item;
@end

@implementation EighthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.item = [self.postSelection objectForKey:@"selectedItem"];
    self.question.text = self.item.question;
}

@end
