//
//  FirebaseManager.m
//  SorghumYield
//
//  Created by cis on 26/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//

#import "FirebaseManager.h"

@implementation FirebaseManager


#pragma mark Singleton Methods

+ (id)sharedFirebaseManager {
    static FirebaseManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}
-(void)setupDatabase{
    [FIRApp configure];
    [[FIRAuth auth] signInAnonymouslyWithCompletion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
         if(error != nil){
         }
     }];
    
}

-(void) prepareFileUpload: (FIRStorageReference * ) folderStorage :(NSString * ) fileName withExtension: (NSString * ) fileExtension andDataSource:(NSData * ) dataSource {
    
    NSString * fileUploadLocationWithExtension = [fileName stringByAppendingPathExtension:fileExtension];
    
    [self upLoadFile:[folderStorage child: fileUploadLocationWithExtension] :dataSource];
    
}

-(void) upLoadFile: (FIRStorageReference *) fileStorageRef : (NSData *) dataToUpload{
    
    
    [fileStorageRef putData:dataToUpload metadata:nil completion:^(FIRStorageMetadata * metadata, NSError * error) {
        if (error != nil) {
            printf("Error uploading file");
        } else {
            printf("Success");
        }
    }];
}


@end
