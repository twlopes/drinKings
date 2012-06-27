//
//  RulesHelper.m
//  drinkingcards
//
//  Created by Tristan Lopes on 23/03/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import "RulesHelper.h"
#import "AppDelegate.h"

@implementation RulesHelper

+ (Rule*)ruleWithShortName:(NSString*)name{
    Rule *returnRule=nil;
    
    NSManagedObjectContext *moc/* = [ac managedObjectContext]*/;
    
    if (moc == nil) { 
        moc = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
    }
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Rule"
                                              inManagedObjectContext:moc];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"shortName = %@", name]];
    
    NSError *error = nil;
    NSArray *ruleArray = [moc executeFetchRequest:request error:&error];
    
    if([ruleArray count]!=0){
        returnRule = (Rule*)[ruleArray objectAtIndex:0];
    }
    
    return returnRule;
}

@end