//
//  NinethViewController.h
//  CASSQ
//
//  Created by Abdullah Atik on 2/16/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NinethViewController : UIViewController

// Public properties
@property (nonatomic, copy) NSDictionary *postSelection;
@property (nonatomic, weak) IBOutlet UILabel *question; // Needed to set the question on label from code
@property (nonatomic, weak) IBOutlet UILabel *min;
@property (nonatomic, weak) IBOutlet UILabel *max;
@property (nonatomic, weak) IBOutlet UILabel *minLabel;
@property (nonatomic, weak) IBOutlet UILabel *maxLabel;
@property (nonatomic, weak) IBOutlet UILabel *sliderLabel;
@property (nonatomic, weak) IBOutlet UISlider *slider; // Needed to set the datasource min and max value for slider
@property (nonatomic, weak) IBOutlet UIButton *saveButton; // Needed to change the text on it inform user "Answered"

- (IBAction)sliderChanged:(id)sender;
- (IBAction)saveAnswer:(id)sender;

@end
