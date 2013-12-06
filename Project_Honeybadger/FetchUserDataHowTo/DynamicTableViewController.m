//
//  DynamicTableViewController.m
//  FetchUserDataHowTo
//
//  Created by Andrew Peterson on 11/15/13.
//  Copyright (c) 2013 Facebook Inc. All rights reserved.
//

#import "DynamicTableViewController.h"
#import "GlobalVariables.h"
#import <Parse/Parse.h>

@interface DynamicTableViewController ()

@property NSArray *dynamicList;
@property NSArray *trueFriendNames;
@property NSMutableArray *invitedFriendNames;
@property NSMutableArray *randomPlayers;
@property NSString *gameId;
@property NSString *tempUserName;
@property NSString *one;
@property NSString *two;
@property NSNumber *userIndex;
@property PFObject *user;
@property NSString* randomString;

@end

@implementation DynamicTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
    }
    return self;
}



- (void)viewDidLoad
{
    
    optionsSingle = [GlobalVariables singleObject];
    NSMutableArray *invitedFriendNames = [[NSMutableArray alloc] init];
    self.invitedFriendNames = invitedFriendNames;
    self.trueFriendNames = optionsSingle.trueFriendNames;
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source


// This method takes the array of names that you have invited to the game and shuffles them up. This is how we decided targets.
//Each person in the array will be targeting their index in the array + 1, except the last person in the array who will be getting index 0

- (void) shuffleArrays
{

    [self.invitedFriendNames addObject:optionsSingle.userInfo[@"name"]];
    
    for (int x = 0; x < [self.invitedFriendNames count]; x++)
    {
        int randInt = (arc4random() % ([self.invitedFriendNames count] - x)) + x;
        [self.invitedFriendNames exchangeObjectAtIndex:x withObjectAtIndex:randInt];
    }
    self.randomPlayers = self.invitedFriendNames;
}

// This method was set up to transfer data between classes. I cannot say if that was ever successfully done
// it calls the method that sets up the targets, and the method that assigns a common gameId

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

{
    
    
    [self shuffleArrays];
    
    [self generateGameId];

}


// This method takes all of the friends that you click on on the invite screen and puts them into an array that we can then performe logic on

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *invitedFriendName = self.trueFriendNames[indexPath.row];
    
    
    [self.invitedFriendNames addObject:invitedFriendName];
    
}


// This is the method that generates the common game id that we use to identify who is in the game we are in and who is not. The id is random

- (void) generateGameId
{
    int randomGameId = arc4random();
    NSString* GameId = [NSString stringWithFormat:@"%d", randomGameId];
    self.GameId = GameId;
    for (NSString *userName in self.invitedFriendNames)
    {
        self.tempUserName = userName;
        [self assignGameId];
    }
}

// This is the method that queries for each of the invited players' game objects to use in the chosen selector method

-(void) assignGameId

{
    int i = 0;
    for (NSString *invitedUserName in self.invitedFriendNames)
    {
        PFQuery * query = [PFQuery queryWithClassName: @"Player"];
        [query whereKey:@"name" equalTo:self.invitedFriendNames[i]];
        query.limit = 1000;
        [query findObjectsInBackgroundWithTarget:self
                                            selector: @selector(assignParseObjectsWithIds:error:)];

        i++;
    }
    
}

// This is the afore mentioned selector method. It takes the game objects of each of the players and assigns them the common game id and the shuffled array of the same players that we use to assign targets

- (void) assignParseObjectsWithIds: (NSArray*) person error: (NSError*) error
{
    int index = 0;
    for (NSDictionary *user in person)
    {
    PFObject *user = person[index];
    [user setObject:self.gameId forKey:@"gameId"];
    [user setObject:self.randomPlayers forKey:@"targetArray"];
    [user save];
    index++;
     }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.trueFriendNames.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"titleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    
    NSString *dynamicIndexPaths = self.trueFriendNames[indexPath.row];
    
    cell.textLabel.text = dynamicIndexPaths;
    
    return cell;
}

@end
