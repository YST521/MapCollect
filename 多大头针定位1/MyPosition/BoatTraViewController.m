//
//  BoatTraViewController.m
//  MyPosition
//
//  Created by apple4 on 16/7/21.
//  Copyright © 2016年 apple4. All rights reserved.
//

#import "BoatTraViewController.h"

@interface BoatTraViewController ()

@end

@implementation BoatTraViewController
{
    NSMutableDictionary* data;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"船舶轨迹";
    //地图不能转动
    self.boatTraMapView.rotateEnabled = NO;
    
    self.boatTraMapView.delegate = self;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"trajectory" ofType:@"plist"];
    data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    

    
    
    CLLocationCoordinate2D coordinate = {40.0427710000,116.3033660000};
    
    
        //设置地图显示的范围
    MKCoordinateSpan span;
    
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;
    
    //创建 MKCoordinateRegion 对象，该对象代表地图的显示中心和显示范围
    MKCoordinateRegion region = {coordinate,span};
    [self.boatTraMapView setRegion:region animated:YES];
    
    //[self drawLine];
    
    [self drawLineWithLocationArray:data];
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

/*
 //地图画线

- (void)drawLine{
    NSMutableDictionary *positionDic;
    NSString* key;
    NSString* lat;
    NSString* lon;
    for (int i = 1; i < data.count; i++) {
        CLLocationCoordinate2D points[2];
        
        
        key = [NSString stringWithFormat:@"item%d",i];
        lat = [positionDic valueForKey:@"lat"] ;
        lon = [positionDic valueForKey:@"lon"];
        
        points[0] = CLLocationCoordinate2DMake([lat floatValue], [lon floatValue]);
        positionDic = [data valueForKey:key];
        NSLog(@"========%@",positionDic);
        key = [NSString stringWithFormat:@"item%d",i+1];
        lat = [positionDic valueForKey:@"lat"] ;
        lon = [positionDic valueForKey:@"lon"];
        
        
        points[1] = CLLocationCoordinate2DMake([lat floatValue], [lon floatValue]);
        MKPolyline *polyline = [MKPolyline polylineWithCoordinates:points count:2];
         [self.boatTraMapView addOverlay: polyline];
    }
 
    
//    [self.mapView addOverlay:polyline];
//    
//    CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake(31.484137685, 120.371875243);
//    CLLocationCoordinate2D coord2 = CLLocationCoordinate2DMake(31.484044745, 120.371879653);
//    MKMapPoint* pointArr =  BMKMapPoint[_locationPoint.count]
//    MKMapPoint* points = [MKMapPointEqualToPoint(points, <#MKMapPoint point2#>)];
//    points[0] = MKMapPointForCoordinate(coord1);
//    points[1] = MKMapPointForCoordinate(coord2);
//    MKPolyline *line = [MKPolyline polylineWithPoints:points count:2];
   

}
*/
//绘制坐标轨迹
- (void)drawLineWithLocationArray:(NSMutableDictionary *)locationArray
{
    MKMapPoint* pointArray = malloc(sizeof(CLLocationCoordinate2D) * locationArray.count);
    
    for(int idx = 0; idx < locationArray.count; idx++)
    {
        NSString* key = [NSString stringWithFormat:@"item%d",idx];
        
        NSString* lat = [[locationArray valueForKey:key]valueForKey:@"lat"];
        NSString* lon = [[locationArray valueForKey:key]valueForKey:@"lon"];

        //CLLocation *location = [locationArray objectAtIndex:idx];
        
        CLLocationDegrees latitude  = [lat floatValue];
        
        CLLocationDegrees longitude = [lon floatValue];
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        //添加描点 start
        MKPointAnnotation* annotation = [[MKPointAnnotation alloc]init];
        annotation.title = [[locationArray valueForKey:key]valueForKey:@"name"];
        annotation.subtitle = [[locationArray valueForKey:key]valueForKey:@"time"];
        
        annotation.coordinate = coordinate;
        
        [self.boatTraMapView addAnnotation:annotation];
        
        //end
        
        
        MKMapPoint point = MKMapPointForCoordinate(coordinate);
        
        pointArray[idx] = point;
    }
    
    if (_routeLine) {
        [self.boatTraMapView removeOverlay:_routeLine];
    }
    
    _routeLine = [MKPolyline polylineWithPoints:pointArray count:locationArray.count];
    
    if (nil != _routeLine) {
        [self.boatTraMapView addOverlay:_routeLine];
    }
    
    free(pointArray);
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{

    MKPolylineRenderer* renderer = [[MKPolylineRenderer alloc]initWithPolyline:overlay];
    
    renderer.strokeColor = [UIColor redColor];
    renderer.lineWidth = 3;
    
    return renderer;

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{

    static NSString* annoId = @"anno";
    MKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:annoId];
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:annoId];
    }
    
    annotationView.image = [UIImage imageNamed:@"cluster"];
    
    annotationView.canShowCallout = YES;
    
    return  annotationView;
    
}
@end
