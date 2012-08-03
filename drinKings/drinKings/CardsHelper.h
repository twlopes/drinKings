//
//  CardsHelper.h
//  drinkingcards
//
//  Created by Tristan Lopes on 18/03/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Game.h"
#import "Deck.h"

//#define kCardRatio 0.71428571428571f
#define kCardRatio 0.6887052342f
#define kNumberOfCardsHorizontal 11
#define kNumberOfCardsVertical 2.5

@interface CardsHelper : NSObject

+ (void)setupCards;

+ (NSString*)cardNameWithCard:(Card*)card;

+ (CGSize)sizeOfCard:(CGSize)board;

+ (UIImage*)imageForCard:(Card*)card;

+ (void)positionCardsForGame:(Game*)game withDimensions:(CGSize)board;

@end
