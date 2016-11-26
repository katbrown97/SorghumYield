//
//  Measurement.h
//  SorghumYield
//
//  Created by cis on 26/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Measurement : NSObject

typedef enum ImageStatus
{
    DEFAULT,
    INVALID,
    ACCEPTED,
    DISMISSED
    
} ImageStatus;


@property (strong) NSNumber * appArea;

@property (strong) UIImage * processedImage;
@property (strong) UIImage * originalImage;
@property (strong) NSURL * originalImageURL;

@property (nonatomic, assign) ImageStatus measurementStatus;



@end
