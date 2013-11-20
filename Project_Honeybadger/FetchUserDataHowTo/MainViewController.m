//
//  MainViewController.m
//  FetchUserDataHowTo
//
//  Created by apeter41 on 11/20/13.
//  Copyright (c) 2013 Facebook Inc. All rights reserved.
//
#import "AppDelegate.h"

#import "MainViewController.h"
#import "GlobalVariables.h"
#import "ViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    optionsSingle = [GlobalVariables singleObject];
    NSLog(@"%@", optionsSingle.userInfo);
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
