//
//  BaseViewController.h
//  SorghumYield
//
//  Created by cis on 23/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

/**
 Parent class of all viewcontrollers, responsible for adding common elements
 */
@interface BaseViewController : UIViewController <UITextFieldDelegate>

/**
 Core data managedObject that gets passed between Viewcontrollers as per Apple recommendations
 */
@property (strong) NSManagedObject * managedObject;

/**
 Toolbar that gets added to keyboards in order to facilitate a done button
 */
@property UIToolbar* numberToolbar ;

/**
 Method that adds toolbar to textfield keyboard

 @param textField keyboard to add textfield editing toolbar to
 */
- (void) addToolBarToKeyboardForUITF:(UITextField *) textField;

/**
 Presents an alert with the string and title on the viewcontroller

 @param stringToDisplay message
 @param title           title
 */
- (void) presentAlert:(NSString * ) stringToDisplay withTitle:(NSString * ) title;

/**
 Disables backbutton on screens that shouldn't be returned from on the navigationcontroller
 */
- (void) disableBackButton;
@end
