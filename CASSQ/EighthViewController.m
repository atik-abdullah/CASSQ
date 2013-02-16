//
//  EighthViewController.m
//  CASSQ
//
//  Created by Abdullah Atik on 2/16/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "EighthViewController.h"
#import "Item.h"

@interface EighthViewController ()
@property (nonatomic, strong) Item *item;
@property  (nonatomic , strong) NSURL *mediaURL; // URL of video user has recorded,save URL in database instead of media
@end

@implementation EighthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.item = [self.postSelection objectForKey:@"selectedItem"];
    self.question.text = self.item.question;
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
    if (self.mediaURL)
    {
        // Make sure this device supports videos in its photo album
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([self.mediaURL path]))
        {
            // Save the video to the photos album
            UISaveVideoAtPathToSavedPhotosAlbum([self.mediaURL path], nil, nil, nil);
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- IBAction Methods
- (IBAction)recordVideo:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Camera Unavailable"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    // Set up picker - initialize , set source type, set media type
    UIImagePickerController *imagePicker =[[UIImagePickerController alloc] init];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    [imagePicker setDelegate:self];
    
    // Place image picker on the screen
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)saveAnswer:(id)sender
{
    if(self.mediaURL)
    {
        // Create name of the video file which should have "video_2013.02.16._17_11.20.MOV" format.
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSMutableString *nameString  = [[NSMutableString alloc] init];
        [nameString appendString:@"video_"];
        
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
        [nameString appendString:@".MOV"];
    
        // Save the name of the media to database
        self.item.answerText = nameString;
        
        // Save the media to database
        self.item.photo = [[NSData alloc] initWithContentsOfURL:self.mediaURL];
        
        // Mark the question as answered
        self.item.answered = [NSNumber numberWithBool:YES];
        
        // Save context
        [[self.item managedObjectContext] save:nil];
        
        // Change button text to inform user that he has answered successfully
        [self.saveButton setTitle:@"Saved" forState:UIControlStateNormal] ;
    }
}
@end
