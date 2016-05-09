//
//  HibiaoScrollWithImageView.h
//  HibiaoScrollWithImage
//
//  Created by 黄彪 on 16/5/7.
//  Copyright © 2016年 黄彪. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    Horizontal = 0,
    Vertical = 1,
    
} Direction;

@protocol HibiaoScrollWithImageViewDelegate <NSObject>

- (void)clickedImageViewWithButton:(UIButton *)button;

@end

@interface HibiaoScrollWithImageView : UIView
@property (nonatomic, assign) Direction direction;
@property (nonatomic, strong) NSArray *dataSourceArray;
@property (nonatomic, assign) NSInteger timeInterval;
@property (nonatomic, assign) id<HibiaoScrollWithImageViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame direction:(Direction)direction dataSourceArray:(NSArray *)dataSourceArray;
@end
