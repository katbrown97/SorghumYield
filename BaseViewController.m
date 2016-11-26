//
//  BaseViewController.m
//  SorghumYield
//
//  Created by cis on 23/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self setToolbar];
}

- (void)setToolbar{
    _numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    _numberToolbar.barStyle = UIBarStyleDefault;
    _numberToolbar.items = [NSArray arrayWithObjects:
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                            nil];
    [_numberToolbar sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setBackgroundImage: (NSString * ) imageNameString{
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageNameString]];
    [self.view addSubview:backgroundView];
    backgroundView.frame = self.view.bounds;
    backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view sendSubviewToBack:backgroundView];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController* nextVC = segue.destinationViewController;
    if( [nextVC isKindOfClass:[BaseViewController class]] ) {
        [nextVC setValue:self.managedObject forKey:@"managedObject"];
    }
}
- (void) doneWithNumberPad{
    [self.view endEditing:YES];
}


- (void) addToolBarToKeyboardForUITF:(UITextField *) textField  {
    
    textField.inputAccessoryView = _numberToolbar;
}
-(void ) presentAlert:(NSString * ) stringToDisplay withTitle:(NSString * ) title{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:stringToDisplay
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:nil];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)disableBackButton{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
}


@end
