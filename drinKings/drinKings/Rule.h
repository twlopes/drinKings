//
//  Rule.h
//  drinkingcards
//
//  Created by Tristan Lopes on 17/06/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Card;

@interface Rule : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * shortName;
@property (nonatomic, retain) NSNumber * holdable;
@property (nonatomic, retain) NSNumber * numberOfDrinks;
@property (nonatomic, retain) NSNumber * giveable;
@property (nonatomic, retain) NSSet *cards;
@end

@interface Rule (CoreDataGeneratedAccessors)

- (void)addCardsObject:(Card *)value;
- (void)removeCardsObject:(Card *)value;
- (void)addCards:(NSSet *)values;
- (void)removeCards:(NSSet *)values;

@end
