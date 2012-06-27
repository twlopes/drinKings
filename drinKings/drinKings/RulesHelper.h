//
//  RulesHelper.h
//  drinkingcards
//
//  Created by Tristan Lopes on 23/03/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Rule.h"

@interface RulesHelper : NSObject

+ (Rule*)ruleWithShortName:(NSString*)name;

@end
