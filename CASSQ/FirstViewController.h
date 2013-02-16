//
//  FirstViewController.h
//  CASSQ
//
//  Created by Abdullah Atik on 2/16/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

// Import and Header
#import <UIKit/UIKit.h>

@class Item;
@interface FirstViewController : UIViewController

// Public properties
@property (nonatomic, strong) Item *item;
@property (nonatomic, copy) NSDictionary *postSelection;
@property (nonatomic, weak) IBOutlet UILabel *question;
@property (nonatomic, weak) IBOutlet UITextView *answer;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIButton *answerButton;
@property float keyboardHeight;
@end
