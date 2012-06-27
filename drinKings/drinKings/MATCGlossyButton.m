//
//  MATCGlossyButton.m
//  QuartzExamples
//
//  Created by Brad Larson on 2/9/2010.
//

#import "MATCGlossyButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation MATCGlossyButton

#pragma mark -
#pragma mark Initialization and teardown

- (void)dealloc 
{
	//[buttonColor release];
    //[super dealloc];
}

#pragma mark -
#pragma mark Drawing methods

- (void)drawRect:(CGRect)rect 
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect currentBounds = self.bounds;
	
	// First, draw the rounded rectangle for the button fill color
	CGContextSetFillColorWithColor(context, [buttonColor CGColor]);
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, CGRectGetMinX(currentBounds) + cornerRadius, CGRectGetMinY(currentBounds));
    CGContextAddArc(context, CGRectGetMaxX(currentBounds) - cornerRadius, CGRectGetMinY(currentBounds) + cornerRadius, cornerRadius, 3 * M_PI / 2, 0, 0);
    CGContextAddArc(context, CGRectGetMaxX(currentBounds) - cornerRadius, CGRectGetMaxY(currentBounds) - cornerRadius, cornerRadius, 0, M_PI / 2, 0);
    CGContextAddArc(context, CGRectGetMinX(currentBounds) + cornerRadius, CGRectGetMaxY(currentBounds) - cornerRadius, cornerRadius, M_PI / 2, M_PI, 0);
    CGContextAddArc(context, CGRectGetMinX(currentBounds) + cornerRadius, CGRectGetMinY(currentBounds) + cornerRadius, cornerRadius, M_PI, 3 * M_PI / 2, 0);	
    CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFill);

	CGContextBeginPath(context);
	CGContextMoveToPoint(context, CGRectGetMinX(currentBounds) + cornerRadius, CGRectGetMinY(currentBounds));
    CGContextAddArc(context, CGRectGetMaxX(currentBounds) - cornerRadius, CGRectGetMinY(currentBounds) + cornerRadius, cornerRadius, 3 * M_PI / 2, 0, 0);
    CGContextAddArc(context, CGRectGetMaxX(currentBounds) - cornerRadius, CGRectGetMaxY(currentBounds) - cornerRadius, cornerRadius, 0, M_PI / 2, 0);
    CGContextAddArc(context, CGRectGetMinX(currentBounds) + cornerRadius, CGRectGetMaxY(currentBounds) - cornerRadius, cornerRadius, M_PI / 2, M_PI, 0);
    CGContextAddArc(context, CGRectGetMinX(currentBounds) + cornerRadius, CGRectGetMinY(currentBounds) + cornerRadius, cornerRadius, M_PI, 3 * M_PI / 2, 0);	
    CGContextClosePath(context);	
	CGContextClip(context);

	// Next, draw a shadow gradient on the rectangle of the button
	CGGradientRef shadowGradient;
	CGColorSpaceRef rgbColorspace;
	size_t num_locations = 2;
    CGFloat locations2[2] = { 0.0, 1.0 };
    CGFloat components2[8] = { 0.0, 0.0, 0.0, 0.0,  // Start color
							   0.0, 0.0, 0.0, 0.6 }; // End color
	rgbColorspace = CGColorSpaceCreateDeviceRGB();
    shadowGradient = CGGradientCreateWithColorComponents(rgbColorspace, components2, locations2, num_locations);
	CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
    CGPoint bottomCenter = CGPointMake(CGRectGetMidX(currentBounds), currentBounds.size.height);
    CGContextDrawLinearGradient(context, shadowGradient, topCenter, bottomCenter, 0);
    CGGradientRelease(shadowGradient);
	
	// Generate a clipping path for the gloss gradient
	CGFloat spacingForGlossReflection = 3.0f;
	CGFloat glossCornerRadius = cornerRadius;
	CGRect glossRect = CGRectMake(spacingForGlossReflection, spacingForGlossReflection, currentBounds.size.width - spacingForGlossReflection * 2.0f, currentBounds.size.height / 2.0f - spacingForGlossReflection);
	
	CGContextSaveGState(context);
	
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, CGRectGetMinX(glossRect) + glossCornerRadius, CGRectGetMinY(glossRect));
    CGContextAddArc(context, CGRectGetMaxX(glossRect) - glossCornerRadius, CGRectGetMinY(glossRect) + glossCornerRadius, glossCornerRadius, 3 * M_PI / 2, 0, 0);
    CGContextAddArc(context, CGRectGetMaxX(glossRect) - glossCornerRadius, CGRectGetMaxY(glossRect) - glossCornerRadius, glossCornerRadius, 0, M_PI / 2, 0);
    CGContextAddArc(context, CGRectGetMinX(glossRect) + glossCornerRadius, CGRectGetMaxY(glossRect) - glossCornerRadius, glossCornerRadius, M_PI / 2, M_PI, 0);
    CGContextAddArc(context, CGRectGetMinX(glossRect) + glossCornerRadius, CGRectGetMinY(glossRect) + glossCornerRadius, glossCornerRadius, M_PI, 3 * M_PI / 2, 0);	
    CGContextClosePath(context);
	NSLog(@"Path2");
	CGContextClip(context);
		
	// Draw the gloss gradient	
    CGGradientRef glossGradient;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 1.0, 1.0, 1.0, 0.35,  // Start color
		1.0, 1.0, 1.0, 0.06 }; // End color
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
    CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMidY(currentBounds));
    CGContextDrawLinearGradient(context, glossGradient, topCenter, midCenter, 0);
    CGGradientRelease(glossGradient);
	
	CGContextRestoreGState(context);
	
    CGColorSpaceRelease(rgbColorspace); 
}


#pragma mark -
#pragma mark Accessors

@synthesize cornerRadius;
@synthesize buttonColor;

@end
