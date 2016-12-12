//
//  GeoLocationViewController.h
//  SorghumYield
//
//  Created by cis on 24/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>
#import "GeoDataLoader.h"
#import "BaseViewController.h"


typedef enum PickerStates
{
    COUNTRIES,
    STATES,
    COUNTIES
    
} PickerState;

@interface GeoLocationViewController : BaseViewController <CLLocationManagerDelegate,UIPickerViewDataSource, UIPickerViewDelegate>

@property   NSArray * pickerData;
@property   NSInteger selectedState;
@property   NSInteger selectedCountry;
@property   NSInteger selectedCounty;


@property (strong)  CLLocationManager * locationManager;

@property (strong, nonatomic) IBOutlet UIView *selectionView;
@property (strong, nonatomic) IBOutlet UIPickerView *countryPicker;
@property (strong, nonatomic) IBOutlet UIButton *prevButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;


@property UIActivityIndicatorView *indicator;

- (IBAction)prevButtonClick:(id)sender;
- (IBAction)nextButtonClick:(id)sender;


@property (strong, nonatomic) GeoDataLoader * geoData;

@property (nonatomic, assign) PickerState currentPickerState;

- (void)initializePicker;

- (void) storeAutoLocationAndSegue: (CLLocationCoordinate2D) gpsLocation;
- (void) storeManualLocationAndSegue:(NSString *) countryname
                          stateName :(NSString *) stateName
                         countyName :(NSString * ) countyName;


@end
