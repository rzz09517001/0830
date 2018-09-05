//
//  BNRImageStore.m
//  Homepwner
//
//  Created by macOs on 2018/9/4.
//  Copyright © 2018年 rzz. All rights reserved.
//

#import "BNRImageStore.h"

@interface BNRImageStore()

@property(nonatomic, strong) NSMutableDictionary *dictionary;
-(NSString *)imagePathForKey:(NSString *)key;
@end

@implementation BNRImageStore

+(instancetype)sharedStore
{
    static BNRImageStore *sharedStore = nil;
//    if (!sharedStore) {
//        sharedStore = [[self alloc] initPrivate];
//    }
    //安全线程创建
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    return sharedStore;
}

-(instancetype)init
{
    @throw [NSException exceptionWithName:@"singleton" reason:@"Use+[BNRImageStore sharedStore]" userInfo:nil];
    return nil;
}

-(instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(clearCache:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}


-(void)clearCache:(NSNotification *)note
{
    NSLog(@"flushing %d images out of the cache",[self.dictionary count]);
    [self.dictionary removeAllObjects];
}

-(NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathExtension:key];
}

-(void)setImage:(UIImage *)image forkey:(NSString *)key
{
    //[self.dictionary setObject:image forKey:key];
    self.dictionary[key] = image;
    NSString *path = [self imagePathForKey:key];
    //从图片提取JPEG格式的数据
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    //将JPEG格式的数据写入文件
    [data writeToFile:path atomically:YES];
}

-(UIImage *)imageForKey:(NSString *)key
{
    //return [self.dictionary valueForKey:key];
    //return self.dictionary[key];
    //先尝试通过字典对象获取图片
    UIImage *image = self.dictionary[key];
    if (!image) {
        NSString *imagePath = [self imagePathForKey:key];
        image = [UIImage imageWithContentsOfFile:imagePath];
        if (image) {
            self.dictionary[key] = image;
        } else {
            NSLog(@"Error:unable to find %@", [self imagePathForKey:key]);
        }
    }
    return image;
}

-(void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
    NSString *imagePath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
}

@end
