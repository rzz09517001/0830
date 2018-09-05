//
//  BNRItemsViewController.m
//  Homepwner
//
//  Created by macOs on 2018/9/3.
//  Copyright © 2018年 rzz. All rights reserved.
//

#import "BNRItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRItemCell.h"
#import "BNRImageViewController.h"
#import "BNRImageStore.h"

@interface BNRItemsViewController()<UIPopoverControllerDelegate>

//@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) UIPopoverController *imagePopover;

@end

@implementation BNRItemsViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
//    UIView *header = self.headerView;
//    [self.tableView setTableHeaderView:header];
    //创建nib对象，该对象代表包含了BNRItemCell的NIB文件
    UINib *nib = [UINib nibWithNibName:@"BNRItemCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"BNRItemCell"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.tableView reloadData];
    
}
/**
 根据用户首选字体大小设置tableView的行高
 */
-(void)updateTableViewForDynamicTypeSize
{
    static NSDictionary *cellHeightDictionary;
    if (! cellHeightDictionary) {
        cellHeightDictionary = @{
            UIContentSizeCategoryExtraSmall:@44,
            UIContentSizeCategorySmall:@44,
            UIContentSizeCategoryMedium:@44,
            UIContentSizeCategoryLarge:@44,
            UIContentSizeCategoryExtraLarge:@55,
            UIContentSizeCategoryExtraExtraLarge:@65,
            UIContentSizeCategoryExtraExtraExtraLarge:@75};
    }
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    NSNumber *cellHeight = cellHeightDictionary[userSize];
    [self.tableView setRowHeight:cellHeight.floatValue];
    [self.tableView reloadData];
}

//-(UIView *)headerView
//{
//    if (!_headerView) {
//        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
//    }
//    return _headerView;
//}
-(instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *item = self.navigationItem;
        item.title = @"Hompwner";
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        item.rightBarButtonItem = bbi;
        item.leftBarButtonItem = self.editButtonItem;
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(updateTableViewForDynamicTypeSize) name:UIContentSizeCategoryDidChangeNotification object:nil];
        
    }
    return self;
}

-(void)dealloc
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

-(IBAction)addNewItem:(id)sender
{
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
//    NSInteger lastRow = [[[BNRItemStore sharedStore] allItems] indexOfObject:newItem];
//    //NSInteger lastRow = [self.tableView numberOfRowsInSection:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
//    //将新行charityUITabelView对象
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] initForNewItem:YES];
    detailViewController.item = newItem;
    detailViewController.dissmissBlock = ^{
        [self.tableView reloadData];
    };
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    //设置视图显示动画
    navController.modalPresentationStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:navController animated:YES completion:nil];
}

//-(IBAction)toggleEditingMode:(id)sender
//{
//    if (self.isEditing) {
//        //修改按钮文字，提示用户当前的表格状态
//        [sender setTitle:@"Edit" forState:UIControlStateNormal];
//        // 关闭编辑模式
//        [self setEditing:NO animated:YES];
//    } else {
//        //修改按钮文字，提示用户当前的表格状态
//        [sender setTitle:@"Done" forState:UIControlStateNormal];
//        //开启编辑模式
//        [self setEditing:YES animated:YES];
//    }
//}

#pragma mark - TableView data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    BNRItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BNRItemCell"];
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *item = items[indexPath.row];
    //cell.textLabel.text = [item description];
    //根据BNRItem对象设置BNRItemCell对象
    cell.nameLabel.text = item.itemName;
    cell.serialNumberLabel.text = item.serialNumber;
    cell.valueLabel.text = [NSString stringWithFormat:@"$%d",item.valueInDollars];
    cell.imageView.image = item.thumbnail;
    __weak BNRItemCell *weakCell = cell;
    cell.actionBlock = ^{
        NSLog(@"showimage %@",item);
        BNRItemCell *strongCell = weakCell;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            NSString *itemKey = item.itemKey;
            //如果BNRItem对象没有图片，就直接返回
            UIImage *image = [[BNRImageStore sharedStore] imageForKey:itemKey];
            if (!image) {
                return ;
            }
            //根据UITableView对象的坐标系获取UIImageView对象的位置和大小
            CGRect rect = [self.view convertRect:strongCell.thumbnailView.bounds fromView:strongCell.thumbnailView];
            //创建BNRImageViewCotroller对象并未image属性赋值
            BNRImageViewController *ivc = [[BNRImageViewController alloc] init];
            ivc.image = image;
            //根据对象的位置和大小，显示一个600*600的UIPopoverController对象
            self.imagePopover = [[UIPopoverController alloc] initWithContentViewController:ivc];
            self.imagePopover.delegate = self;
            self.imagePopover.popoverContentSize = CGSizeMake(600, 600);
            [self.imagePopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[BNRItemStore sharedStore] allItems];
        BNRItem *item = items[indexPath.row];
        [[BNRItemStore sharedStore] removeItem:item];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] mobveItemAtIndex:sourceIndexPath.row    toIndex:destinationIndexPath.row];
}

#pragma mark - TableView delegate
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] init];
    BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] initForNewItem:NO];
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *item = items[indexPath.row];
    detailViewController.item = item;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark UIPopoverControllerDelegate
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.imagePopover = nil;
}
@end
