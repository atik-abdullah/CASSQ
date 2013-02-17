/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *   FourthViewController.m
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
#import "FourthViewController.h"
#import "Item.h"
#import "Option.h"

@interface FourthViewController ()
@property (nonatomic, strong) Item *item;
@property  NSInteger userSelectedRowNumber; // Users choice or answer
@property (strong, nonatomic) NSIndexPath *lastIndexPath;
@property (strong, nonatomic) NSMutableArray *selectedRows; // User choice for multiple answers type question
@property(nonatomic,retain) NSMutableArray *options;
@end

@implementation FourthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.item = [self.postSelection objectForKey:@"selectedItem"];
    self.question.text = self.item.question;
    
    // Fetch all Options of this particular Item
	NSMutableArray *sortedOptions=[[NSMutableArray alloc] initWithArray:[self.item.option allObjects]];
   
    // Create a sort Descriptor
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category" ascending:YES];
	NSArray *sortDescriptors =[[NSArray alloc] initWithObjects:sortDescriptor,nil];
   
    // Execute the sort Desriptor
	[sortedOptions sortUsingDescriptors:sortDescriptors];
	self.options=sortedOptions;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.item type] isEqualToString:@"4" ])
    {
        // Get index of new user selected row 
        int newRow = [indexPath row];
        
        // Get index of last user selected row if there is any
        int oldRow = (self.lastIndexPath != nil) ? [self.lastIndexPath row] : -1;
        
        if (newRow != oldRow)
        {
            UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
            UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.lastIndexPath];

            // Show check mark to new cell
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            // Hide check mark of the old cell
            oldCell.accessoryType = UITableViewCellAccessoryNone;
            
            // If the selection is different than earlier hold the index.
            // It will be needed next time user select another answer
            self.lastIndexPath = indexPath;
            
            // Update user's choice
            self.userSelectedRowNumber = [indexPath row]  ;
        }
    }
    else if ([[self.item type] isEqualToString:@"10" ])
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self.selectedRows removeObject: indexPath  ] ;
        }
        else if (cell.accessoryType == UITableViewCellAccessoryNone)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self.selectedRows addObject: indexPath  ] ;
        }
    }
    // This removes the highlighting of the Cell
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.options count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
   
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] ;
    
    if ([[self.item type] isEqualToString:@"4" ])
    {
        NSUInteger row = [indexPath row];
        NSUInteger oldRow = [self.lastIndexPath row];
        cell.accessoryType = (row == oldRow && self.lastIndexPath != nil) ?
        UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    Option *opt=[self.options objectAtIndex:indexPath.row];
    [[cell detailTextLabel] setText:opt.value]; 
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([[self.item type] isEqualToString:@"4" ])
    {
        return @"You can choose only one answer ";
    }
    else 
    {
        return @"You can choose multiple answer ";
    }
}

#pragma mark- IBAction methods
- (IBAction)saveAnswer:(id)sender
{
    if ([[self.item type] isEqualToString:@"4" ])
    {
        self.item.answerText = [[self.options objectAtIndex:self.userSelectedRowNumber] o_id];
    }
    else if ([[self.item type] isEqualToString:@"10" ])
    {
        NSMutableString *answers= [NSMutableString stringWithString:@""];
        
        for (int i = 0; i< self.selectedRows.count; i++)
        {
            [answers appendString:[[self.options objectAtIndex:i] o_id]];
            [answers appendString:@","];
        }
        self.item.answerText = answers;
    }
    
    // If else block for marking if the user has answered this question
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
    
    // Change the button text to inform the user that the question has been answered
    [self.answerButton setTitle:@"Answered" forState:UIControlStateNormal] ;
}
@end
