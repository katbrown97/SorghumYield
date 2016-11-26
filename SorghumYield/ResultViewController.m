//
//  ResultViewController.m
//  SorghumYield
//
//  Created by cis on 26/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//

#import "ResultViewController.h"
#import <CoreData/CoreData.h>

#import "FirebaseManager.h"

static NSString * baseText = @"Seeds per lb";

@implementation ResultViewController
{
    
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _keyData =  @[@"Average Plant Area",
                  @"Grain count per plant" ,
                  @"Plants per acre",
                  
                  @"Seeds Per Pound",
                  @"Weight per plant(lb)",
                  @"Yield Per acre (lb)",
                  @"Yield Per acre (bu)",
                  ];
    _valueData = [[NSMutableArray alloc] init];
    
    
    _formatter = [[NSNumberFormatter alloc] init];
    [_formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [_formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    [self initStaticData];
    
    [self reCalculateValues];
    
    [self prepareView];
    
}
-(void) prepareView{
    [self setTitle:@"Yield prediction"];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
    
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setBackgroundView:nil];
    
    _submitView.layer.cornerRadius = 5;
    _submitView.layer.masksToBounds = YES;
}

-(void) initStaticData{
    [self setAppAreaAverage:[NSNumber numberWithFloat:[[self.managedObject valueForKey:@"appAreaAverage"] floatValue]]];
    [self setGrainsPerPlant:[NSNumber numberWithInt:(int)((113.6 * [_appAreaAverage floatValue]) + 236.38f) ]];
    
    int headsPerAcreRow = [[self.managedObject valueForKey:@"headsPerThousandth"] intValue];
    NSNumber *  rowsPerAcre = [self.managedObject valueForKey:@"rowSpacing"];
    
    NSNumber * headsPerAcre = [NSNumber numberWithInt:(43560 * headsPerAcreRow)/(([rowsPerAcre floatValue]/12)*17.5)];
    
    [self setNumberOfPlantsPerAcre:headsPerAcre];
    [self setNumberOfAcres:[self.managedObject valueForKey:@"numOfAcres"]];
    [_valueData insertObject:[_appAreaAverage stringValue] atIndex:0];
    [_valueData insertObject:[_grainsPerPlant stringValue] atIndex:1];
    [_valueData insertObject:[_numberOfPlantsPerAcre stringValue] atIndex:2];
}
-(void) updateTableViewSource{
    
    [_valueData insertObject:[_seedsPerPound stringValue] atIndex:3];
    [_valueData insertObject:[_formatter stringFromNumber:_weightPerPlant] atIndex:4];
    [_valueData insertObject:[_yieldPerAcre stringValue] atIndex:5];
    [_valueData insertObject:[_yieldPerAcreBU stringValue] atIndex:6];
    [self.tableView reloadData];
}



- (IBAction)sizeSlider:(id)sender {
    [_nextButton setEnabled:true];
    [self reCalculateValues];
}
-(void) reCalculateValues{
    [self setSeedsPerPound:[NSNumber numberWithInteger:_sliderValue.value]];
    
    [_sliderCaption setText:[baseText stringByAppendingString:[NSString stringWithFormat:@" - %d", [_seedsPerPound intValue]]]];
    NSNumber * seedWeight = [NSNumber numberWithDouble:(1.0f/self.seedsPerPound.doubleValue)];
    double weightPerPlant = [seedWeight doubleValue] * [_grainsPerPlant floatValue];
    
    [self setWeightPerPlant:[NSNumber numberWithDouble: weightPerPlant]];
    
    [self setYieldPerAcre:[NSNumber numberWithLong:([_weightPerPlant floatValue] * [_numberOfPlantsPerAcre floatValue] )]];
    
    [self setYieldPerAcreBU:[NSNumber numberWithLong:([_yieldPerAcre floatValue]/56)]];
    [self setTotalYield:[NSNumber numberWithLong:[_yieldPerAcre floatValue]/56 * [_numberOfAcres intValue]]];
    [self updateTableViewSource];
    
}

- (IBAction)submit:(id)sender {
    
    [_submitView setHidden:YES];
    [self.managedObject setValue:_seedsPerPound  forKey:@"seedsPerPound"];
    [self.managedObject setValue:_yieldPerAcre  forKey:@"yieldPerAcre"];
    [self.managedObject setValue:_totalYield  forKey:@"totalYield"];
    
    NSLog(@"%@\n\n-------Final--------------------------------------", self.managedObject);
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Submitting report"
                                                                   message:SubmitWarning
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Agree"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [self sendReport];
                                    
                                }];
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Disagree"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   [self performSegueWithIdentifier:@"AdditionalInfoSegue" sender:self];
                               }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void) sendReport{
    
    _ref = [[FIRDatabase database] reference];
    FIRDatabaseReference * measurementRef = [[_ref child:@"measurements"] childByAutoId];
    
    NSManagedObject * autoGPSCoordinates =[self.managedObject valueForKey:@"autoGPSData"];
    NSManagedObject * manualGPSCoordinates =[self.managedObject valueForKey:@"manualGPSData"];
    NSNumber * lat=[NSNumber numberWithInt:0];
    NSNumber * lon=[NSNumber numberWithInt:0];
    NSString * countryName=@"";
    NSString * stateName=@"";
    NSString * countyName=@"";
    
    if( autoGPSCoordinates!=nil){
        lat =[autoGPSCoordinates valueForKey:@"lat"];
        lon =[autoGPSCoordinates valueForKey:@"lon"];
    }
    else{
        countryName= [manualGPSCoordinates valueForKey:@"countryName"];
        stateName = [manualGPSCoordinates valueForKey:@"stateName"];
        countyName = [manualGPSCoordinates valueForKey:@"countyName"];
    }
    [measurementRef setValue:@{
                               @"fieldName":        [self.managedObject valueForKey:@"fieldName"],
                               
                               @"numOfAcres":       [self.managedObject valueForKey:@"numOfAcres"],
                               
                               @"numberOfHeadsPerThousandth": [self.managedObject valueForKey:@"headsPerThousandth"],
                               @"rowSpacing":       [self.managedObject valueForKey:@"rowSpacing"],
                               
                               
                               @"AutoGPS":          @{
                                       @"lat":      lat,
                                       @"lon":      lon
                                       },
                               @"ManualGPS":          @{
                                       @"country":      countryName,
                                       @"state":      stateName,
                                       @"county":      countyName
                                       },
                               
                               @"appAreaAverage":   [_appAreaAverage stringValue],
                               @"seedsPerPound":    [_seedsPerPound stringValue],
                               @"grainCount":       [_grainsPerPlant stringValue],
                               @"yieldPerAcre":   [_yieldPerAcre stringValue],
                               @"totalYield":   [_totalYield stringValue]
                               }
     ];
    [self storeImages:measurementRef];
    
    [self performSegueWithIdentifier:@"AdditionalInfoSegue" sender:self];
    
}
-(void) storeImages : (FIRDatabaseReference*) measurementRef{
    
    NSMutableSet * measurements = [self.managedObject valueForKey:@"measurements"];
    
    FIRDatabaseReference * photoMeasurementRef = [measurementRef child:@"photoMeasurements"];
    
    FIRStorage *storage = [FIRStorage storage];
    
    // Create a storage reference from our storage service
    FIRStorageReference *storageRef = [storage referenceForURL:@"gs://sorghumbuild.appspot.com"];
    
    
    NSString * measurementRefKey =[measurementRef key];
    
    FIRStorageReference * folder = [storageRef child:measurementRefKey];
    NSData * fileData =[[NSString stringWithFormat:@"%@", self.managedObject]dataUsingEncoding: NSUTF8StringEncoding ];
    
    [[FirebaseManager sharedFirebaseManager] prepareFileUpload:folder :@"Report" withExtension:@"txt" andDataSource:fileData];
    
    for(NSManagedObjectModel * measurementObject in measurements){
        
        NSString * childID = [[measurementObject valueForKey:@"measurementID"] stringValue];
        FIRDatabaseReference * photoMeasurementInstance = [photoMeasurementRef child:childID];
        
        [photoMeasurementInstance setValue:@{@"appArea" :[measurementObject valueForKey:@"appArea"] }];
        
        NSData * imageData =[measurementObject valueForKey:@"processedImage"];
        
        [[FirebaseManager sharedFirebaseManager] prepareFileUpload:folder :childID withExtension:@"jpg" andDataSource:imageData];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section ==0){
        return @"Your data";
    }
    if(section ==1){
        return @"Your results";
    }
    else return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 3;
    }
    if(section ==1){
        return 4;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TableDataItem"];
    if(indexPath.section==0){
        [cell.textLabel setText:_keyData[indexPath.row]];
        [cell.detailTextLabel setText:_valueData[indexPath.row]];
    }
    else if(indexPath.section==1){
        NSInteger sectionDataOffset =[self tableView:tableView numberOfRowsInSection:indexPath.section-1];
        [cell.textLabel setText:_keyData[indexPath.row+ sectionDataOffset ]];
        [cell.detailTextLabel setText:_valueData[indexPath.row+ sectionDataOffset ]];
        
    }
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}


@end
