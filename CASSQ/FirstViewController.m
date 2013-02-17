/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *   FirstViewController.m
 *   CASS Project
 *
 *   Created by Abdullah Atik on 5/25/12.
 *   Copyright ©2012 Helsinki Metropolia University of Applied Sciences.
 *
 *   Infomation Technology Degree Programme
 *   Helsinki Metropolia University of Applied Sciences
 *
 *   This program is free software; you can redistribute it and/or modify it under the terms
 *   of the GNU General Public License as published by the Free Software Foundation;
 *   either version 2 of the License, or (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
 *   without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *   See the GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License along with this program;
 *   if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 *   MA 02111-1307 USA
 *
 *   Contact: Infomation Technology Degree Programme, Helsinki University of Applied Sciences,
 *   Vanha maantie 6, 02650 Espoo, FINLAND. www.metropolia.fi
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/#import "FirstViewController.h"
#import "Item.h"

// Internal Data structure
@interface FirstViewController ()
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
