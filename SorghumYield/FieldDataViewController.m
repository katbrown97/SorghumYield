//
//  FieldDataViewController.m
//  SorghumYield
//
//  Created by cis on 24/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//

#import "FieldDataViewController.h"
#import "UITextField+TFCustomization.h"
@interface FieldDataViewController ()

@end

@implementation FieldDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_fieldName addTarget:self action:@selector(checkFieldName) forControlEvents:UIControlEventEditingChanged];
    [_numberOfAcres addTarget:self action:@selector(checkNumOfAcres) forControlEvents:UIControlEventEditingChanged];
    
    [self setupView];
    [self setupPickerDataSource];
}
-(void) setupPickerDataSource{

    _rowSpacings = @[@"30",@"15",@"7.5"];
    _rowPicker.dataSource = self;
    _rowPicker.delegate = self;
    [_rowPicker reloadAllComponents];
}


-(void) setupView{
    [_fieldName addLeftViewText:@"Field Name"];
    [_numberOfAcres addLeftViewText:@"Acres"];
    
    [self addToolBarToKeyboardForUITF:_fieldName];
    [self addToolBarToKeyboardForUITF:_numberOfAcres];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) checkTextField{
    if(_fieldNameValid &&
       _numberOfAcresValid
       ){
        _nextButton.enabled=YES;
    }
    else{
        _nextButton.enabled=NO;
        
    }
}
-(void) checkFieldName{
    
    if([[_fieldName text] isEqualToString:@""]){
        _fieldNameError.hidden =false;
        _fieldNameValid = false;
    }
    else{
        _fieldNameError.hidden =true;
        _fieldNameValid = true;
    }
    [self checkTextField];
    
}
-(void) checkNumOfAcres{
    if([[_numberOfAcres text] isEqualToString:@"" ] || [[_numberOfAcres text] intValue] == 0  ){
        _numberOfAcresError.hidden =false;
        _numberOfAcresValid=false;
    }
    else{
        if([[_numberOfAcres text] characterAtIndex:0] == '0'){
            _numberOfAcresError.hidden =false;
            _numberOfAcresValid=false;
        }
        else{
            _numberOfAcresError.hidden =true;
            _numberOfAcresValid=true;
        }
    }
    [self checkTextField];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return 3;
            break;
        default:
            return 50;
            break;
    }
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [NSString stringWithFormat:@"%@", _rowSpacings[row]];
            break;
        default:
            return [NSString stringWithFormat:@"%ld", (long)row];
            break;
    }
}
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component{
    if (component != 0) return;
    [_rowSpacingImageView setImage:[UIImage imageNamed:[@"rowSpace" stringByAppendingString:_rowSpacings[row]]]];
}

- (IBAction)nextButtonPress:(id)sender {
    [self.managedObject setValue:self.fieldName.text forKey:@"fieldName"];
    [self.managedObject setValue:[NSNumber numberWithInt:[self.numberOfAcres.text intValue]] forKey:@"numOfAcres"];

    [self.managedObject setValue:[NSNumber numberWithFloat:[_rowSpacings[[_rowPicker selectedRowInComponent:0]] floatValue]] forKey:@"rowSpacing"];
    [self.managedObject setValue:[NSNumber numberWithInt:[_rowPicker selectedRowInComponent:1] ] forKey:@"headsPerThousandth"];
    
    [self performSegueWithIdentifier:@"fieldDataDone" sender:nil];
}
@end
