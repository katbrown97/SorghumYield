//
//  PageContentViewController.h
//  SorghumYield
//
//  Created by cis on 26/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;


@property (strong, nonatomic) IBOutlet UIButton * downloadButton;
- (IBAction)downloadSheet:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *orLabel;



@end
