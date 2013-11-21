//
//  DynamicTableViewController.m
//  FetchUserDataHowTo
//
//  Created by Andrew Peterson on 11/15/13.
//  Copyright (c) 2013 Facebook Inc. All rights reserved.
//

#import "DynamicTableViewController.h"
#import "GlobalVariables.h"

@interface DynamicTableViewController ()

@property NSArray *dynamicList;
@property NSArray *trueFriendNames;

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
    self.trueFriendNames = optionsSingle.trueFriendNames;
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source









- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return optionsSingle.trueFriendNames.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"titleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    
    NSString *dynamicIndexPaths = optionsSingle.trueFriendNames[indexPath.row];
    
    cell.textLabel.text = dynamicIndexPaths;
    
    return cell;
}

@end
