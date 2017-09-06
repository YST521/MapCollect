//
//  GotoViewController.m
//  MyPosition
//
//  Created by youxin on 2017/8/14.
//  Copyright © 2017年 apple4. All rights reserved.
//

#import "GotoViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "YYAnnotation.h"

@interface GotoViewController ()<MKMapViewDelegate>

@property(strong,nonatomic)MKMapItem *mapItem;

//编码工具
@property(strong,nonatomic)CLGeocoder *geocoder;

@property(weak,nonatomic)MKMapView *mapView;

//用于发送请求给服务器
@property(strong,nonatomic)MKDirections *direct;


@end

@implementation GotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor =[UIColor whiteColor];
    [self setTitle:@"路径规划"];
    
    NSLog(@"%f--%f-Hhhhh--%f--%f",self.la,self.lon,self.cla,self.clon);
   // [self aa];
     [self mapView];
    [self drawLine];
}

- (MKMapView *)mapView
{
    if (!_mapView) {
        MKMapView *mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
        mapView.delegate = self;
        [self.view addSubview:mapView];
        //经纬度
        CLLocationCoordinate2D coordinate2D = {self.cla,self.clon};
        
        //比例尺
        
        MKCoordinateSpan span = {0.001,0.001};
        //设置范围
        
        //是否显示用户的当前位置
        //        mapView.showsUserLocation = YES;
        MKCoordinateRegion region = MKCoordinateRegionMake(coordinate2D, span);
        [mapView setRegion:region];
        
        _mapView = mapView;
        
    }
    return _mapView;
}



/**
 *  
 */

- (void)test
{
    CLLocationCoordinate2D first = {1,1};
    CLLocationCoordinate2D second = {2,2};
    
    CLLocationCoordinate2D coordinate[2] = {first,second
        
    };
    
    MKPolyline *line = [MKPolyline polylineWithCoordinates:coordinate count:2];
    [self.mapView addOverlay:line];
}


- (void)drawLine
{
    //起点和终点的经纬度
//    CLLocationCoordinate2D start = {39.9087607478,116.3975780499};
//    CLLocationCoordinate2D end = {40.9087607478,117.3975780499};
    CLLocationCoordinate2D start = {self.cla,self.clon};
   CLLocationCoordinate2D end = {22.984464,113.707787};

    
    //起点终点的详细信息
    MKPlacemark *startPlace = [[MKPlacemark alloc]initWithCoordinate:start addressDictionary:nil];
    MKPlacemark *endPlace = [[MKPlacemark alloc]initWithCoordinate:end addressDictionary:nil];
    //起点 终点的 节点
    MKMapItem *startItem = [[MKMapItem alloc]initWithPlacemark:startPlace];
    MKMapItem *endItem = [[MKMapItem alloc]initWithPlacemark:endPlace];
    //建立字典存储导航的相关参数
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
//    md[MKLaunchOptionsDirectionsModeKey] = MKLaunchOptionsDirectionsModeDriving;//驾车
     md[MKLaunchOptionsDirectionsModeKey] =  MKLaunchOptionsDirectionsModeWalking;//步行
    //md[MKLaunchOptionsDirectionsModeKey] = MKLaunchOptionsDirectionsModeTransit;//公交
    md[MKLaunchOptionsMapTypeKey] = [NSNumber numberWithInteger:MKMapTypeStandard];
      [MKMapItem openMapsWithItems:@[startItem,endItem] launchOptions:md];
 
    //路线请求
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    request.source = startItem;
    request.destination = endItem;
    
    //发送请求
    MKDirections *directions = [[MKDirections alloc]initWithRequest:request];
    
    __block NSInteger sumDistance = 0;
    
    //计算
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (!error) {
            //取出一条路线
            MKRoute *route = response.routes[0];
            
            //关键节点
            for(MKRouteStep *step in route.steps)
            {
                //大头针
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
                annotation.coordinate = step.polyline.coordinate;
                annotation.title = step.polyline.title;
                annotation.subtitle = step.polyline.subtitle;
                
                
                //添加大头针
                [self.mapView addAnnotation:annotation];
                
                //添加路线
                [self.mapView addOverlay:step.polyline];
                
                //距离
                sumDistance += step.distance;
            }
            
            NSLog(@"总距离 %ld",sumDistance);
            
        }
    }];
    
}

#pragma  mark - 添加覆盖物

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    //绘制线条
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *polylineRender = [[MKPolylineRenderer alloc]initWithPolyline:overlay];
        
        polylineRender.strokeColor = [UIColor redColor];
        
        polylineRender.lineWidth = 5;
        
        return polylineRender;
    }
    
    return nil;
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
    
        
        //end
        
        return annoView;
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
