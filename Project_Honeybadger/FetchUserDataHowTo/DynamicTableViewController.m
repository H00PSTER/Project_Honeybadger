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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

{
    
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
    PFQuery * query = [PFQuery queryWithClassName: @"Player"];
    [query whereKey:@"name" equalTo:self.tempUserName];
    query.limit = 1000;
    [query findObjectsInBackgroundWithTarget:self
                                    selector: @selector(assignParseObjectsWithIds:error:)];
    
}

- (void) assignParseObjectsWithIds: (NSArray*) person error: (NSError*) error
{
    
    PFObject *user = person[0];
    [user setObject:self.gameId forKey:@"gameId"];
    [user save];
    NSLog(@"%@", self.gameId);
    NSLog(@"%@", user[@"name"]);
    
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
