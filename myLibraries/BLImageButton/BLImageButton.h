//
//  BLImageButton.h
//  testProtocol
//
//  Created by Ben Liu on 28/03/2016.
//  Copyright © 2016 Ben Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLImageButton : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, weak) NSString *szImageUrl;   // Button online image
@property (nonatomic, weak) NSString *szTargetUrl;  // URL


-(void)setLocalImageButton:(NSString*)btnText localImage:(NSString*)local url:(NSString*)url;
-(void)setURLImageButton:(NSString*)btnText imageURL:(NSString*)imageURL url:(NSString*)url cache:(BOOL)cache;
-(void)saveImageFromURL:(NSString*)imageURL completion:(void(^)(NSData* data))completionBlock;


@end
