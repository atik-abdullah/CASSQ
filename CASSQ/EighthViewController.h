//
//  EighthViewController.h
//  CASSQ
//
//  Created by Abdullah Atik on 2/16/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EighthViewController : UIViewController < UINavigationControllerDelegate, UIImagePickerControllerDelegate>

// Public properties
@property (nonatomic, copy) NSDictionary *postSelection;
@property (nonatomic, weak) IBOutlet UILabel *question;
@property (nonatomic, weak) IBOutlet UIButton *saveButton; // Needed to change the text on it inform user "Answered"

- (IBAction)recordVideo:(id)sender;
- (IBAction)saveAnswer:(id)sender;

@end
