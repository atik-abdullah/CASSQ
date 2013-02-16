//
//  SeventhViewController.m
//  CASSQ
//
//  Created by Abdullah Atik on 2/16/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "SeventhViewController.h"
#import "Item.h"

@interface SeventhViewController ()
@property (nonatomic, strong) Item *item;
@property  (nonatomic , strong) UIImage *imageToSaveInCoreData; // The media that needs to be saved in database.
@end

@implementation SeventhViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.item = [self.postSelection objectForKey:@"selectedItem"];
    self.question.text = self.item.question;
    
    // If the user has answered it previously
    if (self.item.photo)
    {
        [self.myImageView setImage:self.item.photo];
    }
}

- (IBAction)takePicture:(id)sender
{
    UIImagePickerController *imagePicker =[[UIImagePickerController alloc] init];
    
    // If our device has a camera, we want to take a picture, otherwise, we just pick from photo library
    if ([UIImagePickerController
         isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    // This line of code will generate a warning right now, ignore it
    [imagePicker setDelegate:self];
    
    // Place image picker on the screen
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Get picked image from info dictionary
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Put that image onto the screen in our image view
    UIImageWriteToSavedPhotosAlbum (image, nil, nil , nil);
    [self.myImageView setImage:image];
    self.imageToSaveInCoreData = image;
    
    // Take image picker off the screen - you must call this dismiss method
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (IBAction)saveAnswer:(id)sender
{
    // Create name of the audio file which should have "photo_2013.02.16._17_11.20.jpg" format.
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSMutableString *nameString  = [[NSMutableString alloc] init];

    [nameString appendString:@"photo_"];
    
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
    [nameString appendString:@".jpg"];
    
    // Save the name of the media to database
    self.item.answerText = nameString;
    
    // Save the media to database
    self.item.photo = self.imageToSaveInCoreData;
    
    // Mark as answered
    self.item.answered = [NSNumber numberWithBool:YES];
    
    // Save context
    [[self.item managedObjectContext] save:nil];
    
    // Change button text to inform user that he has answered successfully
    [self.saveButton setTitle:@"Answered" forState:UIControlStateNormal] ;
}
@end
