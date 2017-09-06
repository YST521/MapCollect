//
//  MorePointViewController.m
//  AliMapKit
//
//  Created by youxin on 2017/9/6.
//  Copyright © 2017年 广州市东德网络科技有限公司. All rights reserved.
//

#import "MorePointViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "GotoViewController.h"
#import "MyPositionViewController.h"

// 获取物理屏幕的宽度
#define SceneWidth             [[UIScreen mainScreen] bounds].size.width
#define SceneHeight            [[UIScreen mainScreen] bounds].size.height

@interface MorePointViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate,CLLocationManagerDelegate>{
    
    UISegmentedControl *segmentedControl;
    UITableView       *addressListTabView;
    UITableView       *mapTabView;
    UIScrollView       *scrollview;
    UILabel            *cellTilteLa;
    UIView             *mapHeadView;
    CLLocationManager *locationManager;//定位管理类
    NSArray             *locationArray;
    NSMutableDictionary *data;
    
    
}
@property(nonatomic,strong)CLGeocoder*geocoder;
@property(nonatomic,assign)double cureeLa;
@property(nonatomic,assign)double cureeLon;
@property(nonatomic,strong)MKMapView      *mapView;


@end

static NSString *mapCellID = @"mapCellID";
static NSString *addressCellID = @"addressCellID";

@implementation MorePointViewController

-(CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder =[[CLGeocoder alloc]init];
    }
    return _geocoder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //原生地图 添加多个大头针  循环添加
    
   self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    
    [self creatNaView];
    [self creatScrollerView];
    [self creatTabView]; /**定位当前*/
    
}

- (void)creatScrollerView{
    
    scrollview = [[UIScrollView alloc]init];
    scrollview.frame = CGRectMake(0, 0, SceneWidth, SceneHeight);
    [self.view addSubview:scrollview];
    scrollview.delegate = self;
    scrollview.contentSize = CGSizeMake(SceneWidth*2, 0);
    scrollview.showsHorizontalScrollIndicator = NO;
}
- (void)creatTabView{
    
    addressListTabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SceneWidth, SceneHeight) style:(UITableViewStylePlain)];
    [scrollview addSubview:addressListTabView];
    addressListTabView.dataSource = self;
    addressListTabView.delegate = self;
//    [addressListTabView registerNib:[UINib nibWithNibName:@"OrdelAddressListCell" bundle:nil] forCellReuseIdentifier:addressCellID];
    [addressListTabView registerClass:[UITableViewCell class] forCellReuseIdentifier:addressCellID];
    
    // addressListTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [addressListTabView setTableFooterView:[[UIView alloc]init]];
    
    mapTabView = [[UITableView alloc]initWithFrame:CGRectMake(SceneWidth, 0, SceneWidth, SceneHeight) style:(UITableViewStylePlain)];
    [scrollview addSubview:mapTabView];
    mapTabView.dataSource = self;
    mapTabView.delegate = self;
//    [mapTabView registerNib:[UINib nibWithNibName:@"MapListCell" bundle:nil] forCellReuseIdentifier:mapCellID];
    [mapTabView registerClass:[UITableViewCell class] forCellReuseIdentifier:mapCellID];
    
    locationManager = [[CLLocationManager alloc]init];
    
    //后期替换为高德SDK 取代系统自带
    self.mapView  =[[MKMapView alloc]init];
    self.mapView.frame = CGRectMake(0, 0, SceneWidth,SceneHeight*0.8);
    //绑定委托
    self.mapView.userTrackingMode=MKUserTrackingModeFollow;//蓝色光圈
    //跟踪用户位置
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    self.mapView.rotateEnabled = NO;
    
    
    mapTabView.tableHeaderView = self.mapView;
    mapTabView.tableFooterView =[[UIView alloc]init];
    
    //假数据
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"position" ofType:@"plist"];
    data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    //时间
    self.mapView.delegate=self;
    
    mapTabView.tableHeaderView =self.mapView;
    mapTabView.tableFooterView =[[UIView alloc]init];
    
    //NSLog(@"%@",data);
    [self loadMyPosition];
    
    //添加跳转按钮
    [self addButton];
    
}

- (void)creatNaView{
    UIView *naView =[[UIView alloc]init];
    
    naView.frame = CGRectMake(0, 20, SceneWidth, 44);
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"列表展示",@"地图展示",nil];
    segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake((SceneWidth-160)/2-50, 7, 80*2, 30);
    
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor whiteColor];
    segmentedControl.backgroundColor=[UIColor whiteColor];
    segmentedControl.layer.cornerRadius = 5;
    segmentedControl.layer.masksToBounds = YES;
    
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor greenColor]}forState:UIControlStateSelected];
    
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[self colorWithHexStringg:@"#999999"],NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0f]}forState:UIControlStateNormal];
    [naView addSubview:segmentedControl];
    self.navigationItem.titleView = naView;
    [segmentedControl addTarget:self action:@selector(didClicksegmentedControlAction:)forControlEvents:UIControlEventValueChanged];
    
}

- (UIColor *) colorWithHexStringg: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}



