//
//  IntroViewController.m
//  SorghumYield
//
//  Created by cis on 23/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//

#import "IntroViewController.h"
#import "FirebaseAuthUI.h"
#import "FUIAuthProvider.h"


@interface IntroViewController ()

@end

@implementation IntroViewController
@synthesize authUI, BtnGetStarted, BtnLogin;

FIRAuth *auth;
FUIAuth *authUI;
NSString *currentState;

- (void)viewDidLoad {
    [super viewDidLoad];
    currentState = @"homeView";
}
// Button for login
- (IBAction)login:(id)sender {
    // Check if user's login
    if(!auth.currentUser){
        auth = [FIRAuth auth];
        FUIAuth.defaultAuthUI.shouldHideCancelButton = true; // Disable back button on FirebaseUI sign in page
        authUI = [FUIAuth defaultAuthUI];
        authUI.delegate = self;
        UINavigationController *authViewController = [authUI authViewController];
        [self presentViewController:authViewController animated:true completion:Nil]; // Display the view for firebaseUI sign in
    }else{ // Otherwise sign out
        [self signOut];
        [self loginUIChange];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:true];
    [self loginUIChange]; // Check and see if login button needs to be changed
}

// Change the login button based on user login status
-(void)loginUIChange{
    if(!auth.currentUser){ // If user's not logged in
        [BtnLogin setTitle:@"Login" forState:UIControlStateNormal];
        [BtnGetStarted setEnabled:false];
    }else{ // user's logged in
        [BtnLogin setTitle:@"Logout" forState:UIControlStateNormal];
        [BtnGetStarted setEnabled:true];
    }
}

// Sign out method
- (void)signOut {
    NSError *error;
    [authUI signOutWithError:&error];
    if (error) {
        [self showAlertWithTitlte:@"Error" message:error.localizedDescription];
    }
}

// Sign out error handling
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
