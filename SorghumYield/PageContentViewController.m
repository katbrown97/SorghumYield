//
//  PageContentViewController.m
//  SorghumYield
//
//  Created by cis on 26/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    self.titleLabel.text = self.titleText;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    
    if(_pageIndex==1){
        _orLabel.hidden=false;
        _downloadButton.hidden=false;
    }
    else{
        _orLabel.hidden=true;
        _downloadButton.hidden=true;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)downloadSheet:(id)sender {
    UIImageWriteToSavedPhotosAlbum([UIImage imageNamed:@"MeasureSheet"], nil, nil, nil);
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Image Saved"
                                                                   message:@"Measure sheet is available in your photo gallery now, simply print it."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:nil];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end

