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
@property (nonatomic, copy) NSDictionary *postSelection;
@property (nonatomic, weak) IBOutlet UILabel *question;
@property (nonatomic, weak) IBOutlet UITextView *answer;
// We need pointer to scrollview because we need to scroll the view when keyboard appears
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIButton *answerButton;

- (IBAction)doDone:(id)sender;
- (IBAction)saveAnswer:(id)sender;

@end
