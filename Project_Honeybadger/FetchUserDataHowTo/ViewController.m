/*
 * Copyright 2012 Facebook
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "ViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface ViewController ()



@property (strong, nonatomic) FBFriendPickerViewController *friendPickerController;
@property (weak, nonatomic) IBOutlet FBLoginView *loginView;
@property (unsafe_unretained, nonatomic) IBOutlet UITextView *userInfoTextView;
@property NSArray *myFriends;
@property NSDictionary *myInfo;




@end

@implementation ViewController

@synthesize userInfoTextView;







- (IBAction)pickFriends:(id)sender {
    
    self.friendPickerController = [[FBFriendPickerViewController alloc] init];
    self.friendPickerController.title = @"Pick Friends";
    self.friendPickerController.delegate = self;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.loginView.readPermissions = @[@"basic_info",
                                       @"user_location",
                                       @"user_birthday",
                                       @"user_likes"];

}

- (void)viewDidUnload
{
    [self setUserInfoTextView:nil];
    [self setLoginView:nil];
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}










- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    self.userInfoTextView.hidden = NO;
    
       [FBRequestConnection
     startForMeWithCompletionHandler:^(FBRequestConnection *connection, id<FBGraphUser> user, NSError *error) {
         if (!error) {
             
             [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id data, NSError *error)
             {
            
                 if(error)
                 {
                     NSLog(@"Error: %@", error);
                     return;
                 }
                 
                 NSString *userName = (@"");
                 NSString *userId = (@"");
                 
                 userName = [userName stringByAppendingString: user.name];
                 userId = [userId stringByAppendingString: user.id];
           
                 NSArray* friends = (NSArray*)[data data];
                 self.myFriends = (NSArray*)[data data];
                 
                 
                 NSDictionary *user = @{@"id":userId, @"name":userName};
                 self.myInfo = user;
                 self.myFriends = friends;
                 [self createParseObjectLoop];
             }];
             
             
         }
            
     }];
    
    
  
}


- (void) createParseObjectLoop
{
    PFQuery * query = [PFQuery queryWithClassName: @"Player"];
    query.limit = 1000;
    [query findObjectsInBackgroundWithTarget:self
                                    selector: @selector(loadPersonCallback:error:)];

}

-(void) checkParseObjectLoop
{
    PFQuery * query = [PFQuery queryWithClassName: @"Player"];
    query.limit = 1000;
    [query findObjectsInBackgroundWithTarget:self
                                    selector: @selector(loadPersonCallback:error:)];
}

- (void) loadPersonCallback: (NSArray*) person error: (NSError*) error
{
    
    if (!error)
    {
    
        
        for (NSDictionary *facebookFriend in self.myFriends)
        {
            PFObject *player = [PFObject objectWithClassName:@"Player"];

            int doesExist = 0;
            
            for (NSDictionary *parseFriend in person)
            {
                NSString *parseId = parseFriend[@"facebookId"];
                NSString *facebookId = facebookFriend[@"id"];
                
                
                if ([facebookId isEqualToString:parseId])
                {
                    doesExist++;
                }
            }
        if (doesExist != 1)
        {
            player[@"name"] = facebookFriend[@"name"];
            player[@"facebookId"] = facebookFriend[@"id"];
            player[@"hasLoggedOn"] = @"false";
            [player saveInBackground];
            
        }
            
        }
    }
}







- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.userInfoTextView.hidden = YES;
}
@end