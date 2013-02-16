//
//  SixthViewController.m
//  CASSQ
//
//  Created by Abdullah Atik on 2/16/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "SixthViewController.h"
#import "Item.h"

@interface SixthViewController ()
@property (nonatomic, strong) Item *item;
@end

@implementation SixthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.item = [self.postSelection objectForKey:@"selectedItem"];
    self.question.text = self.item.question;
}


@end
