//
//  ImageAcceptingViewController.h
//  SorghumYield
//
//  Created by cis on 26/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Measurement.h"
#import "BaseViewController.h"
@class ImageAnalysis;

@interface ImageAcceptingViewController : BaseViewController


@property (nonatomic,strong) ImageAnalysis * imageAnalyzer;


@property (strong, nonatomic) UIImage * imageToDisplay;
@property UIActivityIndicatorView *indicator;

- (void) displayCurrentImage;

@property (strong, nonatomic) IBOutlet UIView * roundedView;

- (void) handleSelectedImage:(UIImage *)chosenImage withLoaderIndicator:(UIActivityIndicatorView *) indicator;

@property (strong) Measurement * measurementHolder;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)acceptImage:(UIButton *)sender;
- (IBAction)dismissImage:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;



@end
