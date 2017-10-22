//
//  City.m
//  CoinsDiffusion
//
//  Created by Serhii Kopach on 22.10.17.
//  Copyright © 2017 Serhii Kopach. All rights reserved.
//

#import "City.h"

@implementation City

- (id)init {
    self = [super init];
    
    self.coins = [[NSMutableDictionary alloc] init];
    self.incomingCoins = [[NSMutableDictionary alloc] init];
    self.outcomingCoins = [[NSMutableDictionary alloc] init];
    
    return self;
}

- (NSString *)stringFromCity {
    return [NSString stringWithFormat:@"x: %ld, y: %ld\ncountry: %@\nneighbours: %ld\n%@", self.x, self.y, self.country.name, self.neighbours.count, [[self class] stringFromCoins:self.coins]];
}

+ (NSString *)stringFromCoins:(NSDictionary *)coins {
    NSString *string = @"coins:";
    for (NSString *countryName in coins.allKeys) {
        string = [string stringByAppendingString:[NSString stringWithFormat:@"\nof %@: %ld", countryName, [coins[countryName] integerValue]]];
    }
    return string;
}

- (void)transportDailyCoins {
    for (NSString *countryName in self.coins.allKeys) {
        NSInteger countryCoins = [self.coins[countryName] integerValue];
        
        NSInteger outcomingCountryCoins = (countryCoins / 1000);
        
        [self prepareOutcomingCoins:(outcomingCountryCoins * self.neighbours.count) withCountryName:countryName];
        
        for (City *city in self.neighbours) {
            [city prepareIncomingCoins:outcomingCountryCoins withCountryName:countryName];
        }
    }
}

- (void)prepareOutcomingCoins:(NSInteger)coins withCountryName:(NSString *)countryName {
    self.outcomingCoins[countryName] = @([self.outcomingCoins[countryName] integerValue] + coins);
}

- (void)prepareIncomingCoins:(NSInteger)coins withCountryName:(NSString *)countryName {
    self.incomingCoins[countryName] = @([self.incomingCoins[countryName] integerValue] + coins);
}

- (void)receiveDailyCoins {
    for (NSString *countryName in self.outcomingCoins.allKeys) {
        NSInteger countryCoins = [self.outcomingCoins[countryName] integerValue];
        self.coins[countryName] = @([self.coins[countryName] integerValue] - countryCoins);
    }
    
    for (NSString *countryName in self.incomingCoins.allKeys) {
        NSInteger countryCoins = [self.incomingCoins[countryName] integerValue];
        self.coins[countryName] = @([self.coins[countryName] integerValue] + countryCoins);
    }
    
    self.incomingCoins = [[NSMutableDictionary alloc] init];
    self.outcomingCoins = [[NSMutableDictionary alloc] init];
}

- (NSInteger)differentCountriesCoinsCount {
    NSInteger count = 0;
    
    for (NSString *countryName in self.coins.allKeys) {
        NSInteger countryCoins = [self.coins[countryName] integerValue];
        
        if (countryCoins > 0) {
            count++;
        }
    }
    
    return count;
}

@end
