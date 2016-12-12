//
//  Measurement.h
//  SorghumYield
//
//  Created by cis on 26/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 This data structure holds the information about a single plant measurement
 */
@interface Measurement : NSObject

typedef enum ImageStatus
{
    DEFAULT,
    INVALID,
    ACCEPTED,
    DISMISSED
    
} ImageStatus;


/**
 App area measured in inches^2
 */
@property (strong) NSNumber * appArea;

/**
 Processed image data, where the square and sorghum heads are highlighted
 */
@property (strong) UIImage * processedImage;

/**
 Original image data
 */
@property (strong) UIImage * originalImage;

/**
 Original image URL is used to compare individual images and test for duplicate uploads
 */
@property (strong) NSURL * originalImageURL;

/**
 Reperesents the state of the measurement
 */
@property (nonatomic, assign) ImageStatus measurementStatus;



@end
