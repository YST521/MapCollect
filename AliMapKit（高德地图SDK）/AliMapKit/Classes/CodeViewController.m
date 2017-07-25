//
//  CodeViewController.m
//  AliMapKit
//
//  Created by youxin on 2017/6/21.
//  Copyright © 2017年 广州市东德网络科技有限公司. All rights reserved.
//

#import "CodeViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface CodeViewController ()<AMapSearchDelegate>

{
    AMapSearchAPI *_search;
}

 @property(nonatomic,strong)CLGeocoder *geocoder;
 #pragma mark-地理编码
@property(nonatomic,strong)UILabel *label;


@end

@implementation CodeViewController
-(CLGeocoder *)geocoder
 {
       if (_geocoder==nil) {
               _geocoder=[[CLGeocoder alloc]init];
           }
        return _geocoder;
    }





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    
    self.title = @"编码反编码";
    self.view.backgroundColor =[UIColor greenColor];
    
//原生编码翻遍吗    http://www.cnblogs.com/wendingding/p/3901527.html
    [self getAdress];
    [self getAdressCode];
    
//    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
//      regeo.location = [AMapGeoPointlocationWithLatitude:coordinate.latitudelongitude:coordinate.longitude];
//    regeo.location = [AMapGeoPointlocationWithLatitude:@"" longitude:@""];
//    regeo.requireExtension =YES;
    
    //初始化检索对象
//    _search = [[AMapSearchAPI alloc] initWithSearchKey:@"您的key"Delegate:self];
    
    //构造AMapReGeocodeSearchRequest对象，location为必选项，radius为可选项
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
//    regeoRequest.searchType = AMapSearchType_ReGeocode;
//    regeoRequest.location = [AMapGeoPoint locationWithLatitude:39.990459     longtitude:116.481476];
        regeoRequest.location = [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.481476];
    
    regeoRequest.radius = 10000;
    regeoRequest.requireExtension = YES;
    
    
    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeoRequest];
    
}

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
        NSLog(@"ReGeo: %@", result);
    }
}

-(void)getAdress{

    //1.获得输入的地址
        NSString *address=@"东莞南城汽车站";
        if (address.length==0) return;
   
       //2.开始地理编码
        //说明：调用下面的方法开始编码，不管编码是成功还是失败都会调用block中的方法
         [self.geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
                //如果有错误信息，或者是数组中获取的地名元素数量为0，那么说明没有找到
                if (error || placemarks.count==0) {
//                       self.detailAddressLabel.text=@"你输入的地址没找到，可能在月球上";
                 }else   //  编码成功，找到了具体的位置信息
                       {
                             //打印查看找到的所有的位置信息
                                  /*
                                        61                     name:名称
                                        62                     locality:城市
                                        63                     country:国家
                                        64                     postalCode:邮政编码
                                        65                  */
                               for (CLPlacemark *placemark in placemarks) {
                                       NSLog(@"name=%@ locality=%@ country=%@ postalCode=%@",placemark.name,placemark.locality,placemark.country,placemark.postalCode);
                                   }
                   
                               //取出获取的地理信息数组中的第一个显示在界面上
                               CLPlacemark *firstPlacemark=[placemarks firstObject];
                                //详细地址名称
                              NSLog(@"mmm--%@--%@",firstPlacemark,placemarks);
//                              self.detailAddressLabel.text=firstPlacemark.name;
                                //纬度
                                CLLocationDegrees latitude=firstPlacemark.location.coordinate.latitude;
                                //经度
                               CLLocationDegrees longitude=firstPlacemark.location.coordinate.longitude;
//                                self.latitudeLabel.text=[NSString stringWithFormat:@"%.2f",latitude];
//                               self.longitudeLabel.text=[NSString stringWithFormat:@"%.2f",longitude];
                           
                           NSLog(@"aaassss-----%f--%f",latitude,longitude);
                           
                           
                            }
          }];
    
}




//经纬度-> 地名
-(void)getAdressCode{

    //1.获得输入的经纬度
       NSString *longtitudeText=@"113.718085";
        NSString *latitudeText=@"22.984505";
        if (longtitudeText.length==0||latitudeText.length==0) return;
    
         CLLocationDegrees latitude=[latitudeText doubleValue];
         CLLocationDegrees longitude=[longtitudeText doubleValue];
    
         CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
         //2.反地理编码
         [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
                if (error||placemarks.count==0) {
//                         self.reverdeDetailAddressLabel.text=@"你输入的地址没找到，可能在月球上";
                  }else//编码成功
                        {
                                //显示最前面的地标信息
                                CLPlacemark *firstPlacemark=[placemarks firstObject];
                            
                            NSLog(@"kkkkk--%@",firstPlacemark);
//                                self.reverdeDetailAddressLabel.text=firstPlacemark.name;
                               //经纬度
                                CLLocationDegrees latitude=firstPlacemark.location.coordinate.latitude;
                                 CLLocationDegrees longitude=firstPlacemark.location.coordinate.longitude;
//                                 self.latitudeField.text=[NSString stringWithFormat:@"%.2f",latitude];
//                                self.longitudeField.text=[NSString stringWithFormat:@"%.2f",longitude];
                            NSLog(@"-------%f--%f",latitude,longitude);
                            
                            
                             }
             }];
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
