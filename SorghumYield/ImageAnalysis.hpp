//
//  ImageAnalysis.hpp
//  SorghumYield
//
//  Created by cis on 23/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//

#ifndef ImageAnalysis_hpp
#define ImageAnalysis_hpp

#include <stdio.h>
#import <UIKit/UIKit.h>

#endif /* ImageAnalysis_hpp */


/**
 This class is reponsible for performing image analysis
 */
@interface ImageAnalysis : NSObject

typedef enum AnalysisResults
{
    VALID,
    INVALIDHEAD,
    INVALIDSQUARE
    
} AnalysisResults;

/**
 Perform image analysis on the specified UIImage

 @param image       Input image
 @param result      Parameter that saves the result
 @param messageBack Currently unused, prepared for future extensions

 @return UIimage modified with squares and sorghum head highlighted
 */
- (UIImage * ) analysis: (UIImage *) image : ( NSNumber **) result : ( AnalysisResults *) messageBack ;
@property (strong,nonatomic) NSMutableArray * images;



@end
