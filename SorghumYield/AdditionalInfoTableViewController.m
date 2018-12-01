//
//  AdditionalInfoTableViewController.m
//  SorghumYield
//
//  Created by cis on 27/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//

#import "AdditionalInfoTableViewController.h"
#import "IntroViewController.h"

@implementation AdditionalInfoTableViewController

- (IBAction)logout:(id)sender {
    [self signOut];
}

- (void)signOut {
    NSError *error;
    IntroViewController *class1 = [[IntroViewController alloc] init];
    FUIAuth *authUI2 = class1.authUI;
    [authUI2 signOutWithError:&error];
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

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
    
    [self setTitle:@"Additional Information"];
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setGroupingSeparator:[[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator]];
    [formatter setGroupingSize:3];
    
    NSString * toSet = [formatter stringFromNumber:_finalYield];
    
    [_finalYieldLabel setText:[toSet stringByAppendingString:@" bushels"]];
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1 && indexPath.row == 0){
        NSString *html = @"http://www.agronomy.k-state.edu/extension/crop-production/grain-sorghum/";
        NSURL *url = [NSURL URLWithString:html];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        
    }
    if(indexPath.section==1 && indexPath.row == 1){
        NSString *html = @"http://www.bookstore.ksre.ksu.edu/pubs/c687.pdf";
        NSURL *url = [NSURL URLWithString:html];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        
    }

}

// Home button action
- (IBAction)HomeButton:(UIButton *)sender {
    [[self navigationController] popToRootViewControllerAnimated:true];
}
@end
