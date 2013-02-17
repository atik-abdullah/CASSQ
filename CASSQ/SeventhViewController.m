/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *   SeventhViewController.m
 *   CASS Project
 *
 *   Created by Abdullah Atik on 5/25/12.
 *   Copyright ©2012 Helsinki Metropolia University of Applied Sciences.
 *
 *   Infomation Technology Degree Programme
 *   Helsinki Metropolia University of Applied Sciences
 *
 *   This program is free software; you can redistribute it and/or modify it under the terms
 *   of the GNU General Public License as published by the Free Software Foundation;
 *   either version 2 of the License, or (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
 *   without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *   See the GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License along with this program;
 *   if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 *   MA 02111-1307 USA
 *
 *   Contact: Infomation Technology Degree Programme, Helsinki University of Applied Sciences,
 *   Vanha maantie 6, 02650 Espoo, FINLAND. www.metropolia.fi
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
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

#pragma mark- IBAction Methods
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

@end
