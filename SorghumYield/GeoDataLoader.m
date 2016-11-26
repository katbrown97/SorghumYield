//
//  GeoDataLoader.m
//  SorghumYield
//
//  Created by cis on 24/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//

#import "GeoDataLoader.h"
#import "GeoDataLoader.h"

@implementation GeoDataLoader

- (id)init{
    self = [super init];
    if (self) {
        // Any custom setup work goes here
        [self countriesFromCSV];
        [self stateCountyDictionaryFromCSV];
    }
    return self;
}

- (NSArray * ) getLinesFromFile:  (NSString *)fileName ofType :(NSString * ) fileType inDirectory :(NSString *) directory encodedWith :(NSStringEncoding) encoding usingDelimeter:(NSString *) delimeter {
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];

    NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding: encoding error:NULL];
    return [fileContents componentsSeparatedByString:delimeter];
    
}

- (void) countriesFromCSV{
    
    
    NSArray * lines = [self getLinesFromFile:@"CountryList" ofType:@"csv" inDirectory:@"" encodedWith:NSASCIIStringEncoding usingDelimeter:@"\n"];
    
    _countryNames= [NSMutableArray array];
    for (int i = 0; i < lines.count-1; i++){
        [_countryNames addObject:lines[i]];
    }
}

- (void) stateCountyDictionaryFromCSV{
    
    NSArray * lines = [self getLinesFromFile:@"StateCounties" ofType:@"csv" inDirectory:@"" encodedWith:kCFStringEncodingUTF8 usingDelimeter:@"\n"];
    
    NSMutableArray * tempCountries= [NSMutableArray array];
    
    NSString * currentCountry= [lines[0] componentsSeparatedByString:@","][1];
    
    _statesCountiesDictionary = [[NSMutableArray alloc] init];
    _stateNames = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < lines.count-1; i++){
        
        NSArray * items = [lines[i] componentsSeparatedByString:@","];
        
        if(![items[1] isEqualToString:currentCountry]){
            
            [_statesCountiesDictionary addObject:tempCountries];
            [_stateNames addObject:currentCountry];
            
            tempCountries= [NSMutableArray array];
            currentCountry = items[1];
        }
        
        [tempCountries addObject:items[0]];
    }
    NSArray * items = [lines[lines.count-1] componentsSeparatedByString:@","];
    [tempCountries addObject:items[0]];
    [_stateNames addObject: currentCountry];
    [_statesCountiesDictionary addObject:tempCountries];
}

@end
