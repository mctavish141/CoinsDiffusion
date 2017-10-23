//
//  main.m
//  CoinsDiffusion
//
//  Created by Serhii Kopach on 22.10.17.
//  Copyright © 2017 Serhii Kopach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "World.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        while (1) {
            NSString *result = @"";
            
            int a;
            scanf("%d", &a);
            
            while ((a >= 1) && (a <= 20)) {
                NSMutableArray *countries = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < a; i++) {
                    char country[26];
                    
                    int xl, yl, xh, yh;
                    
                    scanf("%s %d %d %d %d", country, &xl, &yl, &xh, &yh);
                    
                    if ((xl < 1) || (xl > 10) || (yl < 1) || (yl > 10) || (xh < 1) || (xh > 10) || (yh < 1) || (yh > 10)) {
                        NSLog(@"Input values are incorrect...");
                        return 0;
                    }
                    
                    NSDictionary *countryDictionary = @{@"name": [NSString stringWithUTF8String:country],
                                                        @"xl": @(xl),
                                                        @"yl": @(yl),
                                                        @"xh": @(xh),
                                                        @"yh": @(yh)};
                    [countries addObject:countryDictionary];
                }
                
                World *world = [[World alloc] init];
                [world createWorldWithCountriesDicts:countries];
                
                static int caseNumber = 0;
                caseNumber += 1;
                
                result = [result stringByAppendingString:[NSString stringWithFormat:@"\nCase Number %d%@", caseNumber, world.result]];
                
                scanf("%d", &a);
            }
            
            if (a != 0) {
                NSLog(@"Input values are incorrect...");
                return 0;
            }
            
            if (result.length > 0) {
                NSLog(@"%@", result);
            }
        }
    }
    return 0;
}
