//
//  main.m
//  drinkingcards
//
//  Created by Tristan Lopes on 11/03/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

#ifdef TESTING
void eHandler(NSException *);

void eHandler(NSException *exception) {
    NSLog(@"%@", exception);
    NSLog(@"%@", [exception callStackSymbols]);
}
#endif

int main(int argc, char *argv[])
{
#ifdef TESTING
    NSSetUncaughtExceptionHandler(&eHandler);
#endif
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
