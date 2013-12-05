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


-(void) loadPersonCallback: (NSArray*) person error: (NSError*) error
{

    PFObject *user = person[0];
    [user setObject:self.two forKey:@"recieverId"];
    [user save];
    
    
    

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

{
    
    
    [self shuffleArrays];
    
    [self generateGameId];

}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *invitedFriendName = self.trueFriendNames[indexPath.row];
    
    
    [self.invitedFriendNames addObject:invitedFriendName];
    
}


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

- (void) assignParseObjectsWithIds: (NSArray*) person error: (NSError*) error
{
    int index = 0;
    for (NSDictionary *user in person)
    {
    PFObject *user = person[index];
    [user setObject:self.gameId forKey:@"gameId"];
    [user setObject:@"true" forKey:@"recieverId"];
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
