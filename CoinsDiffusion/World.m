//
//  World.m
//  CoinsDiffusion
//
//  Created by Serhii Kopach on 22.10.17.
//  Copyright © 2017 Serhii Kopach. All rights reserved.
//

#import "World.h"
#import "Country.h"
#import "City.h"

static NSInteger worldWidth = 10;
static NSInteger worldHeight = 10;
static NSInteger initialCoinsAmount = 1000000;
static NSInteger worldLifetime = 100000;

@interface World ()

@property NSArray *countries;
@property NSArray *coordinates;
@property NSInteger currentDay;

@end

@implementation World

- (void)createWorldWithCountriesDicts:(NSArray *)countriesDicts {
    self.coordinates = [self createEmptyCoordinates];
    self.result = @"";
    
    NSMutableArray *countries = [[NSMutableArray alloc] init];
    
    for (NSDictionary *country in countriesDicts) {
        NSString *name = country[@"name"];
        NSInteger xl = [country[@"xl"] integerValue];
        NSInteger yl = [country[@"yl"] integerValue];
        NSInteger xh = [country[@"xh"] integerValue];
        NSInteger yh = [country[@"yh"] integerValue];
        
        Country *country = [[Country alloc] init];
        country.name = name;
        
        NSMutableArray *cities = [[NSMutableArray alloc] init];
        
        for (NSInteger i = (xl - 1); i <= (xh - 1); i++) {
            for (NSInteger j = (yl - 1); j <= (yh - 1); j++) {
                City *city = [[City alloc] init];
                city.x = i;
                city.y = j;
                city.coins = [NSMutableDictionary dictionaryWithDictionary:@{name: @(initialCoinsAmount)}];
                
                self.coordinates[i][j] = city;
                [cities addObject:city];
            }
        }
        
        country.cities = cities;
        
        [countries addObject:country];
    }
    
    self.countries = countries;
    
    for (NSInteger i = 0; i < worldWidth; i++) {
        for (NSInteger j = 0; j < worldHeight; j++) {
            if ([self.coordinates[i][j] isKindOfClass:[NSNull class]] == NO) {
                City *city = self.coordinates[i][j];
                
                NSMutableArray *neighbours = [[NSMutableArray alloc] init];
                
                [self addCity:[self cityWithCoordinateX:i andY:(j - 1)] toNeighboursArray:neighbours];
                [self addCity:[self cityWithCoordinateX:i andY:(j + 1)] toNeighboursArray:neighbours];
                [self addCity:[self cityWithCoordinateX:(i - 1) andY:j] toNeighboursArray:neighbours];
                [self addCity:[self cityWithCoordinateX:(i + 1) andY:j] toNeighboursArray:neighbours];
                
                city.neighbours = neighbours;
            }
        }
    }
    
    [self checkCompletion];
    
    while (([self allCountriesComplete] == NO) && (self.currentDay < worldLifetime)) {
        [self startNewDay];
        [self checkCompletion];
    }
}

- (void)startNewDay {
    self.currentDay += 1;
    
    for (Country *country in self.countries) {
        for (City *city in country.cities) {
            [city transportDailyCoins];
        }
    }
    
    for (Country *country in self.countries) {
        for (City *city in country.cities) {
            [city receiveDailyCoins];
        }
    }
}

- (void)checkCompletion {
    for (Country *country in self.countries) {
        for (City *city in country.cities) {
            if (([city differentCountriesCoinsCount] == self.countries.count) && (city.complete == NO)) {
                city.complete = YES;
            }
        }
    }
    
    NSMutableArray *completedCountries = [[NSMutableArray alloc] init];
    
    for (Country *country in self.countries) {
        NSInteger completedCities = 0;
        for (City *city in country.cities) {
            completedCities += city.complete;
        }
        if ((completedCities == country.cities.count) && (country.complete == NO)) {
            country.complete = YES;
            [completedCountries addObject:country.name];
        }
    }
    
    if (completedCountries.count > 1) {
        [completedCountries sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    
    for (NSString *countryName in completedCountries) {
        NSString *countryResult = [NSString stringWithFormat:@"\n%@ %ld", countryName, self.currentDay];
        self.result = [self.result stringByAppendingString:countryResult];
    }
}

- (BOOL)allCountriesComplete {
    NSInteger completeCountries = 0;
    
    for (Country *country in self.countries) {
        completeCountries += country.complete;
    }
    
    return (completeCountries == self.countries.count);
}

- (void)addCity:(City *)city toNeighboursArray:(NSMutableArray *)neighboursArray {
    if (city != nil) {
        [neighboursArray addObject:city];
    }
}

- (City *)cityWithCoordinateX:(NSInteger)x andY:(NSInteger)y {
    if ((x >= 0) && (x < worldWidth) && (y >= 0) && (y < worldHeight)) {
        return ([self.coordinates[x][y] isKindOfClass:[NSNull class]]) ? nil : self.coordinates[x][y];
    } else {
        return nil;
    }
}

- (NSArray *)createEmptyCoordinates {
    NSMutableArray *coordinatesX = [[NSMutableArray alloc] init];
    for (int i = 0; i < worldWidth; i++) {
        NSMutableArray *coordinatesY = [[NSMutableArray alloc] init];
        for (int j = 0; j < worldHeight; j++) {
            [coordinatesY addObject:[NSNull null]];
        }
        [coordinatesX addObject:coordinatesY];
    }
    return coordinatesX;
}

@end
