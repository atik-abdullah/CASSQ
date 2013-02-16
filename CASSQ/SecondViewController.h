//
//  SecondViewController.h
//  CASSQ
//
//  Created by Abdullah Atik on 2/16/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController < UIPickerViewDelegate, UIPickerViewDataSource >

// Public properties
@property (nonatomic, copy) NSDictionary *postSelection;
@property (nonatomic, weak) IBOutlet UILabel *question;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

- (IBAction) saveAnswer:(id)sender;

@end
