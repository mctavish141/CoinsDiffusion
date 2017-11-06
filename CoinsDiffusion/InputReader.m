//
//  InputReader.m
//  CoinsDiffusion
//
//  Created by Serhii Kopach on 06.11.17.
//  Copyright © 2017 Serhii Kopach. All rights reserved.
//

#import "InputReader.h"
#import "World.h"

static NSInteger maximumTestCasesCount = 1000;
static NSInteger maximumCountryNameLength = 25;
static NSInteger minimumCountriesCount = 1;
static NSInteger maximumCountriesCount = 20;
static NSInteger minimumCountryCoordinate = 1;
static NSInteger maximumCountryCoordinate = 10;

@implementation InputReader

+ (BOOL)startReading {
    NSLog(@"Enter test case data:");
    
    NSString *result = @"";
    
    for (NSInteger caseNumber = 1; caseNumber <= maximumTestCasesCount; caseNumber++) {
        // 1. Scan countries count
        
        NSInteger countriesCount = [self scanCountriesCount];
        
        if (countriesCount == 0) {
            if (result.length > 0) {
                NSLog(@"%@", result);
                return NO;
            }
            return YES;
        }
        
        if (countriesCount == -1) {
            NSLog(@"Countries count should be from %ld to %ld.",
                  minimumCountriesCount,
                  maximumCountriesCount);
            return NO;
        }
        
        // 2. Scan each test case
        
        NSMutableArray *countriesData = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < countriesCount; i++) {
            NSDictionary *countryData = [self scanCountryData];
            
            if (countryData == nil) {
                NSLog(@"Entered country data is incorrect.");
                return NO;
            }
            
            [countriesData addObject:countryData];
        }
        
        // 3. Create a world
        
        World *world = [[World alloc] init];
        [world createWorldWithCountriesDicts:countriesData];
        
        NSString *caseResult = [NSString stringWithFormat:@"\nCase number %ld", caseNumber];
        caseResult = [caseResult stringByAppendingString:world.result];
        result = [result stringByAppendingString:caseResult];
    }
    
    if (result.length > 0) {
        NSLog(@"%@", result);
    }
    return NO;
}

+ (NSInteger)scanCountriesCount {
    NSString *inputString = [self readInputString];
    
    if (inputString != nil) {
        NSCharacterSet *newlineCharacterSet = [NSCharacterSet newlineCharacterSet];
        NSString *trimmedString = [inputString stringByTrimmingCharactersInSet:newlineCharacterSet];
        
        if ([trimmedString isEqualToString:@"0"]) {
            return 0;
        }
        
        NSInteger countriesCount = [inputString integerValue];
        if ((countriesCount < minimumCountriesCount) || (countriesCount > maximumCountriesCount)) {
            return -1;
        }
        
        return countriesCount;
    }
    
    return -1;
}

+ (NSDictionary *)scanCountryData {
    NSString *inputString = [self readInputString];
    
    if ((inputString != nil) && (inputString.length > 0)) {
        NSArray *tokens = [inputString componentsSeparatedByString:@" "];
        
        if (tokens.count == 5) {
            NSString *countryName = tokens[0];
            NSInteger xl = [tokens[1] integerValue];
            NSInteger yl = [tokens[2] integerValue];
            NSInteger xh = [tokens[3] integerValue];
            NSInteger yh = [tokens[4] integerValue];
            
            if ([self validateCountryName:countryName]) {
                if ([self validateCountryCoordinates:@[@(xl), @(yl), @(xh), @(yh)]]) {
                    if ((xl <= xh) && (yl <= yh)) {
                        return @{@"name": countryName,
                                 @"xl": @(xl),
                                 @"yl": @(yl),
                                 @"xh": @(xh),
                                 @"yh": @(yh)};
                    }
                }
            }
        }
    }
    
    return nil;
}

+ (BOOL)validateCountryName:(NSString *)countryName {
    return ((countryName.length > 0) && (countryName.length <= maximumCountryNameLength));
}

+ (BOOL)validateCountryCoordinates:(NSArray *)coordinates {
    for (NSNumber *coordinateNumber in coordinates) {
        NSInteger coordinate = [coordinateNumber integerValue];
        if ([self validateCoordinate:coordinate] == NO) {
            return NO;
        }
    }
    
    return YES;
}

+ (BOOL)validateCoordinate:(NSInteger)coordinate {
    return ((coordinate >= minimumCountryCoordinate) && (coordinate <= maximumCountryCoordinate));
}

+ (NSString *)readInputString {
    char *inputString = NULL;
    long success;
    unsigned long length;
    
    success = getline(&inputString, &length, stdin);
    if (success != -1) {
        return [NSString stringWithUTF8String:inputString];
    } else {
        return nil;
    }
}

@end
