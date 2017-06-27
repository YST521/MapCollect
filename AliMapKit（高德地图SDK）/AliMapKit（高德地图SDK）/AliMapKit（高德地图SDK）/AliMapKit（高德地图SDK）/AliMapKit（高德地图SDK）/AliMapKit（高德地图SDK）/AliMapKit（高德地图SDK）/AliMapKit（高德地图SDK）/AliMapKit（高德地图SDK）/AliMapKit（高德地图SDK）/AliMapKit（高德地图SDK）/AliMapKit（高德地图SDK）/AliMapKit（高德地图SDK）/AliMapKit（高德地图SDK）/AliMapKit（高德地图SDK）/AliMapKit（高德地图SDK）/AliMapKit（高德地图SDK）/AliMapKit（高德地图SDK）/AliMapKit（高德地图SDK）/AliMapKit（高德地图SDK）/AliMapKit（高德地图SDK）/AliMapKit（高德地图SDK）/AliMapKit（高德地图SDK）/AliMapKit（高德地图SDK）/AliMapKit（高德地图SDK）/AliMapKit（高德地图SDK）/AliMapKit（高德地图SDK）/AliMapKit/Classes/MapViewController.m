
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "GradientPolylineOverlay.h"
#import "GradientPolylineRenderer.h"

// 获取物理屏幕的宽度
#define SceneWidth (([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height) ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height)
// 获取物理屏幕的高度
#define SceneHeight (([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height) ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width)

@interface MapViewController ()<MKMapViewDelegate>{
    CLLocationManager *_locationManager;
    
}

@property(nonatomic,strong)MKMapView *mapView;
@property(nonatomic,strong)UILabel*  label;
@property(nonatomic,strong)GradientPolylineOverlay *polyline;
@property(nonatomic,strong)NSMutableArray * speedArr;
@end

@implementation MapViewController
-(NSMutableArray *)speedArr{

    if (!_speedArr) {
        _speedArr =[NSMutableArray array];
    }
    return _speedArr;
}

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
    
    
//    http://www.jianshu.com/p/920efc9269f4
 //地图轨迹   http://www.jianshu.com/p/2d71cc8dd035
    NSMutableArray *smoothTrackArray = [self smoothTrack];
    double count = smoothTrackArray.count;
    CLLocationCoordinate2D *points;
    float *velocity;
    points = malloc(sizeof(CLLocationCoordinate2D)*count);
    velocity = malloc(sizeof(float)*count);
    
    for(int i=0;i<count;i++){
        NSDictionary *dic = [smoothTrackArray objectAtIndex:i];
        CLLocationDegrees latitude  = [dic[@"latitude"] doubleValue];
        CLLocationDegrees longitude = [dic[@"longitude"] doubleValue];
//        CLLocationDegrees latitude  = userLocation.coordinate.latitude;
//        CLLocationDegrees longitude = userLocation.coordinate.longitude;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        velocity[i] = [dic[@"speed"] doubleValue];
        points[i] = coordinate;
    }
    
    self.polyline = [[GradientPolylineOverlay alloc] initWithPoints:points velocity:velocity count:count];
    [self.mapView addOverlay:self.polyline level:1];


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
//    CLLocation *cll = [[CLLocation alloc]initWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
//     CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    

//    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);

//    CGFloat a = 1.0;
//    NSString *flo = @"1";
//     self.polyline = [[GradientPolylineOverlay alloc] initWithPoints:&coordinate velocity:nil count:1];
//    [self.mapView addOverlay:self.polyline];
    
    //    self.polyline = [[GradientPolylineOverlay alloc] initWithCenterCoordinate:userLocation.coordinate];

    
}
-(NSMutableArray*)smoothTrack{
    
    NSMutableArray*aa =[NSMutableArray array];
    
    
    return aa;
}

- (void)smoothTrack:(CLLocation *)location{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    CLLocationCoordinate2D coordinate = [JZLocationConverter wgs84ToGcj02:location.coordinate];
       CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude) ;
    [dic setObject:[NSString stringWithFormat:@"%.8f",coordinate.latitude] forKey:@"latitude"];
    [dic setObject:[NSString stringWithFormat:@"%.8f",coordinate.longitude] forKey:@"longitude"];
    [dic setObject:[NSString stringWithFormat:@"%g",location.altitude] forKey:@"altitude"];
    [dic setObject:[NSString stringWithFormat:@"%g",location.horizontalAccuracy] forKey:@"horizontalAccuracy"];
    [dic setObject:[NSString stringWithFormat:@"%g",location.verticalAccuracy] forKey:@"verticalAccuracy"];
    [dic setObject:[NSString stringWithFormat:@"%g",location.course] forKey:@"course"];
    
    if (self.speedArr.count<10) {
        [self.speedArr addObject:location];
        [dic setObject:[NSString stringWithFormat:@"%.2f",location.speed] forKey:@"speed"];
    }else{
        [self.speedArr removeObjectAtIndex:0];
        [self.speedArr addObject:location];
        double speed = 0.0;
        for (CLLocation *loc in self.speedArr) {
            speed += loc.speed;
        }
        [dic setObject:[NSString stringWithFormat:@"%g",speed/10.0] forKey:@"speed"];
    }
//    [self.dataArr addObject:dic];
}
#pragma mark -
#pragma mark - MKMap Delegate
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay{
    if([overlay isKindOfClass:[GradientPolylineOverlay class]]){
        //轨迹
        GradientPolylineRenderer *polylineRenderer = [[GradientPolylineRenderer alloc] initWithOverlay:overlay];
        polylineRenderer.lineWidth = 8.f;
        return polylineRenderer;
    }
    return nil;
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
