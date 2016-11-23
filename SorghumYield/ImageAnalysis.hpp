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


@interface ImageAnalysis : NSObject

typedef enum AnalysisResults
{
    VALID,
    INVALIDHEAD,
    INVALIDSQUARE
    
} AnalysisResults;

- (UIImage * ) analysis: (UIImage *) image : ( NSNumber **) result : ( AnalysisResults *) messageBack ;
@property (strong,nonatomic) NSMutableArray * images;



@end
