/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *   SurveyViewController.m
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
#import "SurveyViewController.h"
#import "FeedStore.h"
#import "QuestionViewController.h"
#import "QuestionPagesViewController.h"
#import "Survey.h"

#define which 2 // change "1" to "2" or "3" to condional segue

@interface SurveyViewController ()
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation SurveyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // It will cause to populate table view from the previously saved Data.
    // Reload in fetchEntries to add the new fetched data in the list
    self.fetchedResultsController = [[FeedStore sharedStore] fetchedResultsController];
    self.fetchedResultsController.delegate = self;
}

#pragma mark- UITableView Data source
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    UIViewController *destination = segue.destinationViewController;
//    if ([destination respondsToSelector:@selector(setSelection:)])
//    {
//        // prepare selection info
//        NSIndexPath *indexPath = [self.myTableView indexPathForCell:sender];
//        Survey *selectedSurvey = (Survey *) [self.fetchedResultsController objectAtIndexPath:indexPath];
//        NSDictionary *selection = [NSDictionary dictionaryWithObjectsAndKeys:
//                                   selectedSurvey, @"survey",
//                                   nil];
//        [destination setValue:selection forKey:@"selection"];
//    }
//}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    switch (which) {
        case 1:
        {
            UIViewController *destination = segue.destinationViewController;
            if ([destination respondsToSelector:@selector(setSelection:)])
            {
                // prepare selection info
                NSIndexPath *indexPath = [self.myTableView indexPathForCell:sender];
                Survey *selectedSurvey = (Survey *) [self.fetchedResultsController objectAtIndexPath:indexPath];
                NSDictionary *selection = [NSDictionary dictionaryWithObjectsAndKeys:
                                           selectedSurvey, @"survey",
                                           nil];
                [destination setValue:selection forKey:@"selection"];
            }
            break;
        }
        case 2:
        {
            UIViewController *destination = segue.destinationViewController;
            if ([destination respondsToSelector:@selector(setSelection:)])
            {
                // prepare selection info
                NSIndexPath *indexPath = [self.myTableView indexPathForCell:sender];
                Survey *selectedSurvey = (Survey *) [self.fetchedResultsController objectAtIndexPath:indexPath];
                NSDictionary *selection = [NSDictionary dictionaryWithObjectsAndKeys:
                                           selectedSurvey, @"survey",
                                           nil];
                [destination setValue:selection forKey:@"selection"];
            }
            break;
        }
    }
}

#pragma mark- UITableView Data source
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *surveyName=@"Survey ID : ";
    
    // Configure the cell...
    UILabel *cellQuestionLabel = (UILabel *)[cell viewWithTag:1];
    cellQuestionLabel.text = [surveyName stringByAppendingString:[[managedObject valueForKey:@"surveyId"] description]];
    
    UILabel *cellTimestampLabel = (UILabel *)[cell viewWithTag:2];
    cellTimestampLabel.text = [[managedObject valueForKey:@"timeStamp"] description];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    }
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Choose which survey you would like to answer : ";
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    // Prevent new objects being added when in editing mode.
    [super setEditing:(BOOL)editing animated:(BOOL)animated];
}

#pragma mark- FetchedResultsController Delegate

// If the following delegates are not implemented the changes made to database will not reflect to the table view until you restart the application. For e.g. the fetched data will not be shown until next restart.

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.myTableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.myTableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.myTableView;
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.myTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.myTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

#pragma mark - Private function
- (IBAction)fetchEntries :(id) sender
{
    [[FeedStore sharedStore] fetchRSSFeedWithCompletion:
     ^(NSError *err)
     {
         // When the request completes, this block will be called.
         if (!err)
         {
             // Implement the
             [[self myTableView] reloadData];
         }
         else
         {
             // If things went bad, show an alert view
             UIAlertView *av = [[UIAlertView alloc]
                                initWithTitle:@"Error"
                                message:[err localizedDescription]
                                delegate:nil
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil];
             [av show];
         }
     }];
}

- (IBAction)toggleEdit:(id)sender
{
    [self.myTableView setEditing:!self.myTableView.editing animated:YES];
    if (self.myTableView.editing)
        [self.editButton setTitle:@"Done"]; // To set the title
    else
        [self.editButton setTitle:@"Edit"]; // To set the title
}

@end
