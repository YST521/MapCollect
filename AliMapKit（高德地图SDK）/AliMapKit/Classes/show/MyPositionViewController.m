//
//  MyPositionViewController.m
//  MyPosition
//
//  Created by apple4 on 16/7/20.
//  Copyright © 2016年 apple4. All rights reserved.
//

#import "MyPositionViewController.h"
#import "GotoViewController.h"

@interface MyPositionViewController ()
@property (strong, nonatomic)CLLocationManager* locationManager;
@property(nonatomic,assign)double cureeLa;
@property(nonatomic,assign)double cureeLon;


@end

@implementation MyPositionViewController
{
    NSArray              *locationArray;
    NSMutableDictionary  *data;
    double           la;
     double             lon;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"餐厅位置";


    self.locationManager = [[CLLocationManager alloc]init];
    
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    self.mapView.rotateEnabled = NO;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"position" ofType:@"plist"];
    data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
   
    //NSLog(@"%@",data);
    [self loadMyPosition];
    
    
    
    //添加跳转按钮
    [self addButton];
    // Do any additional setup after loading the view from its nib.
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

- (void)loadMyPosition{

    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"开始定位－－－－－－－");
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        self.locationManager.distanceFilter = 1;
        
        self.locationManager.delegate = self;
        
        [self.locationManager requestAlwaysAuthorization];
        //开始定位
        [self.locationManager startUpdatingLocation];
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
        [self.mapView setRegion:region animated:YES];
        [self.locationManager stopUpdatingLocation];
        self.cureeLa = location.coordinate.latitude;
        self.cureeLon = location.coordinate.longitude;
        
        
        [self locateTOLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    }else{
    
        NSLog(@"locations 为空，定位失败");
    }
    
    
   
}

//添加大头针
- (void)locateTOLatitude:(double)latitude longitude:(double)longitude{

    /*
     39 =     {
     address = "\U5e7f\U4e1c\U7701\U5e7f\U5dde\U5e02\U6d77\U73e0\U533a\U8d64\U5c97\U8857\U9053\U7434\U6d77\U5c45";
     lat = "23.105831";
     lon = "113.317366";
     name = "\U65b0\U7406\U60f3\U534e\U5ead";
     */
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
        [self.mapView addAnnotation:annotation];
    }

   
}

 //自定义标注图片
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
    static NSString* annoId = @"Anno";
    MKAnnotationView* annoView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:annoId];
    
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
    [self.mapView addSubview:btn];

}


//跳转到移动轨迹页面  路线规划
- (void)showMyTrajectory:(UIButton*)btn{
    //    la =annotation.coordinate.latitude;
    //    lon =annotation.coordinate.longitude;

    GotoViewController *gotoVC =[[GotoViewController alloc]init];
    gotoVC.la = la;
    gotoVC.lon = lon;
    gotoVC.cla =self.cureeLa;
    gotoVC.clon = self.cureeLon;
    [self.navigationController pushViewController:gotoVC animated:YES];
}
@end
