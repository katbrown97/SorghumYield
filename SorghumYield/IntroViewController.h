//
//  IntroViewController.h
//  SorghumYield
//
//  Created by cis on 23/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "FirebaseUI.h"

@interface IntroViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *BtnGetStarted;
@property (nonatomic, strong) FUIAuth *authUI;
@property (weak, nonatomic) IBOutlet UIButton *BtnLogin;
@end

