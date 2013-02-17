/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *   QuestionViewController.m
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
#import "QuestionViewController.h"

// Private properties
@interface QuestionViewController ()
@property(nonatomic, strong) NSMutableArray *items; // Data source for this view controller
@end

// Implmentation Begin
@implementation QuestionViewController

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    Survey *survey = [self.selection objectForKey:@"survey"];
    // Fetch all Item of this particular Survery
    NSMutableArray *sortedItems = [[NSMutableArray alloc] initWithArray:[survey.item allObjects]];
    
    // Create a sort Descriptor
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"q_id" ascending:YES];
	NSArray *sortDescriptors =[[NSArray alloc] initWithObjects:sortDescriptor,nil];
    
    // Execute the sort descriptor
    [sortedItems sortUsingDescriptors:sortDescriptors];
    
    // Assing sortedItems to the data source of this table view
    self.items=sortedItems;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [ self.items count ];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //I was getting NSArray beyond bound exception error because in numberOfRowsInSection method it was returning [survey.item count];
    Item *itm = [self.items objectAtIndex:[indexPath row]];
    
    NSString *identifier = nil;
    if ([itm.type isEqualToString:@"1"])
    {
        identifier = @"cellFirstType";
    }
    else if ([itm.type isEqual:@"2"])
    {
        identifier = @"cellSecondType";
    }
    else if ([itm.type isEqual:@"3"])
    {
        identifier = @"cellThirdType";
    }
    else if ([itm.type isEqual:@"4"])
    {
        identifier = @"cellFourthType";
    }
    else if ([itm.type isEqual:@"5"])
    {
        identifier = @"cellFifthType";
    }
    else if ([itm.type isEqual:@"6"])
    {
        identifier = @"cellSixthType";
    }
    else if ([itm.type isEqual:@"7"])
    {
        identifier = @"cellSeventhType";
    }
    else if ([itm.type isEqual:@"8"])
    {
        identifier = @"cellEighthType";
    }
    else if ([itm.type isEqual:@"9"])
    {
        identifier = @"cellNinethType";
    }
    else if ([itm.type isEqual:@"10"])
    {
        identifier = @"cellTenthType";
    }
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier] ;
    }
    
    // Configure the cell...
    UILabel *cellLabel = (UILabel *)[cell viewWithTag:1];
    cellLabel.text = itm.question;
    return cell;
}

# pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setPostSelection:)])
    {
        // prepare selection info
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Item *selectedItem= [self.items objectAtIndex:indexPath.row];
        NSDictionary *postSelection = [NSDictionary dictionaryWithObjectsAndKeys:
                                       selectedItem, @"selectedItem",
                                       nil];
        [destination setValue:postSelection forKey:@"postSelection"];
    }
}
@end
