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
@property (nonatomic, strong) Item *item;
@property (nonatomic) float keyboardHeight;
@end

// Implementation begin
@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.item = [self.postSelection objectForKey:@"selectedItem"];
    self.scrollView.contentSize = CGSizeMake(320, 550);
    self.question.text = self.item.question;
    self.answer.text = self.item.answerText;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //---registers the notifications for keyboard---
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

-(void) viewWillDisappear:(BOOL)animated
{
    //---removes the notifications for keyboard---
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillShowNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillHideNotification
     object:nil];
}

#pragma mark - KEYBOARD HANDLING
-(void) keyboardDidShow:(NSNotification *) notification
{
    // Get height of keyboard
    NSDictionary* info = [notification userInfo];
    CGRect keyboardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardHeight =  keyboardFrame.size.height;
    
    // Ensure current text field is visible, if not adjust the contentOffset
    // of the scrollView appropriately.
    float textFieldTop = self.answer.frame.origin.y;
    float textFieldBottom = textFieldTop + self.answer.frame.size.height;
    if (textFieldBottom > self.keyboardHeight)
    {
        [self.scrollView setContentOffset:CGPointMake(0, self.question.frame.size.height) animated:YES];
    }
}

//---when the keyboard disappears---
-(void) keyboardDidHide:(NSNotification *) notification
{
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)doDone:(id)sender
{
    [self.view endEditing:NO];
}

- (IBAction)saveAnswer:(id)sender
{
    self.item.answerText = self.answer.text;
    if ([self.answer.text isEqualToString:@""])
    {
        self.item.answered = [NSNumber numberWithBool:NO];
    }
    else
    {
        self.item.answered = [NSNumber numberWithBool:YES];
    }
    [[self.item managedObjectContext] save:nil];
    [self.answerButton setTitle:@"Answered" forState:UIControlStateNormal] ;
}

@end
