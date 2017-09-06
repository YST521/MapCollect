//
//  ZSPointAnnotation.h
//  
//
//  Created by youxin on 2017/8/15.
//
//

#import <MAMapKit/MAMapKit.h>


typedef NS_ENUM(NSInteger,PinType) {
    /**
     *  超市
     */
    SUPER_MARKET = 0,
    /**
     *  火场
     */
    CREMATORY,
    /**
     *  景点
     */
    INTEREST,
};


@interface ZSPointAnnotation : MAPointAnnotation
@property (nonatomic,copy)NSString *imageString;

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,retain) NSNumber *type;

- (instancetype)initWithAnnotationModelWithDict:(NSDictionary *)dict;

//链接：http://www.jianshu.com/p/0ed358092f05

@end
