//
//  BLTextField.h
//
//  Created by Ben Liu on 26/03/2016.
//  Copyright © 2016 Ben Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface BLHyperTextField : UITextField <UITextInput, NSCoding>

@property (nonatomic, weak) NSString    *szURL;

- (void)setLink:(NSString*)text link:(NSString*)link;
- (void)setLink:(NSString*)text link:(NSString*)link foregroundColor:(UIColor*)foreColor underline:(BOOL)isUnderlined;
- (void)setLink:(NSString*)text link:(NSString*)link foregroundColor:(UIColor*)foregroundColor underline:(BOOL)isUnderlined fontName:(NSString*)fontName fontSize:(int)fontSize;

@end
