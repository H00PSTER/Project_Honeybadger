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
    /*NSMutableArray *testArray = [[NSMutableArray alloc] init];
    
    [testArray addObject:@"1"];
    [testArray addObject:@"2"];
    [testArray addObject:@"3"];
    [testArray addObject:@"4"];
    [testArray addObject:@"5"];
    */
    [self.invitedFriendNames addObject:optionsSingle.userInfo[@"name"]];
    
    for (int x = 0; x < [self.invitedFriendNames count]; x++)
    {
        int randInt = (arc4random() % ([self.invitedFriendNames count] - x)) + x;
        [self.invitedFriendNames exchangeObjectAtIndex:x withObjectAtIndex:randInt];
    }
    NSLog(@"%@", self.invitedFriendNames);
    self.randomPlayers = self.invitedFriendNames;
    [self assignTargets];
}


- (void) assignTargets
{
    
    for (int index = 0; index < self.randomPlayers.count; index++)
    {
        
        NSString *queryId;
        NSString *targetId;
        
        if(index == self.randomPlayers.count - 1)
        {
            queryId = self.randomPlayers[index];
            targetId = self.randomPlayers[0];
            NSLog (@"Target Id %@", queryId);
            NSLog(@"Hunter Id %@", targetId);
        }
        if(index != self.randomPlayers.count -1)
        {
            //change object
            queryId = self.randomPlayers[index];
            targetId = self.randomPlayers[index+1];
            
            NSLog(@"Target Id %@", queryId);
            NSLog(@"Hunter Id %@", targetId);
        }
        
    }
}




- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

{
    
    
    [self shuffleArrays];
    
    [self generateGameId];

}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *invitedFriendName = self.trueFriendNames[indexPath.row];
    NSLog(@"%@", invitedFriendName);
    
    
    [self.invitedFriendNames addObject:invitedFriendName];
    NSLog(@"%@", self.invitedFriendNames);
    
}


- (void) generateGameId
{
    int randomGameId = arc4random();
    NSString* GameId = [NSString stringWithFormat:@"%d", randomGameId];
    self.GameId = GameId;
    NSLog(@"%@", self.gameId);
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
    NSLog(@"%@", person);
    int index = 0;
    for (NSDictionary *user in person)
    {
    PFObject *user = person[index];
    [user setObject:self.gameId forKey:@"gameId"];
    [user save];
    NSLog(@"%@", self.gameId);
    NSLog(@"%@", user[@"name"]);
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
