//
//  main.m
//  CoinsDiffusion
//
//  Created by Serhii Kopach on 22.10.17.
//  Copyright © 2017 Serhii Kopach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InputReader.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        BOOL exitPerformed = NO;
        
        while (exitPerformed == NO) {
            exitPerformed = [InputReader startReading];
        }
    }
    return 0;
}
