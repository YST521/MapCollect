
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


// 获取物理屏幕的宽度
#define SceneWidth (([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height) ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height)
// 获取物理屏幕的高度
#define SceneHeight (([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height) ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width)

@interface MapViewController ()<MKMapViewDelegate>{
    CLLocationManager *_locationManager;
    
}

@property(nonatomic,strong)MKMapView *mapView;
@property(nonatomic,strong)UILabel*  label;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    
    [self creatMapView];
    
}

-(void)creatMapView{
    
//    http://www.cnblogs.com/kenshincui/p/4125570.html
//http://blog.csdn.net/Hierarch_Lee/article/details/48752393
    
    self.mapView=[[MKMapView alloc]init];
    self.mapView.frame = CGRectMake(0, 0,SceneWidth , SCREEN_HEGHT*0.6);
    [self.view addSubview:self.mapView];
    self.mapView.delegate = self;
    
 //原生地图使用   http://www.cnblogs.com/kenshincui/p/4125570.html
    //请求定位服务
    _locationManager=[[CLLocationManager alloc]init];
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        [_locationManager requestWhenInUseAuthorization];
    }
    
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    _mapView.userTrackingMode=MKUserTrackingModeFollow;
    
    //设置地图类型
    _mapView.mapType=MKMapTypeStandard;
    
    
    self.label =[[UILabel alloc]init];
    self.label.frame= CGRectMake(0, self.mapView.frame.size.height, SceneWidth, 40);
    [self.view addSubview:self.label];
    self.label.backgroundColor =[UIColor greenColor];


}

#pragma mark - 地图控件代理方法
#pragma mark 更新用户位置，只要用户改变则调用此方法（包括第一次定位到用户位置）
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    NSLog(@"%@",userLocation);
    //设置地图显示范围(如果不进行区域设置会自动显示区域范围并指定当前用户位置为地图中心点)
    //    MKCoordinateSpan span=MKCoordinateSpanMake(0.01, 0.01);
    //    MKCoordinateRegion region=MKCoordinateRegionMake(userLocation.location.coordinate, span);
    //    [_mapView setRegion:region animated:true];
//    http://www.cnblogs.com/kenshincui/p/4125570.html
    self.label.text = [NSString stringWithFormat:@"%f:%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude];
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
