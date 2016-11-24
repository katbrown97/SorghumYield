//
//  FieldDataViewController.h
//  SorghumYield
//
//  Created by cis on 24/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "BaseViewController.h"

@interface FieldDataViewController : BaseViewController<UIPickerViewDataSource, UIPickerViewDelegate>


@property (strong, nonatomic) IBOutlet UITextField *fieldName;
@property (strong, nonatomic) IBOutlet UILabel *fieldNameError;
@property bool fieldNameValid ;

@property (strong, nonatomic) IBOutlet UITextField *numberOfAcres;
@property (strong, nonatomic) IBOutlet UILabel *numberOfAcresError;
@property bool numberOfAcresValid ;

@property (strong, nonatomic) IBOutlet UIPickerView *rowPicker;

@property (strong, nonatomic) IBOutlet UIButton *nextButton;

@property (strong, nonatomic) NSArray * rowSpacings;
@property (strong, nonatomic) IBOutlet UIImageView *rowSpacingImageView;

-(void) checkTextField;
-(void) checkFieldName;
-(void) checkNumOfAcres;
@end

