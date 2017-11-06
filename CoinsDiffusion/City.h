//
//  City.h
//  CoinsDiffusion
//
//  Created by Serhii Kopach on 22.10.17.
//  Copyright © 2017 Serhii Kopach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Country.h"

@interface City : NSObject

@property NSInteger x;
@property NSInteger y;
@property NSArray *neighbours;
@property NSMutableDictionary *coins;
@property NSMutableDictionary *incomingCoins;
@property NSMutableDictionary *outcomingCoins;
@property BOOL complete;

- (void)transportDailyCoins;
- (void)prepareIncomingCoins:(NSInteger)coins withCountryName:(NSString *)countryName;
- (void)receiveDailyCoins;

- (NSInteger)differentCountriesCoinsCount;

@end
