//
//  QuestionViewController.m
//  CASSQ
//
//  Created by Abdullah Atik on 2/15/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

// Header and Imports
#import "QuestionViewController.h"

// Private properties
@interface QuestionViewController ()

@end

// Implmentation Begin
@implementation QuestionViewController

// Synthesized Public properties
@synthesize survey;
@synthesize items;

- (id)initWithSurvey:(Survey *)surv
{
    self = [super init];
    if(self)
    {
        self.survey = surv;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier] ;
    }
    
    //I was getting NSArray beyond bound exception error because in numberOfRowsInSection method it was returning [survey.item count];
    Item *itm = [items objectAtIndex:[indexPath row]];
    cell.textLabel.text = itm.question;
    return cell;
}

@end
