//
//  BaseViewController.m
//  SorghumYield
//
//  Created by cis on 23/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroundImage:@"background"];
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setBackgroundImage: (NSString * ) imageNameString{
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageNameString]];
    [self.view addSubview:backgroundView];
    backgroundView.frame = self.view.bounds;
    backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view sendSubviewToBack:backgroundView];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController* logView = segue.destinationViewController;
    if( [logView respondsToSelector:@selector(setManagedObjectContext:)] ) {
        [logView setValue:self.managedObjectContext forKey:@"managedObjectContext"];
    }
}

@end
