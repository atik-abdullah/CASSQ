/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *   EighthViewController.m
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
