//
//  IntroViewController.m
//  SorghumYield
//
//  Created by cis on 23/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//

#import "IntroViewController.h"
#import "FirebaseUI.h"
#import "FUIAuthProvider.h"


@interface IntroViewController ()

@end

@implementation IntroViewController

FIRAuth *auth;
FUIAuth *authUI;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self disableBackButton];
    
    auth = [FIRAuth auth];
    authUI = [FUIAuth defaultAuthUI];
    authUI.delegate = self;
    // Objective-C
    UINavigationController *authViewController = [authUI authViewController];
    [self presentViewController:authViewController animated:true completion:Nil];
}


@end
