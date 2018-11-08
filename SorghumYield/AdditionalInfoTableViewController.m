//
//  AdditionalInfoTableViewController.m
//  SorghumYield
//
//  Created by cis on 27/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//

#import "AdditionalInfoTableViewController.h"

@implementation AdditionalInfoTableViewController

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
    //[self presentViewController:IntroViewController animated:YES completion:nil];
    //[self presentViewController:[[IntroViewController alloc] init] animated:YES completion:nil];
    [[self navigationController] popToRootViewControllerAnimated:true];
//    UIViewController *ivc = [self.storyboard instantiateViewControllerWithIdentifier:@"IVC"];
//    [self.navigationController pushViewController:ivc animated:true];
}
@end
