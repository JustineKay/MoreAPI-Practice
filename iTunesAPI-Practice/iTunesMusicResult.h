//
//  iTunesMusicResult.h
//  iTunesAPI-Practice
//
//  Created by Justine Gartner on 9/20/15.
//  Copyright © 2015 Justine Gartner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface iTunesMusicResult : NSObject

@property (nonatomic) NSString *album;
@property (nonatomic) NSString *artist;
@property (nonatomic) UIImage *thumbnailImage;

@end
