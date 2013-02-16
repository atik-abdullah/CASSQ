//
//  NinethViewController.m
//  CASSQ
//
//  Created by Abdullah Atik on 2/16/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "NinethViewController.h"
#import "Item.h"

@interface NinethViewController ()
@property (nonatomic, strong) Item *item;
@property  (strong, nonatomic)  NSString *answer; // The user selection on slider
@end

@implementation NinethViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.item = [self.postSelection objectForKey:@"selectedItem"];
    
    // Show the question on the label
    self.question.text = self.item.question;
    
    // Show min value
    self.min.text = self.item.min;
    
    // Show max value
    self.max.text = self.item.max;
    
    // Show label for minLabel
    self.minLabel.text = self.item.minLabel;
    
    // Show label for maxLabel
    self.maxLabel.text = self.item.maxLabel;
    
    // Data source for slider
    self.slider.minimumValue = [self.item.min floatValue];
    self.slider.maximumValue = [self.item.max floatValue];
    
    // If the user has answered it before set the values to the previously set values
    if (self.item.answerText)
    {
        self.sliderLabel.text = self.item.answerText;
        self.slider.value = [self.item.answerText floatValue];
    }
    else
    {
        self.sliderLabel.text = self.item.min;
        self.slider.value = [self.item.min floatValue];
    }
    self.answer = self.item.min ;
}

-(IBAction) sliderChanged:(id)sender
{
    UISlider *localSlider = (UISlider *)sender;
    int progressAsInt = (int)(localSlider.value + 0.5f);
    NSString *newText = [[NSString alloc] initWithFormat:@"%d", progressAsInt];
    self.sliderLabel.text=newText;
    self.answer = newText ;
}

- (IBAction)saveAnswer:(id)sender
{
    // Save the answer to database
    self.item.answerText = self.answer;
    
    // Mark as answered
    if ([self.answer isEqualToString:@""])
    {
        self.item.answered = [NSNumber numberWithBool:NO];
    }
    else
    {
        self.item.answered = [NSNumber numberWithBool:YES];
    }
    
    // Save context
    [[self.item managedObjectContext] save:nil];
    
    // Change button text to inform user that he has answered successfully
    [self.saveButton setTitle:@"Answered" forState:UIControlStateNormal] ;
}

@end
