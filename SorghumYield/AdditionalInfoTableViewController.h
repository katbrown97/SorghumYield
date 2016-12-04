//
//  AdditionalInfoTableViewController.h
//  SorghumYield
//
//  Created by cis on 27/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@import MapKit;
@import CoreLocation;

@interface AdditionalInfoTableViewController : UITableViewController
@property (strong) NSNumber * finalYield;
@property (strong, nonatomic) IBOutlet UILabel *finalYieldLabel;
@end
