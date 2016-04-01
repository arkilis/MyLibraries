//
//  BLImageButton.m
//  testProtocol
//
//  Created by Ben Liu on 28/03/2016.
//  Copyright © 2016 Ben Liu. All rights reserved.
//
//  What about it?
//  Be able to let you click on a button which direct your to a link (Web/Email).
//
//  Use:
//  example 1: mailto:arkilis@gmail.com
//  example 2: http://www.arkilis.me
//
//  Objectives:
//  1. able to use URL image
//  2. able to cache the online image
//  3. if the online image is empty, use a default image to replace it.
//  4. if the target url is empty, then do nothing
//  5. able to have the text besides the image
//
//  To Do:
//  1. https
//  2. 

#import "BLImageButton.h"
#import <CommonCrypto/CommonDigest.h> // for md5

static NSString* const placeholder=@"placeholder.png";


@interface BLImageButton(){
    NSFileManager*  _fileManager;
    NSString*       _cachePath;
    NSString*       _fileRawName;       // raw file name. i.e. a.pdf from http://www.google.com/a.pdf
    NSString*       _fileMD5Name;       // md5 file name. i.e  EA416ED0759D46A8DE58F63A59077499 from a.pdf
    NSString*       _fileMD5Path;       // full path with md5 file name
}

@end


@implementation BLImageButton


-(id)init{
    self= [super init];
    if(self){
        _fileManager= [NSFileManager new];
        [self createCacheDirectory];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        // Do something
        
        
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self= [super initWithFrame:frame];
    if(self){
        _fileManager= [NSFileManager new];
        [self createCacheDirectory];
        
    }
    return self;
}

// use the local image as the button
-(void)setLocalImageButton:(NSString*)btnText localImage:(NSString*)local url:(NSString*)url{

    if(url){
        _szTargetUrl= url;
        
        // Create the image in the front. BE CAREFUL, the inner components are using relative position
        /*
        UIImageView *imageView= [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.origin.x+5,
                                                                             self.frame.origin.y+5,
                                                                             self.frame.size.height-10,
                                                                             self.frame.size.height-10)];
         */
        UIImageView *imageView= [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.height-10, self.frame.size.height-10)];
        UIImage *image= [UIImage imageNamed:local];
        if(image){
            imageView.image= image;
        }else{
            imageView.image= [UIImage imageNamed:placeholder];
        }
        
        imageView.contentMode= UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        
        // Create the text right to the image
        /*
        UILabel *textView= [[UILabel alloc] initWithFrame:CGRectMake(self.frame.origin.x+self.frame.size.height+5,
                                                                       self.frame.origin.y+5,
                                                                       self.frame.size.width-self.frame.size.height,
                                                                        self.frame.size.height-10)];
         */
        UILabel *textView= [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.height+10, 5, self.frame.size.width-self.frame.size.height,self.frame.size.height-10)];
        textView.text= btnText;
        [self addSubview:textView];
        
        self.userInteractionEnabled= YES;
        UITapGestureRecognizer *gesRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToURL)];
        [gesRecognizer setNumberOfTapsRequired:1];
        gesRecognizer.delegate= self;
        [self addGestureRecognizer:gesRecognizer];
    }
}

// use an Internet image button
-(void)setURLImageButton:(NSString*)btnText imageURL:(NSString*)imageURL url:(NSString*)url cache:(BOOL)cache{
    if(url){
        _szTargetUrl= url;
        UIImageView *imageView= [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.height-10, self.frame.size.height-10)];
        //NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageURL]];
        
        [self saveImageFromURL:imageURL completion:^(NSData* image){
            if(image){
                imageView.image= [UIImage imageWithData:image];
            }else{
                imageView.image= [UIImage imageNamed:placeholder];
            }
        }];
        
        imageView.contentMode= UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        
        UILabel *textView= [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.height+10, 5, self.frame.size.width-self.frame.size.height,self.frame.size.height-10)];
        textView.text= btnText;
        [self addSubview:textView];
        
        self.userInteractionEnabled= YES;
        UITapGestureRecognizer *gesRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToURL)];
        [gesRecognizer setNumberOfTapsRequired:1];
        gesRecognizer.delegate= self;
        [self addGestureRecognizer:gesRecognizer];
        
    }
}

