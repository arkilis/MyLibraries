//
//  BLTextField.m
//
//
//  Created by Ben Liu on 26/03/2016.
//  Copyright © 2016 Ben Liu. All rights reserved.
//
//  Todo List:
//
//  * be able to set font style and font size
//  * able to set up underline
//  * able to set up inline space
//  * able to set up shadow
//  * able to set up hyperlink
//  * Use UIView to rewrite this, thus BLHyperTextField inherit from UIView
//    So you don't have to delegate the method anymore

#import "BLHyperTextField.h"

@implementation BLHyperTextField


/*
 
 I can use override to avoid init functions
-(instancetype)initWithColor: (UIColor*)color {
    if (self == [super init]) {
        _linkColor= color;
    }
    return self;
}


- (instancetype)init{
    return self;
}
 
 */


#pragma mark - addLink

// add link
- (void)setLink:(NSString*)text link:(NSString*)link{
    
    // 这里必须是 initWithString 否则报错
    NSMutableAttributedString* mas = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range= NSMakeRange(0, text.length);
    [mas addAttribute:NSLinkAttributeName value:link range:range];
    [self setAllowsEditingTextAttributes:NO];
    self.attributedText= mas;
    
    _szURL= link;
    [self addTarget:nil action:@selector(jumpToURL) forControlEvents:UIControlEventEditingDidBegin];
    
    
    /* 这个跟上面的是等价的
    self.attributedText=[[NSAttributedString alloc] initWithString:text
                                                        attributes:@{
                                                                     NSLinkAttributeName:link
                                                                    }];
    */
}


// add link with color/underline
- (void)setLink:(NSString*)text link:(NSString*)link foregroundColor:(UIColor*)foreColor underline:(BOOL)isUnderlined {
    NSMutableAttributedString* mas = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range= NSMakeRange(0, text.length);
    
    
    // Here, if you are using NSLinkAttributeName, it will give you always the blue text
    //[mas addAttribute:NSLinkAttributeName value:link range:range];
    
    if(isUnderlined){
        [mas removeAttribute:NSUnderlineStyleAttributeName range:range];
        [mas addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:range];
    }
    
    if(foreColor){
        [mas removeAttribute:NSForegroundColorAttributeName range:range];
        [mas addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    }
    
    
    self.attributedText= mas;
    
    _szURL= link;
    [self addTarget:nil action:@selector(jumpToURL) forControlEvents:UIControlEventEditingDidBegin];
}

// the above two functions can be deleted

// add link with color/underline/font style
- (void)setLink:(NSString*)text link:(NSString*)link foregroundColor:(UIColor*)foregroundColor underline:(BOOL)isUnderlined fontName:(NSString*)fontName fontSize:(int)fontSize {
    
    UIFont *font= [UIFont fontWithName:fontName size:fontSize];
    NSMutableAttributedString* mas = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range= NSMakeRange(0, text.length);
    
    
    if(isUnderlined){
        [mas removeAttribute:NSUnderlineStyleAttributeName range:range];
        [mas addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:range];
    }
    
    if(foregroundColor){
        [mas removeAttribute:NSForegroundColorAttributeName range:range];
        [mas addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    }
    
    if(font){
        [mas removeAttribute:NSFontAttributeName range:range];
        [mas addAttribute:NSFontAttributeName value:font range:range];
    }
    
    self.attributedText= mas;
    
    
    _szURL= link;
    [self addTarget:nil action:@selector(jumpToURL) forControlEvents:UIControlEventEditingDidBegin];
    
}

// 上面这2个函数的代码能不能再一次复用？

- (void)jumpToURL{
    [[UIApplication sharedApplication] openURL:[ NSURL URLWithString:_szURL]];
}


// delegated method -- not get called
/*
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"trigger delegated methods.");
    return NO;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"trigger delegated methods xxxx.");
    return NO;
}
*/



/*
// Ben: drawRect is a function that you can override or not override, depends on needs
// CGRect is GPU intensive?
- (void)drawRect:(CGRect)rect {
    //[super drawRect:rect];
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    //画一条底部线
    CGContextSetRGBStrokeColor(context, 207.0/255, 207.0/255, 207.0/255, 1);//线条颜色
    CGContextMoveToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width,rect.size.height);
    CGContextStrokePath(context);
}
*/

@end
