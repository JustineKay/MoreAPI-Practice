//
//  iTunesMusicResult.m
//  iTunesAPI-Practice
//
//  Created by Justine Gartner on 9/20/15.
//  Copyright © 2015 Justine Gartner. All rights reserved.
//

#import "iTunesMusicResult.h"
#import <UIKit/UIKit.h>

@implementation iTunesMusicResult

-(UIImage *)createImageFromString:(NSString *)urlString{
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSData  *pictureData = [NSData dataWithContentsOfURL:url];
    
    UIImage *picture = [UIImage imageWithData:pictureData];
    
    return picture;
}

@end
