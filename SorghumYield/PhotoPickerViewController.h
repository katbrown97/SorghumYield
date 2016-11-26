//
//  PhotoPickerViewController.h
//  SorghumYield
//
//  Created by cis on 26/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Measurement.h"
#import <CoreData/CoreData.h>
#import "BaseViewController.h"

static int MinImageCount = 2;


static dispatch_once_t predicate;


static NSString * DuplicateImageError  = @"You have already selected this image, please choose another one";
static NSString * InvalidImageError = @"Your image could not be analyzed. Make sure you have avoided all common mistakes, and taken the image under good lighting conditions. Avoid strong shadows";
static NSString * StatusAccepted = @"CHOOSE NEXT";
static NSString * StatusDismissed= @"You specified that green outline does not match the plant, therefore it will not be counted in the calculation. Try to take the image again";
static NSString * FINISHSTRING= @"CLICK NEXT";

static NSString * ADDIMAGE= @"ADD %d MORE IMAGE%@";

@interface PhotoPickerScreenViewController : BaseViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>


@property (strong, nonatomic) IBOutlet UIButton * yieldButton;

@property (strong, nonatomic) IBOutlet UITableView * tableView;



- (IBAction)takePhoto:(UIButton *)sender;

- (IBAction)selectPhoto:(UIButton *)sender;

- (IBAction)yieldButtonPress:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (strong, nonatomic) IBOutlet UIButton *selectPhotoButton;


@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@property NSMutableArray * measurements;
@property Measurement * currentMeasurement;

@end
