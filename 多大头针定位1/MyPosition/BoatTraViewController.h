//
//  BoatTraViewController.h
//  MyPosition
//
//  Created by apple4 on 16/7/21.
//  Copyright © 2016年 apple4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface BoatTraViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>


@property (strong, nonatomic) IBOutlet MKMapView *boatTraMapView;
@property (strong, nonatomic) MKPolyline* routeLine;
@end
