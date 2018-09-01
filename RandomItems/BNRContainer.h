//
//  BNRContainer.h
//  RandomItems
//
//  Created by macOs on 2018/9/1.
//  Copyright © 2018年 rzz. All rights reserved.
//

#import "BNRItem.h"

@interface BNRContainer : BNRItem

{
    NSMutableArray<BNRItem *> *subItems;
}

-(void)setSubItems:(BNRItem *)item;

@end
