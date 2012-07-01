//
//  PageControl.h
//
//  Replacement for UIPageControl because that one only supports white dots.
//
//  Created by Morten Heiberg <morten@heiberg.net> on November 1, 2010.
//

#import <UIKit/UIKit.h>

@protocol PageControlDelegate;

@interface PageControl : UIView 
{
@private
    NSInteger _currentPage;
    NSInteger _numberOfPages;
    UIColor *dotColorCurrentPage;
    UIColor *borderColorCurrentPage;
    
    UIColor *dotColorOtherPage;
    UIColor *borderColorOtherPage;
    
    BOOL shadowOnDots;
    
    __weak NSObject<PageControlDelegate> *delegate;
}

// Set these to control the PageControl.
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger numberOfPages;

// Customize these as well as the backgroundColor property.
@property (nonatomic, retain) UIColor *dotColorCurrentPage;
@property (nonatomic, retain) UIColor *dotColorOtherPage;

@property (nonatomic, retain) UIColor *borderColorCurrentPage;
@property (nonatomic, retain) UIColor *borderColorOtherPage;

@property (assign) BOOL shadowOnDots;

// Optional delegate for callbacks when user taps a page dot.
@property (weak) NSObject<PageControlDelegate> *delegate;

@end

@protocol PageControlDelegate<NSObject>
@optional
- (void)pageControlPageDidChange:(PageControl *)pageControl;
@end