-(void)jumpToURL{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:_szTargetUrl]];
    NSLog(@"jump URL %@", _szTargetUrl);
}

#pragma mark - Cache image from Internet

// md5 file name
// @fileRawName: the original file name, i.e. a.pdf
+(NSString*)md5FileName:(NSString*)fileRawName{
    
    const char *cStr = [fileRawName UTF8String];
    if (cStr == NULL) {
        cStr = "";
    }
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X.%@",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15],
            [fileRawName pathExtension]];
}

// get file name from an URL
// Example: http://www.google.com/a.pdf
// return a.pdf
+(NSString*)getFileNameFromURL:(NSString*)url{
    NSArray *parts = [url componentsSeparatedByString:@"/"];
    return [parts lastObject];
}

// check whether file in the cache
// @fileMD5Name: is the file name without parent directory names
-(BOOL)checkFileInCache:(NSString*)fileMD5Path{
    return [_fileManager fileExistsAtPath:fileMD5Path]? YES: NO;
}

// create directory
-(void)createCacheDirectory{
    // target path is not existing
    _cachePath= [NSString stringWithFormat:@"%@/ImageCache", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]];
    if(![_fileManager fileExistsAtPath:_cachePath]){
        NSError *error;
        if ( ![[NSFileManager defaultManager] createDirectoryAtPath:_cachePath withIntermediateDirectories:YES attributes:nil error:&error] ) {
            NSLog(@"[%@] ERROR: attempting to write create MyFolder directory", [self class]);
        }
    }
}

// write images to local drive
// @imageName:  must be full path after md5 and with local image cache directory
// @image:      image data 我觉得这个参数的作用就是判断图片大小是否为空
-(BOOL)writeImageToLocal:(NSString *)imageName image:(UIImage *)image{
    if (!image) {
        return NO;
    }
    
    NSLog(@"image name: %@\n", imageName);
    
    if ([imageName hasSuffix:@".png"] || [imageName hasSuffix:@".bmp"]) {
        // png图片
        [UIImagePNGRepresentation(image) writeToFile:imageName options:NSAtomicWrite error:nil];
        return YES;
    } else if ([imageName hasSuffix:@".jpg"] || [imageName hasSuffix:@".jpeg"] || [imageName hasSuffix:@".gif"]){
        //jpg图片
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:imageName options:NSAtomicWrite error:nil];
        return YES;
    } else {
        // 未知图片类型
        NSLog(@"Unknow file extension!");
        return NO;
    }

}

// synchronised version

// asynchronisly downloading image data from URL
// @isCached: YES/NO. [YES enables image will be saved cache] 这是不对的，应该是长线程做完了工作后，然后设置cache为YES/NO

// 实际上在最初定义 Block function 的时候，Block 的 参数是作为一个结果被写入值，在 Block 函数被调用的时候可以使用该参数的值。
// Block 作为参数到现在仅仅完成了 Block 匿名函数的声明，在主体函数被调用的时候，才有对 Block 的定义。
-(void)saveImageFromURL:(NSString*)imageURL completion:(void(^)(NSData* data))completionBlock{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        _fileRawName= [BLImageButton getFileNameFromURL:imageURL];
        _fileMD5Name= [BLImageButton md5FileName:_fileRawName];
        _fileMD5Path= [_cachePath stringByAppendingPathComponent:_fileMD5Name];
        
        BOOL cache = false;
        
        NSData *imageData= [NSData new];
        if([self checkFileInCache:_fileMD5Path]){ // get image from cache
            imageData= [[NSData alloc] initWithContentsOfFile:_fileMD5Path];
        }else{
            imageData= [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageURL]];
            // save to cache
            cache= [self writeImageToLocal:_fileMD5Path image:[UIImage imageWithData:imageData]];
        }
        
        // what does this line mean?    
        if(!completionBlock) return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // use a default image instead <loading.png>
            // return [[NSData alloc] initWithContentsOfFile:@"loading.png"]; how come you return from a block.
            completionBlock(imageData);
        });
    });
}


@end


















































