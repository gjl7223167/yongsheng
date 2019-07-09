//
//  ViewController.m
//  YSObject
//
//  Created by Long on 2019/2/22.
//  Copyright © 2019 Long. All rights reserved.
//

#import "ViewController.h"
#import "scoketModel.h"
#import "myTableViewCell.h"
#import "NotworkDataCell.h"
#import "DataModel.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tabView;
    NSMutableArray * _dataAry;
    
    UIButton * myButton;
    
    UIBarButtonItem*_button3;
    UIBarButtonItem*_button2;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"听单中...";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithImage:[UIImage imageNamed:@"nav_left_icon"]
                                            style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(leftbarMethod:)];
    
    
    
    
    UIToolbar*tools=[[UIToolbar alloc]initWithFrame:CGRectMake(5, 0, 120, 39)];
    //解决出现的那条线
    tools.clipsToBounds = YES;
    //解决tools背景颜色的问题
    [tools setBackgroundImage:[UIImage new]forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [tools setShadowImage:[UIImage new]
       forToolbarPosition:UIToolbarPositionAny];
    //添加两个button
    NSMutableArray*buttons=[[NSMutableArray alloc]initWithCapacity:2];
    _button3=[[UIBarButtonItem alloc]initWithTitle:@"疯狂" style: UIBarButtonItemStyleDone target:self action:@selector(crazyMethod)];
    _button2=[[UIBarButtonItem alloc]initWithTitle:@"正常" style: UIBarButtonItemStyleDone target:self action:@selector(normalMethod)];
    _button3.tintColor=[UIColor grayColor];
    _button2.tintColor=[UIColor blueColor];

    [buttons addObject:_button3];
    [buttons addObject:_button2];
    [tools setItems:buttons animated:NO];
    UIBarButtonItem*btn=[[UIBarButtonItem    alloc]initWithCustomView:tools];
    self.navigationItem.rightBarButtonItem=btn;
    
    
    _dataAry = [NSMutableArray arrayWithCapacity:10];
//    DataModel * dataItem = [self retModel];
//    [_dataAry addObject:dataItem];
//    
    
    
    _tabView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:_tabView];

    _tabView.estimatedRowHeight = 0;
    _tabView.estimatedSectionFooterHeight = 0;
    _tabView.estimatedSectionHeaderHeight = 0;
    _tabView.delegate = self;
    _tabView.dataSource = self;
    _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tabView.separatorColor = [UIColor colorWithRGBHex:0xe4e4e4];
    _tabView.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
    _tabView.contentInset = UIEdgeInsetsZero;
    _tabView.contentInset = UIEdgeInsetsMake(-34, 0, 0, 0);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFromSocketData:) name:@"NotificationSocketTick" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFromSocketStauts:) name:@"NotificationSocketStatus" object:nil];
    
    
    
    
    if(@available(iOS 11.0, *)){
        _tabView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    _tabView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self
                                                               refreshingAction:@selector(handleRefreshHomePage:)];
    
    
    [[scoketModel sharedInstance] connect];
    
    
    myButton = [[UIButton alloc] initWithFrame:CGRectZero];
    myButton.lblCustom = [UILabel initWithFrame:CGRectZero
                                        bgColor:[UIColor clearColor]
                                      textColor:[UIColor colorWithRGBHex:0x2c2c2c]
                                           text:@"当前状态"
                                  textAlignment:NSTextAlignmentCenter
                                           font:[Utility antLivePingFangSCRegularWithSize:16]];
    [myButton.lblCustom sizeToFit];
    myButton.lblCustom.top = 20;
    myButton.lblCustom.width += 5;
    myButton.lblCustom2 = [UILabel initWithFrame:CGRectMake(0, 0, 5, 5)
                                         bgColor:[UIColor clearColor]
                                       textColor:[UIColor clearColor]
                                            text:@""
                                   textAlignment:NSTextAlignmentLeft
                                            font:[Utility antLivePingFangSCRegularWithSize:16]];
    myButton.lblCustom2.centerX = myButton.lblCustom.centerX;
    myButton.lblCustom2.layer.masksToBounds = YES;
    myButton.lblCustom2.layer.cornerRadius = 5 / 2.0;
    
    [myButton addSubview:myButton.lblCustom];
    [myButton addSubview:myButton.lblCustom2];
    
    
    [self.view addSubview:myButton];
    [self.view bringSubviewToFront:myButton];
    

    myButton.width = myButton.lblCustom.width;
    myButton.height = myButton.width;
    myButton.bottom = UIScreenHeight - 20;
    myButton.right = UIScreenWidth - 20;
    
    myButton.lblCustom.centerY = myButton.height /2.0;
    myButton.lblCustom2.top = myButton.lblCustom.bottom + 3;

    
    myButton.backgroundColor = [UIColor colorWithRGBHex:0xD3D3D3];
    myButton.layer.masksToBounds = YES;
    myButton.layer.cornerRadius = myButton.width / 2.0;
    
    [myButton addTarget:self action:@selector(didMyBottomMonther:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)leftbarMethod:(UIBarButtonItem *)sender{
    
}

- (void)handleRefreshHomePage:(UIRefreshControl*)refreshControl{
    
    [_tabView.mj_header beginRefreshing];
    [myButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self->_tabView.mj_header endRefreshing];
    });
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NetworkManager shareInstance] testNetwork];
}

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataAry.count >= 1) {
        DataModel * model = [_dataAry objectAtIndex:indexPath.row];
        float height = [[myTableViewCell class] tableView:tableView heightForRowAtIndexPath:indexPath withObject:model];
        return height;
    }else{
        return 300.0f;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataAry.count >= 1) {
        return _dataAry.count;
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (_dataAry.count >= 1) {
        NSString *cellIdentifier = [NSString stringWithFormat:@"CELLID%@",NSStringFromClass([myTableViewCell class])];
        myTableViewCell<TableViewCellProtocol> *tCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (tCell == nil) {
            tCell = [myTableViewCell defaultCell];
            tCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [tCell setupCellForModel:[_dataAry objectAtIndex:indexPath.row]];
        [tCell isHiddenImage:[_dataAry objectAtIndex:indexPath.row]];
        return tCell;
    }else{
        NotworkDataCell * notCell = [tableView dequeueReusableCellWithIdentifier:@"NotworkDataCell"];
        if (notCell == nil) {
            notCell = [[NotworkDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NotworkDataCell"];
        }
        return notCell;
    }
  
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    [PDProgressHUD showTip:@"点击单元测试"];
    NSLog(@"____");
    [[scoketModel sharedInstance] writeData:@""];
}



-(void)didFromSocketData:(NSNotification *)obj{
    NSLog(@"页面刷新");
    DataModel * model = obj.object;
    [_dataAry addObject:model];
    [_tabView reloadData];
    NSInteger row = [_tabView numberOfRowsInSection:0];
    [_tabView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row-1
                                                            inSection:0]
                        atScrollPosition:UITableViewScrollPositionBottom
                                animated:YES];
}

-(void)didFromSocketStauts:(NSNotification *)obj{
    if ([scoketModel sharedInstance].currentConnectStatus) {
        myButton.lblCustom2.backgroundColor = [UIColor colorWithRGBHex:0x00c074];
        self.title = @"听单中...";

    }else{
        myButton.lblCustom2.backgroundColor = [UIColor colorWithRGBHex:0xec384c];
        self.title = @"连接断开";

    }
}



-(void)didMyBottomMonther:(UIButton *)sender{
    if ([scoketModel sharedInstance].currentConnectStatus) {
        [[scoketModel sharedInstance] writeData:myOrderId];
        NSLog(@".............");

    }else{
        [[scoketModel sharedInstance] connect];
    }
    
    
    myButton.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:0 animations: ^{
    [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 3.0 animations: ^{

        self->myButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
    [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations: ^{

        self->myButton.transform = CGAffineTransformMakeScale(0.8, 0.8);
    }];
    [UIView addKeyframeWithRelativeStartTime:2/3.0 relativeDuration:1/3.0 animations: ^{

        self->myButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:nil];
}


-(void)crazyMethod{
    [[scoketModel sharedInstance] crazyModel];
    _button3.tintColor=[UIColor blueColor];
    _button2.tintColor=[UIColor grayColor];
}

-(void)normalMethod{
    [[scoketModel sharedInstance] normalModel];
    _button3.tintColor=[UIColor grayColor];
    _button2.tintColor=[UIColor blueColor];
}


-(DataModel *)retModel{
    DataModel * dataItem = [[DataModel alloc] init];
    dataItem.CustomerPhone = @"112231123";
    dataItem.CreateDate = @"2019.1.2:20:30";
    dataItem.CarNo = @"测试";
    dataItem.Status = @(0);
    dataItem.LngLat = @"123456";
    return dataItem;
}


//http://183.196.249.184:9003/driver.ashx?func=updateordergrab&orderidid=266995&driverid=129&companyid=23&lng=116.330229&lat=39.897652&token=9962412DBD2A731845887C01D745FA13

@end
