//
//  PhotoPickerViewController.m
//  SorghumYield
//
//  Created by cis on 26/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//

#import "PhotoPickerViewController.h"
#include "ImageAcceptingViewController.h"

//#include "FinalScreenViewController.h"
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
}

- (void)setupView{
    
    [self setTitle:@"Take/upload photos"];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
}

-(void) initialiazeMediaPicker: (UIImagePickerControllerSourceType) imagePickerType{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    
    picker.sourceType = imagePickerType;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)takePhoto:(UIButton *)sender {
    [self initialiazeMediaPicker:UIImagePickerControllerSourceTypeCamera];
    
}

- (IBAction)selectPhoto:(UIButton *)sender {
    [self initialiazeMediaPicker:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}

- (IBAction)yieldButtonPress:(id)sender {
    
    // Get destination view
    
    float finalAverage=0;
    
    NSManagedObjectContext * managedObjectContext = [self.managedObject managedObjectContext];
    
    NSMutableSet * measurementsToAdd = [self.managedObject mutableSetValueForKey:@"measurements"];//[[NSMutableSet alloc] init];
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
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    _currentMeasurement = [[Measurement alloc] init];
    
    if(picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum){
        for (int i = 0; i< _measurements.count; i++) {
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
    if(_measurements.count>=MinImageCount){
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
    if ([[segue identifier] isEqualToString:@"FinalSegue"]) {
        UIViewController* logView = segue.destinationViewController;
        if( [logView respondsToSelector:@selector(setManagedObject:)] ) {
            [logView setValue:self.managedObject forKey:@"managedObject"];
        }
        
    }
}
-(void)updateLabel{
    NSString * message;
    if(_measurements.count==1)
        message = [NSString stringWithFormat:ADDIMAGE,(MinImageCount-_measurements.count),@""];
    else if(_measurements.count == MinImageCount)
        message = @"CLICK NEXT";
    else
        message = [NSString stringWithFormat:ADDIMAGE,(MinImageCount-_measurements.count),@"S"];
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
    NSString * message = @"Area is: ";
    [cell.textLabel setText:[message stringByAppendingString:numberString ]];
    
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
