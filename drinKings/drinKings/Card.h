//
//  Card.h
//  drinkingcards
//
//  Created by Tristan Lopes on 22/03/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GameCard, Rule;

@interface Card : NSManagedObject

@property (nonatomic, retain) NSData * frontImage;
@property (nonatomic, retain) NSString * suit;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSSet *games;
@property (nonatomic, retain) Rule *rule;
@end

@interface Card (CoreDataGeneratedAccessors)

- (void)addGamesObject:(GameCard *)value;
- (void)removeGamesObject:(GameCard *)value;
- (void)addGames:(NSSet *)values;
- (void)removeGames:(NSSet *)values;

@end
