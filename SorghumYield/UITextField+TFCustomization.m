//
//  UITextField+TFCustomization.m
//  SorghumYield
//
//  Created by cis on 24/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//

#import "UITextField+TFCustomization.h"

@implementation UITextField (TFCustomization)

-(void) addLeftViewText:(NSString * ) textForLeftView {
    
    UIFont * font = [UIFont boldSystemFontOfSize:self.font.pointSize];
    
    UILabel * hint = [[UILabel alloc] init];
    NSString * leftViewFormattedText = [NSString stringWithFormat:@"   %@:", textForLeftView];
    [hint setText:leftViewFormattedText];
    [hint sizeToFit];
    [hint setFont:font];
    
    
    self.leftViewMode =UITextFieldViewModeAlways;
    self.leftView = hint;
    
}

@end
