//
//  UITextField+TFCustomization.h
//  SorghumYield
//
//  Created by cis on 24/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (TFCustomization)

/**
 This extension method adds a non editable text as identifier for a text field

 @param textForLeftView String identifier for textfield
 */
-(void) addLeftViewText:(NSString * ) textForLeftView ;
@end
