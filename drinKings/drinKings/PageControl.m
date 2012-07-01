//
//  PageControl.m
//
//  Replacement for UIPageControl because that one only supports white dots.
//
//  Created by Morten Heiberg <morten@heiberg.net> on November 1, 2010.
//

#import "PageControl.h"

// Tweak these or make them dynamic. //7
#define kDotDiameter 7.0 
#define kDotSpacer 7.0

@implementation PageControl

@synthesize dotColorCurrentPage, borderColorCurrentPage;
@synthesize dotColorOtherPage, borderColorOtherPage;
@synthesize shadowOnDots;
@synthesize delegate;

- (NSInteger)currentPage
{
    return _currentPage;
}

- (void)setCurrentPage:(NSInteger)page
{
    _currentPage = MIN(MAX(0, page), _numberOfPages-1);
    [self setNeedsDisplay];
}

- (NSInteger)numberOfPages
{
    return _numberOfPages;
}

- (void)setNumberOfPages:(NSInteger)pages
{
    _numberOfPages = MAX(0, pages);
    _currentPage = MIN(MAX(0, _currentPage), _numberOfPages-1);
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
    {
        // Default colors.
        self.backgroundColor = [UIColor clearColor];
        self.dotColorCurrentPage = [UIColor blackColor];
        self.dotColorOtherPage = [UIColor lightGrayColor];
        self.borderColorCurrentPage = nil;
        self.borderColorOtherPage = nil;
        self.shadowOnDots = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect 
{
    CGContextRef context = UIGraphicsGetCurrentContext();   
    CGContextSetAllowsAntialiasing(context, true);
    
    CGRect currentBounds = self.bounds;
    CGFloat dotsWidth = self.numberOfPages*kDotDiameter + MAX(0, self.numberOfPages-1)*kDotSpacer;
    CGFloat x = CGRectGetMidX(currentBounds)-dotsWidth/2;
    CGFloat y = CGRectGetMidY(currentBounds)-kDotDiameter/2;
    for (int i=0; i<_numberOfPages; i++)
    {
        CGRect circleRect = CGRectMake(x, y, kDotDiameter, kDotDiameter);
        if (i == _currentPage)
        {
            CGContextSetFillColorWithColor(context, self.dotColorCurrentPage.CGColor);
            
            if(self.borderColorCurrentPage!=nil){
                CGContextSetStrokeColorWithColor(context, self.borderColorCurrentPage.CGColor);
                
                //circleRect = CGRectMake(x+1, y+1, kDotDiameter-1, kDotDiameter-1);
            }else{
                CGContextSetStrokeColorWithColor(context, self.dotColorCurrentPage.CGColor);
            }
        }
        else
        {
            CGContextSetFillColorWithColor(context, self.dotColorOtherPage.CGColor);
            
            if(self.borderColorOtherPage!=nil){
                //circleRect = CGRectMake(x+1, y+1, kDotDiameter-1, kDotDiameter-1);
                
                CGContextSetStrokeColorWithColor(context, self.borderColorOtherPage.CGColor);
            }else{
                CGContextSetStrokeColorWithColor(context, self.dotColorOtherPage.CGColor);
            }
        }
        
        CGContextSetLineWidth(context, 2.0);
        CGContextStrokeEllipseInRect(context, circleRect);
        
        
        CGContextFillEllipseInRect(context, circleRect);
       
        /*if(shadowOnDots){
            CGSize myShadowOffset = CGSizeMake(0, 1);
            float myColorValues[] = {0, 0, 0, .8};
            
            CGContextSaveGState(context);
            
            CGColorSpaceRef myColorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef myColor = CGColorCreate(myColorSpace, myColorValues);
            CGContextSetShadowWithColor (context, myShadowOffset, 2, myColor);
            
            CGColorRelease(myColor);
            CGColorSpaceRelease(myColorSpace); 
        }*/
        
        
        
        x += kDotDiameter + kDotSpacer;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.delegate) return;
    
    CGPoint touchPoint = [[[event touchesForView:self] anyObject] locationInView:self];
    
    CGFloat dotSpanX = self.numberOfPages*(kDotDiameter + kDotSpacer);
    CGFloat dotSpanY = kDotDiameter + kDotSpacer;
    
    CGRect currentBounds = self.bounds;
    CGFloat x = touchPoint.x + dotSpanX/2 - CGRectGetMidX(currentBounds);
    CGFloat y = touchPoint.y + dotSpanY/2 - CGRectGetMidY(currentBounds);
    
    if ((x<0) || (x>dotSpanX) || (y<0) || (y>dotSpanY)) return;
    
    self.currentPage = floor(x/(kDotDiameter+kDotSpacer));
    if ([self.delegate respondsToSelector:@selector(pageControlPageDidChange:)])
    {
        [self.delegate pageControlPageDidChange:self];
    }
}

@end