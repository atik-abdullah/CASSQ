//
//  ThirdViewController.m
//  CASSQ
//
//  Created by Abdullah Atik on 2/16/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

// Import and headers
#import "ThirdViewController.h"
#import "Item.h"

// Internal Data structure
@interface ThirdViewController ()
@property (nonatomic, strong) Item *item;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) NSURL *url;
@end

// Implementation Begin
@implementation ThirdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.item = [self.postSelection objectForKey:@"selectedItem"];
    self.question.text = self.item.question;
    
    // Initialize recorder and set parameters
    self.url = [self tempFileURL];
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:self.url settings:nil
                                                        error:nil];
    self.audioRecorder.meteringEnabled = YES;
    [self.audioRecorder prepareToRecord];
}

#pragma mark IBAction Methods

- (IBAction) recordPressed:(id)sender
{
    if ([self.audioRecorder isRecording])
    {
        [self.audioRecorder stop];
        [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
    }
    else
    {
        [self.audioRecorder record];
        [self.recordButton setTitle:@"Stop" forState:UIControlStateNormal];
    }
}

- (IBAction) playPressed:(id)sender
{
    if (![self.player isPlaying])
    {
        NSFileManager *manager = [[NSFileManager alloc] init];
        NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@",
                                NSTemporaryDirectory(), @"recording.wav"];
        if ([manager fileExistsAtPath:outputPath])
        {
            self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.url error:nil];
        }
        [self.player play];
        [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
    }
    else
    {
        [self.player pause];
        [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    }
}

- (IBAction) saveAnswer:(id)sender
{
    // Create name of the audio file which should have "audio_2013.02.16._17_11.20.amr" format.
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSMutableString *nameString  = [[NSMutableString alloc] init];
    [nameString appendString:@"audio_"];
    
    [dateFormatter setDateFormat:@"yyyy"];
    [nameString appendString:[dateFormatter stringFromDate:[NSDate date]]];
    [nameString appendString:@"."];
    
    [dateFormatter setDateFormat:@"MM"];
    [nameString appendString:[dateFormatter stringFromDate:[NSDate date]]];
    [nameString appendString:@"."];
    
    [dateFormatter setDateFormat:@"dd"];
    [nameString appendString:[dateFormatter stringFromDate:[NSDate date]]];
    [nameString appendString:@"."];
    
    [nameString appendString:@"_"];
    
    [dateFormatter setDateFormat:@"HH"];
    [nameString appendString:[dateFormatter stringFromDate:[NSDate date]]];
    [nameString appendString:@"_"];
    
    
    [dateFormatter setDateFormat:@"mm"];
    [nameString appendString:[dateFormatter stringFromDate:[NSDate date]]];
    [nameString appendString:@"."];
    
    [dateFormatter setDateFormat:@"ss"];
    [nameString appendString:[dateFormatter stringFromDate:[NSDate date]]];
    [nameString appendString:@".amr"];
    
    NSFileManager *manager = [[NSFileManager alloc] init];
    
    // The path where the recording can be found
    NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@",
                            NSTemporaryDirectory(), @"recording.wav"];
    
    // Create URL from the path
    NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
    
    // Save the name of the file on the database
    self.item.answerText = nameString;
    
    if ([manager fileExistsAtPath:outputPath])
    {
        // save the media in database
        self.item.photo = [[NSData alloc] initWithContentsOfURL:outputURL];
        // Mark as answered
        self.item.answered = [NSNumber numberWithBool:YES];
    }
    
    // Save the context
    [[self.item managedObjectContext] save:nil];
    
    // Change the button text to inform the user if the question has been asnwered successfully
	[self.saveButton setTitle:@"Saved" forState:UIControlStateNormal] ;
}

#pragma mark - Utility Methods

- (NSURL *) tempFileURL
{
    NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@",
                            NSTemporaryDirectory(), @"recording.wav"];
    NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
    NSFileManager *manager = [[NSFileManager alloc] init];
    
    if ([manager fileExistsAtPath:outputPath])
    {
        [manager removeItemAtPath:outputPath error:nil];
    }
    return outputURL;
}

@end
