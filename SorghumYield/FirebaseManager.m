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
    //[[FIRAuth auth] signInAnonymouslyWithCompletion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
    [[FIRAuth auth] signInAnonymouslyWithCompletion:^(FIRAuthDataResult *dataResult, NSError *error) {
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

-(void) storeImages : (FIRDatabaseReference*) measurementRef : (NSManagedObject*) managedObject {
    
    NSMutableSet * measurements = [managedObject valueForKey:@"measurements"];
    
    FIRDatabaseReference * photoMeasurementRef = [measurementRef child:@"photoMeasurements"];
    
    FIRStorage *storage = [FIRStorage storage];
    
    // NEW
    FIRFirestore *defaultFirestore = [FIRFirestore firestore];
    
    // Create a storage reference from our storage service
    
    // --------------- Old firebase link below ----------------
    //FIRStorageReference *storageRef = [storage referenceForURL:@"gs://sorghumthesis.appspot.com"];
    FIRStorageReference *storageRef = [storage referenceForURL:@"gs://extension-database-81ebc.appspot.com"];
    
    NSString * measurementRefKey =[measurementRef key];
    
    FIRStorageReference * folder = [storageRef child:measurementRefKey];
    NSData * fileData =[[NSString stringWithFormat:@"%@", managedObject]dataUsingEncoding: NSUTF8StringEncoding ];
    
    [[FirebaseManager sharedFirebaseManager] prepareFileUpload:folder :@"Report" withExtension:@"txt" andDataSource:fileData];
    
    for(NSManagedObjectModel * measurementObject in measurements){
        
        NSString * childID = [[measurementObject valueForKey:@"measurementID"] stringValue];
        FIRDatabaseReference * photoMeasurementInstance = [photoMeasurementRef child:childID];
        
        [photoMeasurementInstance setValue:@{@"appArea" :[measurementObject valueForKey:@"appArea"] }];
        
        NSData * imageData =[measurementObject valueForKey:@"processedImage"];
        
        [[FirebaseManager sharedFirebaseManager] prepareFileUpload:folder :childID withExtension:@"jpg" andDataSource:imageData];
    }
}


@end
