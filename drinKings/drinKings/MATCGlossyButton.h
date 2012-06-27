//
//  MATCGlossyButton.h
//  QuartzExamples
//
//  Created by Brad Larson on 2/9/2010.
//

#import <UIKit/UIKit.h>


@interface MATCGlossyButton : UIButton 
{
	CGFloat cornerRadius;
	UIColor *buttonColor;
}

@property(readwrite, nonatomic) CGFloat cornerRadius;
@property(readwrite, retain, nonatomic) UIColor *buttonColor;

@end
