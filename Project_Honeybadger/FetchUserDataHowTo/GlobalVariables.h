//
//  GlobalVariables.h
//  Orchid
//
//  Created by apeter41 on 11/16/13.
//  Copyright (c) 2013 Andrew Peterson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalVariables : NSObject
{
    NSDictionary *userInfo;
    NSArray *userFriends;
    NSArray *trueFriendNames;
}

@property (nonatomic) NSDictionary *userInfo;
@property (nonatomic) NSArray *userFriends;
@property (nonatomic) NSArray *trueFriendNames;
+(GlobalVariables *) singleObject;

@end
