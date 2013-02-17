/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *   QuestionViewController.m
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
#import "QuestionPagesViewController.h"
#import "Survey.h"
#import "Item.h"
#import "FirstViewController.h"

@interface QuestionPagesViewController ()
@property (nonatomic, strong) UIPageViewController *pageController;
@property(nonatomic, strong) NSMutableArray *items; // Data source for this view controller
@end

@implementation QuestionPagesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    Survey *survey = [self.selection objectForKey:@"survey"];
    
    // Fetch all Item of this particular Survery
    NSMutableArray *sortedItems = [[NSMutableArray alloc] initWithArray:[survey.item allObjects]];
    
    // Create a sort Descriptor
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"q_id" ascending:YES];
	NSArray *sortDescriptors =[[NSArray alloc] initWithObjects:sortDescriptor,nil];
    
    // Execute the sort descriptor
    [sortedItems sortUsingDescriptors:sortDescriptors];
    
    // Assing sortedItems to the data source of this table view
    self.items=sortedItems;
    
    
    
    NSDictionary *options = [NSDictionary dictionaryWithObject: [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                        forKey: UIPageViewControllerOptionSpineLocationKey];
    
    self.pageController = [[UIPageViewController alloc]
                           initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                           navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                           options: options];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    if (([self.items count] != 0))
    {
        UIViewController *initialViewController = [self viewControllerAtIndex:0];
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        [self.pageController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
        [self addChildViewController:self.pageController];
        [[self view] addSubview:[self.pageController view]];
        [self.pageController didMoveToParentViewController:self];
    }

    // Setup page control 
    self.pageControl.numberOfPages = [self.items count];
    self.pageControl.currentPage = 0;
    [self.view bringSubviewToFront:self.pageControl];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    // Return the data view controller for the given index.
    if (([self.items count] == 0) ||
        (index >= [self.items count]) )
    {
        return nil;
    }
    
    UIViewController *dataViewController = [[UIViewController alloc] init];
    
	Item *selectedItem= self.items[index];
    
    if( [selectedItem.type isEqualToString:@"1"])
    {
        UIViewController *onevc = [self.storyboard instantiateViewControllerWithIdentifier:@"FirstViewController"];
        if ([onevc respondsToSelector:@selector(setPostSelection:)])
        {
            // prepare selection info
            NSDictionary *postSelection = [NSDictionary dictionaryWithObjectsAndKeys:
                                           selectedItem, @"selectedItem",
                                           nil];
            [onevc setValue:postSelection forKey:@"postSelection"];
        }
        dataViewController = onevc;
    }
    else if ( [selectedItem.type isEqualToString:@"2"])
    {
        UIViewController *onevc = [self.storyboard instantiateViewControllerWithIdentifier:@"SecondViewController"];
        if ([onevc respondsToSelector:@selector(setPostSelection:)])
        {
            // prepare selection info
            NSDictionary *postSelection = [NSDictionary dictionaryWithObjectsAndKeys:
                                           selectedItem, @"selectedItem",
                                           nil];
            [onevc setValue:postSelection forKey:@"postSelection"];
        }
        dataViewController = onevc;
    }
    else if( [selectedItem.type isEqualToString:@"3"])
    {
        UIViewController *onevc = [self.storyboard instantiateViewControllerWithIdentifier:@"ThirdViewController"];
        if ([onevc respondsToSelector:@selector(setPostSelection:)])
        {
            // prepare selection info
            NSDictionary *postSelection = [NSDictionary dictionaryWithObjectsAndKeys:
                                           selectedItem, @"selectedItem",
                                           nil];
            [onevc setValue:postSelection forKey:@"postSelection"];
        }
        dataViewController = onevc;
    }
    else if( [selectedItem.type isEqualToString:@"4"] || [selectedItem.type isEqualToString:@"10"])
    {
        UIViewController *onevc = [self.storyboard instantiateViewControllerWithIdentifier:@"FourthViewController"];
        if ([onevc respondsToSelector:@selector(setPostSelection:)])
        {
            // prepare selection info
            NSDictionary *postSelection = [NSDictionary dictionaryWithObjectsAndKeys:
                                           selectedItem, @"selectedItem",
                                           nil];
            [onevc setValue:postSelection forKey:@"postSelection"];
        }
        dataViewController = onevc;
    }
    else if( [selectedItem.type isEqualToString:@"5"])
    {
        UIViewController *onevc = [self.storyboard instantiateViewControllerWithIdentifier:@"FifthViewController"];
        if ([onevc respondsToSelector:@selector(setPostSelection:)])
        {
            // prepare selection info
            NSDictionary *postSelection = [NSDictionary dictionaryWithObjectsAndKeys:
                                           selectedItem, @"selectedItem",
                                           nil];
            [onevc setValue:postSelection forKey:@"postSelection"];
        }
        dataViewController = onevc;
    }
    else if( [selectedItem.type isEqualToString:@"6"])
    {
        UIViewController *onevc = [self.storyboard instantiateViewControllerWithIdentifier:@"SixthViewController"];
        if ([onevc respondsToSelector:@selector(setPostSelection:)])
        {
            // prepare selection info
            NSDictionary *postSelection = [NSDictionary dictionaryWithObjectsAndKeys:
                                           selectedItem, @"selectedItem",
                                           nil];
            [onevc setValue:postSelection forKey:@"postSelection"];
        }
        dataViewController = onevc;
    }
    else if( [selectedItem.type isEqualToString:@"7"])
    {
        UIViewController *onevc = [self.storyboard instantiateViewControllerWithIdentifier:@"SeventhViewController"];
        if ([onevc respondsToSelector:@selector(setPostSelection:)])
        {
            // prepare selection info
            NSDictionary *postSelection = [NSDictionary dictionaryWithObjectsAndKeys:
                                           selectedItem, @"selectedItem",
                                           nil];
            [onevc setValue:postSelection forKey:@"postSelection"];
        }
        dataViewController = onevc;
    }
    else if( [selectedItem.type isEqualToString:@"8"] )
    {
        UIViewController *onevc = [self.storyboard instantiateViewControllerWithIdentifier:@"EighthViewController"];
        if ([onevc respondsToSelector:@selector(setPostSelection:)])
        {
            // prepare selection info
            NSDictionary *postSelection = [NSDictionary dictionaryWithObjectsAndKeys:
                                           selectedItem, @"selectedItem",
                                           nil];
            [onevc setValue:postSelection forKey:@"postSelection"];
        }
        dataViewController = onevc;
    }
    else if( [selectedItem.type isEqualToString:@"9"])
    {
        UIViewController *onevc = [self.storyboard instantiateViewControllerWithIdentifier:@"NinethViewController"];
        if ([onevc respondsToSelector:@selector(setPostSelection:)])
        {
            // prepare selection info
            NSDictionary *postSelection = [NSDictionary dictionaryWithObjectsAndKeys:
                                           selectedItem, @"selectedItem",
                                           nil];
            [onevc setValue:postSelection forKey:@"postSelection"];
        }
        dataViewController = onevc;
    }
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(FirstViewController *)viewController
{
    return [self.items indexOfObject:viewController.item];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(FirstViewController *)viewController
{
    // Get the index of current view controller
    NSUInteger index = [self indexOfViewController:viewController];
    if ((index == 0) || (index == NSNotFound))
    {
        return nil;
    }
    
    // Decrement the index
    index--;
    self.pageControl.currentPage = index;
    
    // Get the View controller of the decremented index
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:
(UIPageViewController *)pageViewController viewControllerAfterViewController:(FirstViewController *)viewController
{
    // Get the index of current view controller
    NSUInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound)
        return nil;
    
    // Increment the index by one
    index++;
    self.pageControl.currentPage = index;
    
    if (index == [self.items count])
        return nil;
    
    // Get the view controller of the incremented index
    return [self viewControllerAtIndex:index];
}

@end
