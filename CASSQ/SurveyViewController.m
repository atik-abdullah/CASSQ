//
//  SurveyViewController.m
//  CASSQ
//
//  Created by Abdullah Atik on 2/14/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "SurveyViewController.h"
#import "FeedStore.h"
#import "QuestionViewController.h"
#import "Survey.h"
#import <Foundation/Foundation.h>

@interface SurveyViewController ()
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation SurveyViewController

@synthesize editButton;
@synthesize myTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // It will cause to populate table view from the previously saved Data.
    // Reload in fetchEntries to add the new fetched data in the list
    self.fetchedResultsController = [[FeedStore sharedStore] fetchedResultsController];
    self.fetchedResultsController.delegate = self;

//    // First go to attribute and select toolbar in Bottom. Then do the following.
//    // Your toolbar won't appear if you don't enable it.
//    [self.navigationController setToolbarHidden:NO];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    // First go to attribute and select toolbar in Bottom. Then do the following.
//    // Your toolbar won't appear if you don't enable it.
//    // It's done in viewWillAppear because otherwise it won't appear
//    // when return back from QuestionViewController
//    [self.navigationController setToolbarHidden:NO];
//}

#pragma mark- UITableView Data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        // Retrieve the particular survey of the selected row
        Survey *selectedSurvey = (Survey *) [self.fetchedResultsController objectAtIndexPath:indexPath];
                                           
        // Drill down to survey to reveal questions inside it
        QuestionViewController *display =[[QuestionViewController alloc] initWithSurvey:selectedSurvey];
        // Push
        [self.navigationController pushViewController: display animated:YES];
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
    cell.textLabel.text = [surveyName stringByAppendingString:[[managedObject valueForKey:@"surveyId"] description]];
    cell.detailTextLabel.text = [[managedObject valueForKey:@"timeStamp"] description] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"plainCell";
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
     ^(NSError *err){
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
