//
//  ThirdViewController.h
//  CASSQ
//
//  Created by Abdullah Atik on 2/16/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ThirdViewController : UIViewController < AVAudioPlayerDelegate >

// Public properties
@property (nonatomic, copy) NSDictionary *postSelection;
@property (nonatomic, weak) IBOutlet UILabel *question;
@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, weak) IBOutlet UIButton *recordButton;
@property (nonatomic, weak) IBOutlet UIButton *saveButton;

- (IBAction) playPressed:(id)sender;
- (IBAction) recordPressed:(id)sender;
- (IBAction) saveAnswer:(id)sender;
- (NSURL *) tempFileURL;

@end
