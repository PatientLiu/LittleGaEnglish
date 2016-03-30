//
//  ScoredController.m
//  LittleGaEnglish
//
//  Created by  mac on 16/3/28.
//  Copyright © 2016年 Jed. All rights reserved.
//

#import "ScoredController.h"
#import "UIViewController+WDNavResponderAction.h"
#import "LvCell.h"
#import "ListCell.h"
#import "RuleViewController.h"
#import "WDNetAPIRequestWithAFNManage.h"
#import "MIneScoreInfoModel.h"
#import "UIImageView+WebCache.h"

@interface ScoredController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *table;

@end

@implementation ScoredController
- (void)viewWillAppear:(BOOL)animated{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //界面配置
    [self initializeFace];
    //请求数据
    [self initializeData];
}
//请求数据
- (void)initializeData{
    NSDictionary *dict = @{@"token":@"3f956b583bbd705adf0f1fb7599b821c"};
    [[WDNetAPIRequestWithAFNManage share]httpRequestWithMethod:@"GET" URL:@"http://app.xiaokaen.com/api/userCenter/myIntegralUser" Params:dict HTTPHeader:nil requestSuccess:^(id json) {
        
        NSLog(@"%@",json);
        
        NSDictionary *dict = (NSDictionary *)json;
        NSLog(@"dict.class == %@",dict.class);
        NSDictionary *tempDict = dict[@"data"];
        NSMutableArray *temp = [NSMutableArray array];
        
        MIneScoreInfoModel *model = [MIneScoreInfoModel setInfoWithDict:tempDict];
        [temp addObject:model];
        
    } requestFailure:^(NSError *error) {
        
    }];
}
- (void)initializeFace{
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"我的积分";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    WeakSelf(weakS);
    [self setRightBarButtonWithString:@"规则说明" responderBlcok:^{
        RuleViewController *rule = [[RuleViewController alloc] init];
        [weakS.navigationController pushViewController:rule animated:YES];
        
    }];

}
#pragma TableView Delegate DataSourse
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString *lvCellIdentifier = @"Lv";
        LvCell *cell = (LvCell*)[tableView dequeueReusableCellWithIdentifier:lvCellIdentifier];
        if(cell == nil){
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"LvCell" owner:self options:nil];
            for(id oneObject in nib){
                if([oneObject isKindOfClass:[LvCell class]]){
                    cell = (LvCell *)oneObject;
                }
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //设置icon圆角
        CALayer *cellImage = cell.icon.layer;
        [cellImage setMasksToBounds:YES];
        [cell.icon setImageWithURL:@"bdf" placeholderImage:[UIImage imageNamed:@""]];
        return cell;
    }else if(indexPath.row == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"积分明细";
        cell.contentView.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.1];
        return cell;
    
    }else{
        
        static NSString *listCellIdentifier = @"List";
        BOOL nibsRegistered = NO;
        if(!nibsRegistered){
            UINib *nib = [UINib nibWithNibName:@"ListCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:listCellIdentifier];
            nibsRegistered = YES;
           // }
        }
         ListCell *cell = (ListCell*)[tableView dequeueReusableCellWithIdentifier:listCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row ==2) {
            cell.contentView.backgroundColor = RGBA(233, 245, 253, 1);
         }
        return cell;
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
         return 88;
    }else{
        return 35;
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

@end