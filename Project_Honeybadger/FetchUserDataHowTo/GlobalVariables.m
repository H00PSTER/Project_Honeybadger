//
//  GlobalVariables.m
//  Orchid
//
//  Created by apeter41 on 11/16/13.
//  Copyright (c) 2013 Andrew Peterson. All rights reserved.
//

#import "GlobalVariables.h"

@implementation GlobalVariables
{
    GlobalVariables * anotherSingle;
}

@synthesize userInfo;

+(GlobalVariables *) singleObject
{
    static GlobalVariables *single = nil;
    @synchronized(self)
    {
        if (!single)
        {
            single = [[GlobalVariables alloc] init];
        }
    }
    return single;
}


@end

