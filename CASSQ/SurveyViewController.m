//
//  SurveyViewController.m
//  CASSQ
//
//  Created by Abdullah Atik on 2/14/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "SurveyViewController.h"

@interface SurveyViewController ()
@property (nonatomic, strong) NSMutableData *container;
@end

@implementation SurveyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.container = [[NSMutableData alloc] init];
    [self fetchEntries];
}

#pragma mark - NSURLConnection

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.container appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // We are just checking to make sure we are getting the XML
    NSString *xmlCheck = [[NSString alloc] initWithData:self.container
                                               encoding:NSUTF8StringEncoding];
    NSLog(@"xmlCheck = %@", xmlCheck);
}

#pragma mark - Private function

- (void)fetchEntries
{
    NSString *urlString = @"http://54.247.115.29/cass/MobileIO/XMLGen.php?uid=t26bd1bf56d4";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [[NSURLConnection alloc] initWithRequest:req
                                    delegate:self
                            startImmediately:YES];
}

@end
