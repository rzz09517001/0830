//
//  BNRItemStore.h
//  Homepwner
//
//  Created by macOs on 2018/9/3.
//  Copyright © 2018年 rzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNRItem;
@interface BNRItemStore : NSObject

@property(nonatomic, readonly)NSArray *allItems;

+(instancetype)sharedStore;
-(BNRItem *)createItem;
-(void)removeItem:(BNRItem *)item;
-(void)mobveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
@end
