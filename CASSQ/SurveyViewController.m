//
//  SurveyViewController.m
//  CASSQ
//
//  Created by Abdullah Atik on 2/14/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "SurveyViewController.h"
#import "FeedStore.h"
#import <Foundation/Foundation.h>

@interface SurveyViewController ()
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation SurveyViewController


- (id)init
{
    self = [super init];
    if (self)
    {
        // Custom initialization        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // It will cause to populate table view from the previously saved Data.
    // Reload in fetchEntries to add the new fetched data in the list
    self.fetchedResultsController = [[FeedStore sharedStore] fetchedResultsController];
    self.fetchedResultsController.delegate = self;

    // First go to attribute and select toolbar in Bottom. Then do the following.
    // Your toolbar won't appear if you don't enable it.
    [self.navigationController setToolbarHidden:NO];
}

#pragma mark- UITableView Delegate

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
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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

#pragma mark- FetchedResultsController Delegate

// If the following delegates are not implemented the changes made to database will not reflect to the table view until you restart the application. For e.g. the fetched data will not be shown until next restart.

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
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
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

#pragma mark - Private function

- (void)fetchEntries :(id) sender
{
    [[FeedStore sharedStore] fetchRSSFeedWithCompletion:
     ^(NSError *err) {
         // When the request completes, this block will be called.
         if (!err)
         {
             // Implement the 
             [[self tableView] reloadData];
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

@end
