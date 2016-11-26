//
//  GeoLocationViewController.m
//  SorghumYield
//
//  Created by cis on 24/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//


#import "GeoLocationViewController.h"

@interface GeoLocationViewController ()

@end

@implementation GeoLocationViewController{
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
[self disableBackButton];
    
    _locationManager = [[CLLocationManager alloc] init];
    CLAuthorizationStatus currentStatus =  [CLLocationManager authorizationStatus];
    
    if(currentStatus == kCLAuthorizationStatusRestricted ||  currentStatus ==kCLAuthorizationStatusDenied || [CLLocationManager locationServicesEnabled]== false){
        [self initializePicker];
    }
    else
    {
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        _locationManager.distanceFilter = 100.0;
        [_locationManager requestLocation];
        
        
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicator.center = self.view.center;
        _indicator.hidesWhenStopped = YES;
        _indicator.color = [UIColor blackColor];
        
    }
    
    [self.view addSubview:_indicator];
    [_indicator startAnimating];
    
    
}


- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    if(status ==kCLAuthorizationStatusDenied){
        [self initializePicker];
        [_indicator stopAnimating];
        
    }
    if(status == kCLAuthorizationStatusNotDetermined){
        
        
    }
    if(status == kCLAuthorizationStatusAuthorizedWhenInUse){
        [_locationManager requestLocation];
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicator.center = self.view.center;
        _indicator.hidesWhenStopped = YES;
        _indicator.color = [UIColor blackColor];
    }
}

static dispatch_once_t predicate;



- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    //    [self initializePicker];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocationCoordinate2D currentCoordinates = locations[0].coordinate;
    
    [_locationManager stopUpdatingLocation];
    manager = nil;
    
    dispatch_once(&predicate, ^{
        [self storeAutoLocationAndSegue:currentCoordinates];
    });
}

- (void)initializePicker{
    _selectionView.hidden =false;
    _currentPickerState = COUNTRIES;
    
    
    _prevButton.hidden=true;
    _nextButton.hidden=false;
    
    _geoData = [[GeoDataLoader alloc] init];
    
    self.countryPicker.dataSource = self;
    self.countryPicker.delegate = self;
    
    _pickerData = _geoData.countryNames;
    _selectedState = 0;
    [_countryPicker reloadAllComponents];
}

- (void)updatePicker{
    
    switch (_currentPickerState) {
        case COUNTRIES:
            _pickerData = _geoData.countryNames;
            break;
        case STATES:
            _pickerData = _geoData.stateNames;
            break;
        case COUNTIES:
            _pickerData = [_geoData.statesCountiesDictionary objectAtIndex:_selectedState];
            break;
    }
    
    [_countryPicker reloadAllComponents];
    if(_currentPickerState== STATES)
        [_countryPicker selectRow:_selectedState inComponent:0 animated:NO];
    else
        [_countryPicker selectRow:0 inComponent:0 animated:NO];
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(_currentPickerState == STATES)
        _selectedState = row;
    if(_currentPickerState == COUNTRIES)
        _selectedCountry = row;
    if(_currentPickerState == COUNTIES)
        _selectedCounty = row;
}
- (IBAction)prevButtonClick:(id)sender {
    
    if(_currentPickerState == COUNTIES){
        _currentPickerState = STATES;
        _nextButton.hidden=false;
    }
    else if(_currentPickerState == STATES){
        _currentPickerState = COUNTRIES;
        _prevButton.hidden=true;
    }
    [self updatePicker];
}
- (IBAction)nextButtonClick:(id)sender {
    if(_currentPickerState == COUNTRIES){
        if([_countryPicker selectedRowInComponent:0]!=0){
            [self storeManualLocationAndSegue:_geoData.countryNames[_selectedCountry] stateName:@"" countyName:@""];
        }
        else{
            _currentPickerState = STATES;
            _prevButton.hidden=false;
        }
    }
    else if(_currentPickerState == STATES){
        _currentPickerState = COUNTIES;
    }
    else if(_currentPickerState==COUNTIES ){
        [self storeManualLocationAndSegue: _geoData.countryNames[_selectedCountry] stateName:_geoData.stateNames[_selectedState] countyName: _geoData.statesCountiesDictionary[_selectedState][_selectedCounty]];
        
    }
    [self updatePicker];
}
- (void) storeAutoLocationAndSegue: (CLLocationCoordinate2D) gpsLocation{
    
    NSManagedObject * newGPSLocation = [self createEntityAndParentIt: @"AutoGPS" ];
    [newGPSLocation setValue:[NSNumber numberWithFloat:gpsLocation.latitude] forKey:@"lat"];
    [newGPSLocation setValue:[NSNumber numberWithFloat:gpsLocation.longitude] forKey:@"lon"];
    
    
    [self performSegueWithIdentifier:@"GeoSegue" sender:self];
}
- (void) storeManualLocationAndSegue:(NSString *) countryName
                          stateName :(NSString *) stateName
                         countyName :(NSString * ) countyName{
    
    NSManagedObject * newGPSLocation = [self createEntityAndParentIt: @"ManualGPS" ];
    
    [newGPSLocation setValue:countryName forKey:@"countryName"];
    [newGPSLocation setValue:stateName forKey:@"stateName"];
    [newGPSLocation setValue:countyName forKey:@"countyName"];
    
    
    [self performSegueWithIdentifier:@"GeoSegue" sender:self];
    
}

-(NSManagedObject *) createEntityAndParentIt: (NSString *) entityName{
    NSManagedObjectContext * managedObjectContext = [[self managedObject] managedObjectContext];
    
    NSManagedObject * newGPSLocation = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:managedObjectContext];
    NSString * gpsAttributeName = @"";
    if([entityName isEqualToString: @"ManualGPS"]){
        gpsAttributeName = @"manualGPSData";
    }
    else{
        gpsAttributeName = @"autoGPSData";
    }
    [self.managedObject setValue:newGPSLocation forKey: gpsAttributeName];
    
    return newGPSLocation;
}
@end
