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
}

@property (nonatomic) NSDictionary *userInfo;

+(GlobalVariables *) singleObject;

@end
