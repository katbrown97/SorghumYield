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
@synthesize authUI, BtnGetStarted, BtnLogin;

FIRAuth *auth;
FUIAuth *authUI;

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)login:(id)sender {
    if(!auth.currentUser){
        auth = [FIRAuth auth];
        FUIAuth.defaultAuthUI.shouldHideCancelButton = true;
        authUI = [FUIAuth defaultAuthUI];
        authUI.delegate = self;
        // Objective-C
        UINavigationController *authViewController = [authUI authViewController];
        authViewController.navigationItem.leftBarButtonItem = Nil;
        [self presentViewController:authViewController animated:true completion:Nil];
    }else{
        [self signOut];
        [self loginUIChange];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:true];
    [self loginUIChange];
}

-(void)loginUIChange{
    if(!auth.currentUser){
        [BtnLogin setTitle:@"Login" forState:UIControlStateNormal];
        [BtnGetStarted setEnabled:false];
    }else{
        [BtnLogin setTitle:@"Logout" forState:UIControlStateNormal];
        [BtnGetStarted setEnabled:true];
    }
}

- (void)signOut {
    NSError *error;
    [authUI signOutWithError:&error];
    if (error) {
        [self showAlertWithTitlte:@"Error" message:error.localizedDescription];
    }
}

- (void)showAlertWithTitlte:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* closeButton = [UIAlertAction
                                  actionWithTitle:@"Close"
                                  style:UIAlertActionStyleDefault
                                  handler:nil];
    [alert addAction:closeButton];
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
