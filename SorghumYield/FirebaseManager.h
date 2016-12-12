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

/**
 Class responsible for controlling firebase connections
 */
@interface FirebaseManager : NSObject{
}

/**
 Firebase manager as singleton

 @return Firebase manager instance
 */
+ (id)sharedFirebaseManager;

/**
 Sets up the firebase database
 */
-(void)setupDatabase;

/**
 Prepares the fileupload

 @param folderStorage Specifies the filepath for the file
 @param fileName      Specified the filename
 @param fileExtension Specifies the file extension
 @param dataSource    Datasource as NSData
 */
-(void) prepareFileUpload: (FIRStorageReference * ) folderStorage :(NSString * ) fileName withExtension: (NSString * ) fileExtension andDataSource:(NSData * ) dataSource;
-(void) upLoadFile: (FIRStorageReference *) fileStorageRef : (NSData *) dataToUpload;
-(void) storeImages : (FIRDatabaseReference*) measurementRef : (NSManagedObject*) managedObject;

@end
