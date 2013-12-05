//
//  GameViewController.h
//  FetchUserDataHowTo
//
//  Created by Andrew Peterson on 11/21/13.
//  Copyright (c) 2013 Facebook Inc. All rights reserved.
//
#import "GlobalVariables.h"
#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController
{
    GlobalVariables *optionsSingle;
}
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end
