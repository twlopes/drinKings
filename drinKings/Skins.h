//
//  Created by Tristan Lopes on 12/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


@interface Skins : NSObject {
}
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(float)a;
@end
