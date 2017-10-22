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
        
        NSString *result = @"";
        
        int a;
        scanf("%d", &a);
        
        while ((a >= 1) && (a <= 20)) {
            NSMutableArray *countries = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < a; i++) {
                char country[26];
                
                int xl, yl, xh, yh;
                
                scanf("%s %d %d %d %d", country, &xl, &yl, &xh, &yh);
                
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
        
        NSLog(@"%@", result);
    }
    return 0;
}
