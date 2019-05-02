//
//  PhotoPickerViewController.m
//  SorghumYield
//
//  Created by cis on 26/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//

#import "PhotoPickerViewController.h"
#include "ImageAcceptingViewController.h"


#import <CoreData/CoreData.h>

@interface PhotoPickerScreenViewController ()

@end



@implementation PhotoPickerScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _measurements = [[NSMutableArray alloc] init];
    
    [self setupView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setBackgroundView:nil];
    
    [[[self takePhotoButton] imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [[[self selectPhotoButton] imageView] setContentMode:UIViewContentModeScaleAspectFit];
    }

- (void)setupView{
    [self setTitle:@"Take/Upload Photos"];
    [self updateLabel];
}

/*! @brief Method for initializing camera action*/
-(void) initialiazeMediaPicker: (UIImagePickerControllerSourceType) imagePickerType{
    // Media controller for image picker
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    // Setting up the type of image picker, which could be camera or photo album
    picker.sourceType = imagePickerType;
    picker.delegate = self;
    picker.allowsEditing = NO;
    
    // Activate the camera or open user's photo album
    [self presentViewController:picker animated:YES completion:NULL];
}

/*! @brief Method for taking photo */
- (IBAction)takePhoto:(UIButton *)sender {
    // Invoking the method above for camera action
    [self initialiazeMediaPicker:UIImagePickerControllerSourceTypeCamera];
}

// Button for opening user's photo album
- (IBAction)selectPhoto:(UIButton *)sender {
    [self initialiazeMediaPicker:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (IBAction)yieldButtonPress:(id)sender {
    
    // Get destination view
    
    float finalAverage=0;
    
    NSManagedObjectContext * managedObjectContext = [self.managedObject managedObjectContext];
    
    NSMutableSet * measurementsToAdd = [self.managedObject mutableSetValueForKey:@"measurements"];
    int photoID =0;
    for(Measurement * curMeasurement in _measurements){
        finalAverage += [[curMeasurement appArea]doubleValue];
        
        NSManagedObject * newMeasurementObject = [NSEntityDescription insertNewObjectForEntityForName:@"Measurement" inManagedObjectContext:managedObjectContext];
        
        [newMeasurementObject setValue:[curMeasurement appArea] forKey:@"appArea"];
        [newMeasurementObject setValue:[NSNumber numberWithInt:photoID] forKey:@"measurementID"];
        
        NSData *dataImage = UIImageJPEGRepresentation([curMeasurement processedImage], 0.0);
        [newMeasurementObject setValue:dataImage forKey:@"processedImage"];
        
        
        [measurementsToAdd addObject:newMeasurementObject];
        photoID++;
    }
    
    finalAverage/= _measurements.count;
    
    
    
    [self.managedObject setValue:[NSNumber numberWithFloat:finalAverage] forKey:@"appAreaAverage"];
    [self performSegueWithIdentifier:@"resultSegue" sender:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    _currentMeasurement = [[Measurement alloc] init];
    
    if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
        for (int i = 0; i < _measurements.count; i++) {
            NSURL * curImageString = [_measurements[i] originalImageURL];
            if([curImageString isEqual:info[UIImagePickerControllerReferenceURL]]){
                [picker dismissViewControllerAnimated:NO completion:^{[self presentAlert:DuplicateImageError withTitle:@"Duplicate Image"];}];
                return;
            }
        }
    }
    
    UIImage * chosenImage = [self rotate:info[UIImagePickerControllerOriginalImage] andOrientation:UIImageOrientationUp ];
    _currentMeasurement.originalImage = chosenImage;
    _currentMeasurement.originalImageURL = info[UIImagePickerControllerReferenceURL];
    
    [picker dismissViewControllerAnimated:NO completion:
     ^{
         [self performSegueWithIdentifier:@"ImageAccepting" sender:self];
     }
     ];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:NO completion:NULL];
}

- (void)viewWillAppear:(BOOL)animated{
    
    if(_currentMeasurement!=NULL){
        if([_currentMeasurement measurementStatus] == DISMISSED){
            
            // Display alert for dissmissed image only once.
            dispatch_once(&predicate, ^{
                [self presentAlert:StatusDismissed withTitle:@"Image Dismissed"];
            });
            _currentMeasurement=NULL;
            
        }
        if([_currentMeasurement measurementStatus] == ACCEPTED){
            [self handleMeasurementAccepted];
            _currentMeasurement=NULL;
            [self updateLabel];
        }
        if([_currentMeasurement measurementStatus] == INVALID){
            
            [self presentAlert:InvalidImageError withTitle:@"Invalid Image"];
            _currentMeasurement=NULL;
        }
    }
}
-(void) handleMeasurementAccepted{
    [_measurements addObject:_currentMeasurement];
    if(_measurements.count>=MaxImageCount){
        _yieldButton.enabled=YES;
        _takePhotoButton.enabled=NO;
        _selectPhotoButton.enabled =NO;
    }
    [_tableView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"ImageAccepting"])
    {
        ImageAcceptingViewController * vc = [segue destinationViewController];
        [vc setMeasurementHolder:_currentMeasurement];
    } 
    
    [super prepareForSegue:segue sender:sender];
}
-(void)updateLabel{
    NSString * message;
    if(MaxImageCount - _measurements.count == 1)
        message = [NSString stringWithFormat:ADDIMAGE,(MaxImageCount-_measurements.count),@""];
    else if(_measurements.count == MaxImageCount)
        message = @"Click next";
    else if(_measurements.count == 0)
        message = [NSString stringWithFormat:@"Add up to %d images", MaxImageCount];
    else
        message = [NSString stringWithFormat:ADDIMAGE,(MaxImageCount-_measurements.count),@"s"];
    _statusLabel.text = message;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _measurements.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableDataItem"];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    
    UIImage * imageToSet =[[_measurements objectAtIndex:indexPath.row]processedImage];
    UIImage * flipped;
    if(imageToSet.size.width> imageToSet.size.height){
        flipped = [[UIImage alloc] initWithCGImage: imageToSet.CGImage
                                             scale: 1.0
                                       orientation: UIImageOrientationRight];
        [cell.imageView setImage: flipped];
    }
    else
        [cell.imageView setImage: imageToSet];
    
    
    NSNumber * curAppArea = [[_measurements objectAtIndex:indexPath.row] appArea];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    
    NSString *numberString = [formatter stringFromNumber:curAppArea];
    NSString * message = [@"Area: " stringByAppendingString:numberString];
    [cell.textLabel setText:[message stringByAppendingString:@" in²"]];
    
    return cell;
}


-(UIImage*) rotate:(UIImage*) src andOrientation:(UIImageOrientation)orientation
{
    UIGraphicsBeginImageContext(src.size);

    CGContextRef context=(UIGraphicsGetCurrentContext());
    
    if (orientation == UIImageOrientationRight) {
        CGContextRotateCTM (context, 90/180*M_PI) ;
    } else if (orientation == UIImageOrientationLeft) {
        CGContextRotateCTM (context, -90/180*M_PI);
    } else if (orientation == UIImageOrientationDown) {
        // NOTHING
    } else if (orientation == UIImageOrientationUp) {
        CGContextRotateCTM (context, 90/180*M_PI);
    }
    
    [src drawAtPoint:CGPointMake(0, 0)];
    UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
