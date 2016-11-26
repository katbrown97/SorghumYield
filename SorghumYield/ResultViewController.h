//
//  ResultViewController.h
//  SorghumYield
//
//  Created by cis on 26/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//

@import Firebase;
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BaseViewController.h"

static NSString * SubmitWarning  = @"Do you agree with a report being submitted to the researchers at K-State university, containing the data and images you selected? This data will be used for further research and improving the precision of this app. \n Note: This may use some of your cellular data.";

@interface ResultViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *sliderCaption;
@property (weak, nonatomic) IBOutlet UISlider *sliderValue;

@property (strong, nonatomic) IBOutlet UIButton *submitButton;

@property NSArray* keyData;
@property NSMutableArray * valueData;

- (IBAction)sizeSlider:(id)sender;
- (IBAction)submit:(id)sender;
@property (strong, nonatomic) IBOutlet UIView  *submitView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) NSNumber * appAreaAverage;
@property (strong, nonatomic) NSNumber * grainsPerPlant;
@property (strong, nonatomic) NSNumber * numberOfPlantsPerAcre;
@property (strong, nonatomic) NSNumber * numberOfAcres;
@property (strong, nonatomic) NSNumber * seedsPerPound;
@property (strong, nonatomic) NSNumber * weightPerPlant;
@property (strong, nonatomic) NSNumber * yieldPerAcre;
@property (strong, nonatomic) NSNumber * yieldPerAcreBU;
@property (strong, nonatomic) NSNumber * totalYield;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;


@property (strong, nonatomic) FIRDatabaseReference * ref;
@property (strong) NSNumberFormatter *formatter;

@end
