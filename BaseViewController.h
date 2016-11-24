//
//  BaseViewController.h
//  SorghumYield
//
//  Created by cis on 23/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@interface BaseViewController : UIViewController <UITextFieldDelegate>

@property (strong) NSManagedObject * managedObject;
@property UIToolbar* numberToolbar ;
- (void) addToolBarToKeyboardForUITF:(UITextField *) textField ;
@end
