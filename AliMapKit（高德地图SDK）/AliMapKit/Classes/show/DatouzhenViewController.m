//
//  DatouzhenViewController.m
//  AliMapKit
//
//  Created by youxin on 2017/8/15.
//  Copyright © 2017年 优信无限. All rights reserved.
//

#import "DatouzhenViewController.h"
#import "ZSPointAnnotation.h"
#import "CustomAnnotationView.h"

@interface DatouzhenViewController ()<MAMapViewDelegate>{
    CLLocationManager *_locationManager;
    MAMapView *_mapView;
}

@property (nonatomic,retain) NSMutableArray *locationArra;


@property (nonatomic, strong)MAMapView *mapView;
@property(nonatomic,strong)NSMutableArray *annotations;
@end

@implementation DatouzhenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
   // [self creatMAP];
    //    定位授权
    
    _locationManager = [[CLLocationManager alloc]init];
    [_locationManager requestWhenInUseAuthorization];
    //    地图视图
    _mapView = [[MAMapView alloc]initWithFrame:self.view.frame];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    
    self.annotations = [NSMutableArray array];
        CLLocationCoordinate2D coordinates[10] = {
            {39.915168,116.4038759},
            {38.915168,116.403875},
            {37.34241706,113.19973639},
            {36.34111706,113.20093639},
            {35.34111706,113.20093639}};
        for (int i =0; i <5; ++i)
        {
            ZSPointAnnotation *a1 = [[ZSPointAnnotation alloc]init];
            a1.coordinate = coordinates[i];
            a1.title      = [NSString stringWithFormat:@"标题: %d", i];
            a1.imageString      = [NSString stringWithFormat:@"图%d.jpg",i];
            [self.annotations addObject:a1];
            [self.mapView addAnnotation:a1];
            
            MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
            
            pointAnnotation.coordinate =  a1.coordinate ;
            //设置地图的定位中心点坐标
            self.mapView.centerCoordinate = a1.coordinate;
            //将点添加到地图上，即所谓的大头针
            [self.mapView addAnnotation:pointAnnotation];
        }

    //创建坐标
    
//    CLLocationCoordinate2D coor ;
//    coor.latitude  = 39.33232132323;
//    coor.longitude = 116.23423423423;
//    
//    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
//    
//    pointAnnotation.coordinate = coor;
//    //设置地图的定位中心点坐标
//    self.mapView.centerCoordinate = coor;
//    //将点添加到地图上，即所谓的大头针
//    [self.mapView addAnnotation:pointAnnotation];

}

- (void)loadData{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"PinData" ofType:@"plist"];
    NSArray *tempArray = [NSArray arrayWithContentsOfFile:filePath];
    
    //    把plist数据转换成大头针model
    for (NSDictionary *dict in tempArray) {
ZSPointAnnotation*myAnnotationModel = [[ZSPointAnnotation alloc]initWithAnnotationModelWithDict:dict];
        
        [self.locationArra addObject:myAnnotationModel];
    }
    
    //    核心代码
    [_mapView addAnnotations:self.locationArra];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    
    
    //大头针标注
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {//判断是否是自己的定位气泡，如果是自己的定位气泡，不做任何设置，显示为蓝点，如果不是自己的定位气泡，比如大头针就会进入
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAAnnotationView*annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.frame = CGRectMake(0, 0, 100, 100);
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        //annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;           //设置标注可以拖动，默认为NO
        //        annotationView.pinColor = MAPinAnnotationColorPurple;
        
        //设置大头针显示的图片
        annotationView.image = [UIImage imageNamed:@"acc"];
        //点击大头针显示的左边的视图
        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"acc"]];
        annotationView.leftCalloutAccessoryView = imageV;
        //点击大头针显示的右边视图
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
        rightButton.backgroundColor = [UIColor grayColor];
        [rightButton setTitle:@"导航" forState:UIControlStateNormal];
        annotationView.rightCalloutAccessoryView = rightButton;
        
        //        annotationView.image = [UIImage imageNamed:@"redPin"];
        return annotationView;
    }
    return nil;
    
    
    
}



#pragma mark ------ delegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation{
    userLocation.title  =@"你好";
    
    _mapView.centerCoordinate = userLocation.coordinate;
    
    [_mapView setRegion:MACoordinateRegionMake(userLocation.coordinate, MACoordinateSpanMake(0.3, 0.3)) animated:YES];
    //    如果在ViewDidLoad中调用  添加大头针的话会没有掉落效果  定位结束后再添加大头针才会有掉落效果
    [self loadData];
    
}

//- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
//    
//    /*
//     
//     * 大头针分两种
//     
//     * 1. MKPinAnnotationView：他是系统自带的大头针，继承于MKAnnotationView，形状跟棒棒糖类似，可以设置糖的颜色，和显示的时候是否有动画效果
//     
//     * 2. MKAnnotationView：可以用指定的图片作为大头针的样式，但显示的时候没有动画效果，如果没有给图片的话会什么都不显示
//     
//     * 3. mapview有个代理方法，当大头针显示在试图上时会调用，可以实现这个方法来自定义大头针的动画效果，我下面写有可以参考一下
//     
//     * 4. 在这里我为了自定义大头针的样式，使用的是MKAnnotationView
//     
//     */
//    
//    
//    //    判断是不是用户的大头针数据模型
//    if ([annotation isKindOfClass:[MAUserLocation class]]) {
//        MAAnnotationView *annotationView = [[ MAAnnotationView alloc]init];
//        annotationView.image = [UIImage imageNamed:@"acc"];
//        
//        //        是否允许显示插入视图*********
//        annotationView.canShowCallout = YES;
//        
//        return annotationView;
//    }
//    
//   CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"otherAnnotationView"];
//    if (annotationView == nil) {
//        annotationView = [[CustomAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"otherAnnotationView"];
//    }
//    ZSPointAnnotation *myAnnotation = annotation;
//    switch ([myAnnotation.type intValue]) {
//        case SUPER_MARKET:
//            annotationView.image = [UIImage imageNamed:@"super"];
//            annotationView.label.text = @"超市";
//            break;
//        case CREMATORY:
//            annotationView.image = [UIImage imageNamed:@"chang"];
//            annotationView.label.text = @"火场";
//            break;
//        case INTEREST:
//            annotationView.image = [UIImage imageNamed:@"jingqu"];
//            annotationView.label.text = @"风景区";
//            break;
//            
//        default:
//            break;
//    }
//    
//    return annotationView;
//}
//

//大头针显示在视图上时调用，在这里给大头针设置显示动画
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray<MAAnnotationView *> *)views{
    //    获得mapView的Frame
    CGRect visibleRect = [mapView annotationVisibleRect];
    for (MAAnnotationView *view in views) {
        
        CGRect endFrame = view.frame;
        CGRect startFrame = endFrame;
        startFrame.origin.y = visibleRect.origin.y - startFrame.size.height;
        view.frame = startFrame;
        [UIView beginAnimations:@"drop" context:NULL];
        [UIView setAnimationDuration:1];
        view.frame = endFrame;
        [UIView commitAnimations];
    }
}

#pragma mark lazy load

- (NSMutableArray *)locationArray{
    
    if (_locationArra == nil) {
        
        _locationArra = [NSMutableArray new];
        
    }
    return _locationArra;
}



//-(void)creatMAP{
//
//
//    //初始化地图
//    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
//    _mapView.centerCoordinate = CLLocationCoordinate2DMake(39.915168,116.403875);
//    _mapView.delegate = self;
//    [_mapView setZoomLevel:14.f animated:YES];
//    
//    //把地图添加至view
//    [self.view addSubview:_mapView];
//    
//    
//    self.annotations = [NSMutableArray array];
//    CLLocationCoordinate2D coordinates[10] = {
//        {39.915168,116.4038759},
//        {38.915168,116.403875},
//        {37.34241706,113.19973639},
//        {36.34111706,113.20093639}};
//    for (int i =0; i <4; ++i)
//    {
//        ZSPointAnnotation *a1 = [[ZSPointAnnotation alloc]init];
//        a1.coordinate = coordinates[i];
//        a1.title      = [NSString stringWithFormat:@"标题: %d", i];
//        a1.imageString      = [NSString stringWithFormat:@"图%d.jpg",i];
//        [self.annotations addObject:a1];
//        [self.mapView addAnnotation:a1];
//    }
//    
//    
//
//}
//
//- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
//{
//    
//    //customAnnotationView参考高德demo中  自定义样式标注
//    static NSString *customReuseIndetifier =@"customReuseIndetifier";
//    CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
//    
//    if (annotationView ==nil)
//    {
//        annotationView = [[CustomAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
//        
//        annotationView.canShowCallout =NO;
//        annotationView.draggable =YES;
//        annotationView.calloutOffset =CGPointMake(0, -5);
//    }
//    
//    //这里我们遍历数组 拿到point 与地图上annotation上title比较  相同的话  设置图片为模拟数据的image
//    for (ZSPointAnnotation *point in self.annotations) {
//        if ([[annotation title]isEqualToString:point.title]) {
//            annotationView.portraitImageView.image = [UIImage imageNamed:point.imageString];
//            annotationView.portraitImageView.layer.cornerRadius =25;
//            annotationView.portraitImageView.layer.masksToBounds =YES;
//        }
//    }
//    
//    return annotationView;
//    
//}  
//
//
//
//- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
//    
//    NSArray * array = [NSArray arrayWithArray:_mapView.annotations];
//    //这里遍历mapView上的annotations  比较经度（纬度）title 都可以  这样就可以啦
//    for (ZSPointAnnotation *point in array) {
//        if (view.annotation.coordinate.latitude == point.coordinate.latitude){
//            NSLog(@"点了我 %@",point.title);
//            NSLog(@"图片是我  %@",point.imageString);
//        }else{
//            NSLog(@"没点我 %@",point.title);
//        }
//    }
//    
//}  


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
