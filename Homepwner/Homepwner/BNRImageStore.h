//
//  BNRImageStore.h
//  Homepwner
//
//  Created by macOs on 2018/9/4.
//  Copyright © 2018年 rzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BNRImageStore : NSObject

+(instancetype)sharedStore;
-(void)setImage:(UIImage *)image forkey:(NSString *)key;
-(UIImage *)imageForKey:(NSString *)key;
-(void)deleteImageForKey:(NSString *)key;

@end
