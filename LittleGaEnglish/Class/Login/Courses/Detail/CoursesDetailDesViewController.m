//
//  CoursesDetailDesViewController.m
//  LittleGaEnglish
//
//  Created by Jed on 16/2/27.
//  Copyright © 2016年 Jed. All rights reserved.
//

#import "CoursesDetailDesViewController.h"
#import "MyUITableView.h"
#import "CoureseDetaiNameCell.h"
#import "CouresesDetailDesTableViewCell.h"
#import "CoursesDetailMovieTableViewCell.h"
#import "CourseDetailModel.h"
#import "BBMovieViewController.h"
#import "BuyViewController.h"
#import "BBLoginViewController.h"

@interface CoursesDetailDesViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)MyUITableView *tableView;


@end

@implementation CoursesDetailDesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    
}

- (void)setUpView
{
    self.tableView = [[MyUITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
//    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.bottom.equalTo(@0);
////        make.edges.equalTo(self.view);
//    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return self.model.lesson_list.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0:
        {
            static NSString *identifier = @"name";
            CoureseDetaiNameCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                
                NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"CoureseDetaiNameCell" owner:nil options:nil];
                cell= nibs.firstObject;
            }
            cell.model = self.model.courseClass;
            return cell;
        }
            break;
        case 1:{
            static NSString *identifier = @"des";
            CouresesDetailDesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                
                NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"CouresesDetailDesTableViewCell" owner:nil options:nil];
                cell= nibs.firstObject;
            }
            cell.model = self.model.courseClass;
            return cell;
        }
            break;
            
        case 2:{
            static NSString *identifier = @"movie";
            CoursesDetailMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                
                NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"CoursesDetailMovieTableViewCell" owner:nil options:nil];
                cell= nibs.firstObject;
            }

            CourseLessonModel *model = self.model.lesson_list[indexPath.row];
            cell.model = model;
            if ([self.model.courseClass.is_can_watch_all isEqualToString:@"1"]) {
                cell.canPlay = YES;
            } else {
                cell.canPlay = NO;
            }
            
            cell.playBlock = ^(){
                BBMovieViewController *movieVC= [BBMovieViewController new];
                movieVC.videoId = model.video_id;
                movieVC.videoName = model.name;
                [self.VC.navigationController pushViewController:movieVC animated:YES];
            };
            
            cell.buyBlock = ^(){
                if (![self isLogin]) {
                    return;
                }
                if ([self.model.courseClass.is_can_order isEqualToString:@"1"]) {
                    BuyViewController *buyVC = [BuyViewController new];
                    buyVC.classID = self.courseID;
                    [self.navigationController pushViewController:buyVC animated:YES];
                }
            };
            
            return cell;
            
            break;
        }
        default:
            break;
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44;
    switch (indexPath.section) {
        case 0:
        {
            height = 115;
        }
            break;
        case 1:{
            height = 130;
        }
            break;
        case 2:{
            height = 237;
        }
            break;
        default:
            break;
    }
    return height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        CourseLessonModel *model = self.model.lesson_list[indexPath.row];
        BBMovieViewController *movieVC= [BBMovieViewController new];
        movieVC.videoId = model.video_id;
        movieVC.videoName = model.name;
        [self.VC.navigationController pushViewController:movieVC animated:YES];
    }
}

- (BOOL)isLogin
{
    if ([UserDao share].isLogin) {
        return YES;
    } else {
        BBLoginViewController *loginVC = [BBLoginViewController new];
        loginVC.selectIndex = 1;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    return NO;
}

- (void)setModel:(CourseDetailModel *)model
{
    _model = model;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
