//
//  MyPositionViewController.h
//  MyPosition
//
//  Created by apple4 on 16/7/20.
//  Copyright © 2016年 apple4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MyPositionViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;


@end
