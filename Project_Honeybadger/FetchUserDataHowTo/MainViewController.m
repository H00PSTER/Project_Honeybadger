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

@property NSArray *trueFriends;

- (IBAction)onClickJoin:(id)sender;


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
    //NSLog(@"%@", optionsSingle.userInfo);
    
    [self checkParseForGameId];
    [self checkTrueParseObjectLoop];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void) onClickJoin:(id)sender
{
    [self hasAcceptedInvite];
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
            //NSLog(@"%@", userInfo[@"gameId"]);
        }
    }
}
    

- (void) hasAcceptedInvite
{
    
    NSString *userId = optionsSingle.userInfo[@"id"];
    
    PFQuery * query = [PFQuery queryWithClassName: @"Player"];
    [query whereKey:@"facebookId" equalTo:userId];
    query.limit = 1000;
    [query findObjectsInBackgroundWithTarget:self
                                    selector: @selector(updateInviteState:error:)];
    
}

- (void) updateInviteState: (NSArray*) person error: (NSError*) error
{
    NSString *hasAcceptedInvite = @"true";
    PFObject *user = person[0];
    [user setObject:hasAcceptedInvite forKey:@"hasAccepted"];
    [user save];
    //NSLog (@"The User accepted Invite");
    
}




- (void) checkTrueParseObjectLoop
{
    PFQuery * query = [PFQuery queryWithClassName: @"Player"];
    query.limit = 1000;
    [query findObjectsInBackgroundWithTarget:self
                                    selector: @selector(mutualFriendsWithApp:error:)];
}


- (void) mutualFriendsWithApp: (NSArray*) person error: (NSError*) error


{
    if (!error)
    {
        NSMutableArray *trueParseFriends = [[NSMutableArray alloc] init];
        
        for (NSDictionary *parseFriend in person)
        {
            
            if ([parseFriend[@"hasLoggedOn"] isEqualToString: @"true"])
                
            {
                
                [trueParseFriends addObject:parseFriend];
            }
        }
        self.trueFriends = trueParseFriends;
        [self checkForMutualTrueFriends];
    }
}


- (void) checkForMutualTrueFriends
{
    NSMutableArray *trueFacebookFriends = [[NSMutableArray alloc] init];
    
    for (NSDictionary *trueFriendInfo in self.trueFriends)
    {
        
        for (NSDictionary *facebookFriend in optionsSingle.userFriends)
        {
            NSString *trueFriendId = trueFriendInfo[@"facebookId"];
            NSString *facebookFriendId = facebookFriend[@"id"];
            if ([trueFriendId isEqualToString:facebookFriendId])
            {
                [trueFacebookFriends addObject: facebookFriend[@"name"]];
            }
        }
        
    }
    optionsSingle.trueFriendNames = trueFacebookFriends;
    //NSLog(@"%@", optionsSingle.trueFriendNames);
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)joinGame:(id)sender {
}
@end
