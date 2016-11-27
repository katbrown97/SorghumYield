//
//  FirebaseManager.h
//  SorghumYield
//
//  Created by cis on 26/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@import Firebase;
@interface FirebaseManager : NSObject{
}

+ (id)sharedFirebaseManager;

-(void)setupDatabase;
-(void) prepareFileUpload: (FIRStorageReference * ) folderStorage :(NSString * ) fileName withExtension: (NSString * ) fileExtension andDataSource:(NSData * ) dataSource;
-(void) upLoadFile: (FIRStorageReference *) fileStorageRef : (NSData *) dataToUpload;
-(void) storeImages : (FIRDatabaseReference*) measurementRef : (NSManagedObject*) managedObject;

@end