-(void)didClicksegmentedControlAction:(UISegmentedControl *)Seg{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    
    NSLog(@"Index %li", (long)Index);
    
    switch (Index) {
            
        case 0:
            [scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
            break;
            
        case 1:
            
            [scrollview setContentOffset:CGPointMake(SceneWidth, 0) animated:YES];
            
            break;
            
        default:
            
            break;
            
    }
    
}

#pragma mark -UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == addressListTabView) {
        return 3;
    }else{
        return 1;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == addressListTabView) {
        return 5;
    }else{
        return 3;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == addressListTabView) {
        return 40;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == addressListTabView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addressCellID ];
        cell.textLabel.text = @"666";
        return cell;
    }else{
        
        UITableViewCell *cell = [mapTabView dequeueReusableCellWithIdentifier:mapCellID];
        cell.textLabel.text = @"888";
        
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 75;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*view =[[UIView alloc]init];
    view.frame =CGRectMake(0, 0, SceneWidth, 40);
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIView *suqareView =[[UIView alloc]init];
    suqareView.frame = CGRectMake(0, 0, 18, 13);
    suqareView.center = CGPointMake(20+9, view.frame.size.height/2);
    suqareView.backgroundColor = [UIColor greenColor];
    suqareView.backgroundColor =   [UIColor redColor];
    suqareView.layer.cornerRadius = 3;
    suqareView.clipsToBounds = YES;
    [view addSubview:suqareView];
    
    cellTilteLa =[[UILabel alloc]init];
    cellTilteLa.frame = CGRectMake(CGRectGetMaxX(suqareView.frame)+10, 10, SceneWidth/3, 20);
    cellTilteLa.textColor =[self colorWithHexStringg:@"#333333"];
    cellTilteLa.font =[UIFont systemFontOfSize:14];
    [view addSubview:cellTilteLa];
    cellTilteLa.text =@"当前食堂";
    return view;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MyPositionViewController* main = [[MyPositionViewController alloc] initWithNibName:@"MyPositionViewController" bundle:nil];
    
    [self.navigationController pushViewController:main animated:YES];
}

#pragma mark - cellBtnClickAction
-(void)passRequestNewLocation:(id)sender{
    NSLog(@"请求重新定位BtnAction");
    
}

#pragma mark -map
- (void)loadMyPosition{
    
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"开始定位－－－－－－－");
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        locationManager.distanceFilter = 1;
        
        locationManager.delegate = self;
        
        [locationManager requestAlwaysAuthorization];
        //开始定位
        [locationManager startUpdatingLocation];
    }else{
        
        NSLog(@"定位无法使用＝－－－－－－");
    }
    
}
//定位成功后激发的方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations{
    
    //获取最后一个定位数据
    if ([locations count] > 0) {
        CLLocation* location = [locations lastObject];
        
        //设置地图中心的精度、纬度
        CLLocationCoordinate2D center = {location.coordinate.latitude,location.coordinate.longitude};
        //设置地图显示的范围
        MKCoordinateSpan span;
        
        span.latitudeDelta = 0.02;
        span.longitudeDelta = 0.02;
        
        //创建 MKCoordinateRegion 对象，该对象代表地图的显示中心和显示范围
        MKCoordinateRegion region = {center,span};
        [_mapView setRegion:region animated:YES];
        [locationManager stopUpdatingLocation];
        self.cureeLa = location.coordinate.latitude;
        self.cureeLon = location.coordinate.longitude;
        
        //添加大头针
        [self locateTOLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    }else{
        
        NSLog(@"locations 为空，定位失败");
    }
    
    
    
}

//添加大头针
- (void)locateTOLatitude:(double)latitude longitude:(double)longitude{
    
    NSLog(@"*******%lu",(unsigned long)data.count);
    for (int i = 1;i <= data.count;i ++) {
        NSString* key = [NSString stringWithFormat:@"%d",i];
        
        NSMutableDictionary *positionDic = [data valueForKey:key];
        NSLog(@"%@",positionDic);
        //添加描点
        
        MKPointAnnotation* annotation = [[MKPointAnnotation alloc]init];
        annotation.title = [positionDic valueForKey:@"name"];
        annotation.subtitle = [positionDic valueForKey:@"address"];
        NSString* lat = [positionDic valueForKey:@"lat"] ;
        NSString* lon = [positionDic valueForKey:@"lon"];
        
        CLLocationCoordinate2D coordinate = {[lat floatValue],[lon floatValue]};
        
        annotation.coordinate = coordinate;
        
        [_mapView addAnnotation:annotation];
    }
    
    
}

//自定义标注图片
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        static NSString* annoId = @"Anno";
        MKAnnotationView* annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:annoId];
        
        if (!annoView) {
            annoView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:annoId];
        }
        
        annoView.image = [UIImage imageNamed:@"iconfont-mark"];
        
        annoView.canShowCallout = YES;
        //经纬度
        NSLog(@"mmm----%f",annotation.coordinate.latitude);
        
        
        //start 添加一个跳转按钮，点击跳转到 轨迹页面
        UIButton* button = [UIButton  buttonWithType:UIButtonTypeDetailDisclosure];
        [button addTarget:self action:@selector(showMyTrajectory:) forControlEvents:UIControlEventTouchDown];
        annoView.rightCalloutAccessoryView = button;
        
        //end
        
        return annoView;
    }
    return nil;
}


- (void)addButton{
    
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height - 160, 40, 40)];
    [btn setImage:[UIImage imageNamed:@"location_point"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(loadMyPosition) forControlEvents:UIControlEventTouchDown];
    [_mapView addSubview:btn];
    
}

//跳转到移动轨迹页面  路线规划
- (void)showMyTrajectory:(UIButton*)btn{
    //    la =annotation.coordinate.latitude;
    //    lon =annotation.coordinate.longitude;
    
    GotoViewController *gotoVC =[[GotoViewController alloc]init];
    //    gotoVC.la = la;
    //    gotoVC.lon = lon;
    gotoVC.cla =self.cureeLa;
    gotoVC.clon = self.cureeLon;
    [self.navigationController pushViewController:gotoVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
