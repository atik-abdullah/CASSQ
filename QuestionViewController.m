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
@synthesize selection;

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
    
    self.survey = [selection objectForKey:@"survey"];
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
    Item *itm = [items objectAtIndex:[indexPath row]];
    
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
