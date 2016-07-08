//
//  UIColor+Extension.h
//

#import <UIKit/UIKit.h>



#define RGBColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBAColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define HEXColor(s) [UIColor colorWithHexString:s]
// 随机色
#define RGBRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

@interface UIColor (Extension)
/**
 *  iOS中十六进制的颜色转换为UIColor
 *
 *  @param color 16进制的color #ffffff
 *
 *  @return
 */
+ (UIColor *) colorWithHexString: (NSString *)color;
@end
