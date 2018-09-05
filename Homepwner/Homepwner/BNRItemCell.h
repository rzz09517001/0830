//
//  BNRItemCell.h
//  Homepwner
//
//  Created by macOs on 2018/9/5.
//  Copyright © 2018年 rzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNRItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (nonatomic, copy) void (^actionBlock)(void);

@end
