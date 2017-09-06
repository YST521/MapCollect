//
//  PlistTools.h
//  MyPosition
//
//  Created by apple4 on 16/7/21.
//  Copyright © 2016年 apple4. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoatInfo : NSObject


@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *adress;
@property(nonatomic,strong)NSString *lat;
@property(nonatomic,strong)NSString *lon;

+ (BoatInfo*) dataForPlistFile:(NSString*)path;

@end
