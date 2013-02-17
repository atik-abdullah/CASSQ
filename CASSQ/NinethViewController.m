/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *   NinethViewController.m
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
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
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
