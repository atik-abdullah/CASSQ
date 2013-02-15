//
//  SurveyViewController.h
//  CASSQ
//
//  Created by Abdullah Atik on 2/14/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurveyViewController : UIViewController <NSFetchedResultsControllerDelegate , UITableViewDataSource, UITableViewDelegate>

@property (nonatomic , weak) IBOutlet  UIBarButtonItem *editButton;
@property (nonatomic , weak) IBOutlet  UITableView *myTableView;

- (IBAction)  fetchEntries :(id) sender;
- (IBAction)  toggleEdit:(id)sender;

@end
