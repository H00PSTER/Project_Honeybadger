//
//  MainViewController.m
//  FetchUserDataHowTo
//
//  Created by apeter41 on 11/20/13.
//  Copyright (c) 2013 Facebook Inc. All rights reserved.
//
#import "AppDelegate.h"
#import  <Parse/Parse.h>
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
    [self checkParseForGameId];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) checkParseForGameId
{
    NSString *userId = optionsSingle.userInfo[@"id"];;
    
    //We need to just query for the user's id.
    
    
    PFQuery * query = [PFQuery queryWithClassName: @"Player"];
    [query whereKey:@"facebookId" equalTo:userId];
    query.limit = 1000;
    [query findObjectsInBackgroundWithTarget:self
                                    selector: @selector(loadGameId:error:)];
    
}

- (void) loadGameId: (NSArray*) person error: (NSError*) error
{
    for (NSDictionary *userInfo in person)
    {
        if (userInfo[@"gameId"] != nil)
        {
            
            //Triggers join button to light up
            NSLog(@"%@", userInfo[@"gameId"]);
        }
    }
}
    



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
