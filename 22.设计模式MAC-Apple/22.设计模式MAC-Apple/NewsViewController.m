//
//  NewsViewController.m
//  22.设计模式MAC-Apple
//
//  Created by fengsl on 2019/7/22.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import "NewsViewController.h"
#import "Shop.h"
#import "News.h"

@interface NewsViewController ()
@property (nonatomic, strong) NSMutableArray *newsData;
@property (nonatomic, strong) NSMutableArray *shopData;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self loadShopData];
}


- (void)loadShopData
{
    self.shopData = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        Shop *shop = [[Shop alloc]init];
        shop.name = [NSString stringWithFormat:@"商品-%d",i];
        shop.price = [NSString stringWithFormat:@"￥19.%d",i];
        [self.shopData addObject:shop];
    }
}


- (void)loadNewsData
{
    self.newsData = [NSMutableArray array];
    
    for (int i = 0; i < 20; i++) {
        News *news = [[News alloc] init];
        news.title = [NSString stringWithFormat:@"news-title-%d", i];
        news.content = [NSString stringWithFormat:@"news-content-%d", i];
        [self.newsData addObject:news];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.shopData.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
    
    Shop *shop = self.shopData[indexPath.row];
    
    cell.detailTextLabel.text = shop.price;
    cell.textLabel.text = shop.name;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"1111");
}

@end
