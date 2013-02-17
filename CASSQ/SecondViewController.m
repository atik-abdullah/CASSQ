/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *   SecondViewController.m
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
#import "SecondViewController.h"
#import "Item.h"

@interface SecondViewController ()
@property (nonatomic, strong) Item *item;
@property  (strong, nonatomic) NSMutableArray *globalArray; // Data source for picker
@property  (strong, nonatomic) NSNumber *selectedNumber;
@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Dispatch Item and set the data source
    self.item = [self.postSelection objectForKey:@"selectedItem"];
    
    // Set the question to the label
    self.question.text = self.item.question;
    
    //Create an Array for the Data source of Picker with the min and max value
    int minInt = [[self.item min] intValue];
    int maxInt = [[self.item max] intValue];
    self.globalArray = [[NSMutableArray alloc] initWithCapacity:(maxInt - minInt)];
    for (int i= minInt ; i< maxInt ; i++)
    {
        [self.globalArray addObject:[NSNumber numberWithInt:i]];
    }
    
    // Initialize the picker with user selected number if it was answered previously.
    if (self.item.answerText)
    {
        [self.picker selectRow:[self.globalArray indexOfObject:[NSNumber numberWithInt:[self.item.answerText intValue]]]
                   inComponent:0
                      animated:NO];
    }
    // Else Initialize the user selected number with the minimum int value of the range.
    else
    {
        self.selectedNumber = [NSNumber numberWithInt:minInt];
    }
}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    //  globalArray is array of NSNumber. and you are treating it as string you should rather try following
    int weight = [[self.globalArray objectAtIndex:row] intValue];
    NSString *pickerTitle = [NSString stringWithFormat:@"%d",weight];
    return pickerTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // Update the user selected number
    self.selectedNumber = [self.globalArray objectAtIndex:row];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 50;
}

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [self.globalArray count];
}

- (IBAction)saveAnswer:(id)sender
{
    // Save user selection on database
    self.item.answerText =[self.selectedNumber stringValue];
    
    // Mark this question as answered
    if ([self.item.answerText isEqualToString:@""])
    {
        self.item.answered = [NSNumber numberWithBool:NO];
    }
    else
    {
        self.item.answered = [NSNumber numberWithBool:YES];
    }
    
    // Save the context
    [[self.item managedObjectContext] save:nil];

    // Change the Button text to inform user that , this question has been answered
    [self.selectButton setTitle:@"Selected" forState:UIControlStateNormal] ;
}
@end
