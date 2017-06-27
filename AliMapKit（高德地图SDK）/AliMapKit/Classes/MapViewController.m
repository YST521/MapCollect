
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


// 获取物理屏幕的宽度
#define SceneWidth (([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height) ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height)
// 获取物理屏幕的高度
#define SceneHeight (([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height) ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width)

@interface MapViewController ()<MAMapViewDelegate,MKMapViewDelegate>
@property(nonatomic,strong)MKMapView *mapView;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    
    [self creatMapView];
    
}

-(void)creatMapView{
//http://blog.csdn.net/Hierarch_Lee/article/details/48752393
    self.mapView=[[MKMapView alloc]init];
    self.mapView.frame = CGRectMake(0, 0,SceneWidth , SCREEN_HEGHT*0.6);
    [self.view addSubview:self.mapView];
    self.mapView.delegate = self;


}

-(void)mapView:(MAMapView *)mapView didLongPressedAtCoordinate:(CLLocationCoordinate2D)coordinate{

    NSLog(@"-------%f--%f",coordinate.latitude,coordinate.longitude);

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
