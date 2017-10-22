//
//  World.h
//  CoinsDiffusion
//
//  Created by Serhii Kopach on 22.10.17.
//  Copyright © 2017 Serhii Kopach. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface World : NSObject

@property NSString *result;

- (void)createWorldWithCountriesDicts:(NSArray *)countriesDicts;

@end
