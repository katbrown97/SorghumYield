//
//  ImageAcceptingViewController.m
//  SorghumYield
//
//  Created by cis on 26/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//

#import "ImageAcceptingViewController.h"
#include "ImageAnalysis.hpp"
#import <QuartzCore/QuartzCore.h>

const static bool animates= NO;

@interface ImageAcceptingViewController ()

@end

@implementation ImageAcceptingViewController









-(void) viewDidLoad{
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
    
    _imageAnalyzer = [[ImageAnalysis alloc] init];
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicator.center = self.view.center;
    _indicator.hidesWhenStopped = YES;
    _indicator.color = [UIColor blackColor];
    
    [self.view addSubview:_indicator];
    [_indicator startAnimating];
    
    
    // border radius
    [_roundedView.layer setCornerRadius:5.0f];
    // border
    [_roundedView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_roundedView.layer setBorderWidth:1.0f];
    
//    // drop shadow
//    [_roundedView.layer setShadowColor:[UIColor blackColor].CGColor];
//    [_roundedView.layer setShadowOpacity:0.3];
//    [_roundedView.layer setShadowRadius:2.0];
//    [_roundedView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    _roundedView.layer.masksToBounds = true;
    
}
-(void) viewDidAppear:(BOOL)animated{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self handleSelectedImage:_measurementHolder.originalImage withLoaderIndicator:NULL];
            [_indicator stopAnimating];
            
        });
    });
}

- (void)delayedComputation
{
    [self handleSelectedImage:_measurementHolder.originalImage withLoaderIndicator:NULL];
    [_indicator stopAnimating];
}

- (void) handleSelectedImage:(UIImage *)chosenImage withLoaderIndicator:(UIActivityIndicatorView *) indicator {
    
    NSNumber *  analysisAreaResult= 0;
    
    _measurementHolder.processedImage=[[self imageAnalyzer] analysis:chosenImage :&analysisAreaResult: NULL];
    
    if(_measurementHolder.processedImage == NULL){
        [_measurementHolder setMeasurementStatus: INVALID];
        [self.navigationController popViewControllerAnimated:animates];
    }
    else{
        [_measurementHolder setAppArea:analysisAreaResult];
        
        [_indicator stopAnimating];
        [self displayCurrentImage];
        [_sizeLabel setText:[NSString stringWithFormat:@"Area of the head is : %.2lf inches²", [[_measurementHolder appArea] doubleValue]]];
    }
}
- (void) displayCurrentImage{
    self.imageView.image= [_measurementHolder processedImage];
}

- (IBAction)acceptImage:(UIButton *)sender {
    [_measurementHolder setMeasurementStatus: ACCEPTED];
    [self.navigationController popViewControllerAnimated:animates];
}
- (IBAction)dismissImage:(UIButton *)sender {
    [_measurementHolder setMeasurementStatus: DISMISSED];
    [self.navigationController popViewControllerAnimated:animates];
    
}


@end
