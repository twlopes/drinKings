//
//  twlAppDelegate.m
//  drinkingcards
//
//  Created by Tristan Lopes on 11/03/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import "AppDelegate.h"
#import "SplashViewController.h"
#import "MainViewController.h"
#import "PlayerChoiceViewController.h"
#import "CardsHelper.h"

@implementation AppDelegate

static AppDelegate *sharedInstance;

@synthesize window = _window;
@synthesize managedObjectContext=__managedObjectContext;
@synthesize managedObjectModel=__managedObjectModel;
@synthesize persistentStoreCoordinator=__persistentStoreCoordinator;
@synthesize playersNeedRefreshing=_playersNeedRefreshing;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    DLog(@"~");
    
    _playersNeedRefreshing=YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [TestFlight takeOff:@"da7a12714a76721432ffe50b5b15b903_NzM5MzMyMDEyLTA2LTA2IDAzOjEwOjIwLjU4NzIyNw"];
    
#ifdef TESTING
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
#endif
    
    UINavigationController *rootController = [[UINavigationController alloc] initWithRootViewController:[[SplashViewController alloc] init]];
    
    [CardsHelper setupCards];
    
    self.window.rootViewController = rootController;
    [self.window makeKeyAndVisible];
    
    if([UINavigationBar conformsToProtocol:@protocol(UIAppearance)]){
        [[UINavigationBar appearance] setTintColor:[Skins colorWithHexString:@"904f53"]];
        
        UIImage *gradientImage44;
        UIImage *gradientImage32;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
            gradientImage44 = [[UIImage imageNamed:@"bgNav-iPhone.png"]
                                        resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            gradientImage32 = [[UIImage imageNamed:@"bgNav-iPhone.png"]
                                        resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            
        }else{
            gradientImage44 = [[UIImage imageNamed:@"bgNav.png"]
                               resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            gradientImage32 = [[UIImage imageNamed:@"bgNav.png"]
                               resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        // Set the background image for *all* UINavigationBars
        [[UINavigationBar appearance] setBackgroundImage:gradientImage44
                                           forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setBackgroundImage:gradientImage32
                                           forBarMetrics:UIBarMetricsLandscapePhone];
        
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    DLog(@"~");
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    DLog(@"~");
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    DLog(@"~");
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    DLog(@"~");
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    DLog(@"~");
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

+ (AppDelegate*)sharedAppController{
    DLog(@"~");
    return sharedInstance;
}

#pragma mark - Core Data stack

- (void)saveContext
{
    DLog(@"~");
    NSError *error = nil;
    managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    DLog(@"~");
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    DLog(@"~");
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"drinkingcards" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    DLog(@"~");
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"drinkingcards.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        DLog(@"add");
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
        NSError *error = nil;
        __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        //abort();
    }    
    
    NSDictionary *fileAttributes = [NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey];
    if (![[NSFileManager defaultManager] setAttributes:fileAttributes ofItemAtPath:[storeURL absoluteString] error:&error]) {
        // error
        DLog(@"error");
    }
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    DLog(@"~ %@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return UIInterfaceOrientationMaskAll;
    else  /* iphone */
        return UIInterfaceOrientationMaskPortrait;
}

-(NSUInteger)supportedInterfaceOrientations
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return UIInterfaceOrientationMaskLandscape;
    else  /* iphone */
        return UIInterfaceOrientationMaskPortrait;
}

@end

#import <QuartzCore/QuartzCore.h>

@interface UINavigationBar (CustomImage)

-(void) applyDefaultStyle;

@end

//Override For Custom Navigation Bar
@implementation UINavigationBar (CustomImage)
- (void)drawRect:(CGRect)rect {
    DLog(@"~");
    if(![UINavigationBar conformsToProtocol:@protocol(UIAppearance)]){
        
        UIImage *image;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
            image = [UIImage imageNamed: @"bgNav-iPhone.png"];
            
        }else{
            image = [UIImage imageNamed: @"bgNav.png"];
        }
        [image drawInRect:rect];
        //self.navigationController.navigationBar.layer.contents = (id)[UIImage skinImageNamed:@"navigationBarBackgroundImage"].CGImage;
        self.tintColor = [Skins colorWithHexString:@"904f53"];
        //[[UINavigationBar appearance] setTintColor:[Constants colorWithHexString:kColor_navigationTint]];
    }
}

-(void)willMoveToWindow:(UIWindow *)newWindow{
    DLog(@"~ %@", newWindow);
    [super willMoveToWindow:newWindow];
    [self applyDefaultStyle];
}

- (void)applyDefaultStyle {
    DLog(@"~");
    // add the drop shadow
    //[super willMoveToWindow:newWindow];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.65;
    self.layer.shadowOffset = CGSizeMake(0,4);
    //CGRect shadowPath = CGRectMake(self.layer.bounds.origin.x - 10, self.layer.bounds.origin.y, self.layer.bounds.size.width * 2 + 20, self.layer.bounds.size.height);
    //self.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowPath].CGPath;
    //self.layer.shouldRasterize = YES;
}

/*- (NSUInteger) supportedInterfaceOrientations
{
    DLog(@"~");
    //Because your app is only landscape, your view controller for the view in your
    // popover needs to support only landscape
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    }
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
    
}*/

@end

@interface UINavigationController (RotateController)

@end

//Override For Custom Navigation Controller
@implementation UINavigationController (RotateController)

-(NSUInteger)supportedInterfaceOrientations
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return UIInterfaceOrientationMaskLandscape;
    else  /* iphone */
        return UIInterfaceOrientationMaskPortrait;
}

@end
