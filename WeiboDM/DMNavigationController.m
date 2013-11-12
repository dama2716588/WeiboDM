//
//  DMNavigationController.m
//  WeiboDM
//
//  Created by ma yulong on 13-6-10.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import "DMNavigationController.h"

@interface DMNavigationController ()

@end

@implementation DMNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationBar.tintColor = [UIColor blackColor];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(BOOL)shouldAutorotate
{
    return [self.viewControllers.lastObject shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Pop Animation

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //TODO: 
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    //FIXME: 
    return [super popViewControllerAnimated:animated];
}

@end