//
//  HibiaoScrollWithImageView.m
//  HibiaoScrollWithImage
//
//  Created by 黄彪 on 16/5/7.
//  Copyright © 2016年 黄彪. All rights reserved.
//

#import "HibiaoScrollWithImageView.h"
#define ITAG 500

@interface HibiaoScrollWithImageView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *rootScrollView;
@property (nonatomic, strong) UIPageControl *rootPageControl;
@property (nonatomic, strong) UIButton *clickButton;
@end

@implementation HibiaoScrollWithImageView

- (instancetype)initWithFrame:(CGRect)frame direction:(Direction)direction dataSourceArray:(NSArray *)dataSourceArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.direction = direction;
        self.dataSourceArray = dataSourceArray;
        self.timeInterval = 3;
    }
    return self;
}


- (void)upDataScrollView {
    if (_direction == Horizontal) {
        [_rootScrollView setContentOffset:CGPointMake((_rootPageControl.currentPage + 2) * _rootScrollView.frame.size.width, 0) animated:YES];
    }
    if (_direction == Vertical) {
        [_rootScrollView setContentOffset:CGPointMake(0, (_rootPageControl.currentPage + 2) * _rootScrollView.frame.size.height) animated:YES];
    }
    
    [self performSelector:@selector(upDataScrollView) withObject:nil afterDelay:_timeInterval];
}

- (void)clickImageViewWithButton:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickedImageViewWithButton:)]) {
        [self.delegate clickedImageViewWithButton:button];
    }
    NSLog(@"点击图片执行的方法");
}

- (void)imageViewWithPageNum:(NSInteger)page {
    if (page < 0 || page > _dataSourceArray.count + 1) return;
    NSInteger tag = page % 3;
    UIImageView *imageView = (UIImageView *)[_rootScrollView viewWithTag:ITAG + tag];
    if (imageView) {
        if (_direction == Horizontal) {
            imageView.frame = CGRectMake(page * _rootScrollView.frame.size.width, 0, _rootScrollView.frame.size.width, _rootScrollView.frame.size.height);
        }
        if (_direction == Vertical) {
            imageView.frame = CGRectMake(0, page * _rootScrollView.frame.size.height, _rootScrollView.frame.size.width, _rootScrollView.frame.size.height);
        }
        
    }else {
        if (_direction == Horizontal) {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(page * _rootScrollView.frame.size.width, 0, _rootScrollView.frame.size.width, _rootScrollView.frame.size.height)];
        }
        if (_direction == Vertical) {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, page * _rootScrollView.frame.size.height, _rootScrollView.frame.size.width, _rootScrollView.frame.size.height)];
        }
        imageView.tag = ITAG + tag;
        [_rootScrollView addSubview:imageView];
    }
    if (page == 0)
    {
        page = _dataSourceArray.count - 1;
    }
    else if (page == _dataSourceArray.count + 1)
    {
        page = 0;
    }
    else
    {
        page = page - 1;
    }
    
    //这个地方对imageView进行设置图片
    imageView.backgroundColor = [[_dataSourceArray objectAtIndex:page] objectForKey:@"color"];
    
}


//- (Direction)direction {
//    if (direct) {
//        <#statements#>
//    }
//    return Horizontal;
//}

- (void)setDirection:(Direction)direction {
    _direction = direction;
    [self reloadData];
}

- (void)setDataSourceArray:(NSArray *)dataSourceArray {
    _dataSourceArray = dataSourceArray;
    [self reloadData];
}

- (void)reloadData {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    int i = _dataSourceArray.count != 0 && _dataSourceArray.count != 1 ? 2 : 0;
    if (_direction == Horizontal) {
        self.rootScrollView.contentSize = CGSizeMake((_dataSourceArray.count+i)*self.frame.size.width, self.frame.size.height);
    }else {
        self.rootScrollView.contentSize = CGSizeMake(self.frame.size.width, (_dataSourceArray.count+i)*self.frame.size.height);
    }
    if (_dataSourceArray.count > 0) {
        if (_direction == Horizontal) {
            _rootScrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
        }else {
            _rootScrollView.contentOffset = CGPointMake(0, self.frame.size.height);
        }
    }
    self.rootPageControl.numberOfPages = _dataSourceArray.count;
    _rootPageControl.currentPage = 0;
    if (_dataSourceArray.count <= 1 || _direction != Horizontal) {
        _rootPageControl.hidden = YES;
    }else {
        _rootPageControl.hidden = NO;
    }
    
    [_rootScrollView addSubview:self.clickButton];
    
    if (_dataSourceArray.count != 0) {
        [self imageViewWithPageNum:0];
        [self imageViewWithPageNum:1];
        [self imageViewWithPageNum:2];
    }
    
    if (_dataSourceArray.count > 1) {
        [self performSelector:@selector(upDataScrollView) withObject:nil afterDelay:_timeInterval];
    }
}

- (UIScrollView *)rootScrollView {
    
    if (!_rootScrollView) {
        self.rootScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _rootScrollView.backgroundColor = [UIColor clearColor];
        _rootScrollView.delegate = self;
        _rootScrollView.showsVerticalScrollIndicator = NO;
        _rootScrollView.showsHorizontalScrollIndicator = NO;
        _rootScrollView.pagingEnabled = YES;
        _rootScrollView.canCancelContentTouches = NO;
        [self addSubview:_rootScrollView];
    }
    
    return _rootScrollView;
}

- (UIPageControl *)rootPageControl {
    if (!_rootPageControl) {
        self.rootPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20)];
        _rootPageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        _rootPageControl.pageIndicatorTintColor= [UIColor greenColor];
        [self addSubview:_rootPageControl];
    }
    return _rootPageControl;
}

- (UIButton *)clickButton {
    if (!_clickButton) {
        self.clickButton = [[UIButton alloc] initWithFrame:CGRectMake(_rootScrollView.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        _clickButton.backgroundColor = [UIColor clearColor];
        
        [_clickButton addTarget:self action:@selector(clickImageViewWithButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickButton;
}


#pragma mark -UIScrollerViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_dataSourceArray.count > 1) {
        NSInteger page=0; float yu=0;
        if (_direction == Horizontal) {
            page = scrollView.contentOffset.x / scrollView.frame.size.width;
            yu = fmod(scrollView.contentOffset.x, scrollView.frame.size.width);
            _clickButton.frame = CGRectMake(scrollView.contentOffset.x, 0, _clickButton.frame.size.width, _clickButton.frame.size.height);
        }
        
        if (_direction == Vertical) {
            page = scrollView.contentOffset.y / scrollView.frame.size.height;
            yu = fmod(scrollView.contentOffset.y, scrollView.frame.size.height);
            _clickButton.frame = CGRectMake(0, scrollView.contentOffset.y, _clickButton.frame.size.width, _clickButton.frame.size.height);
        }
        _clickButton.tag = page - 1;
        _rootPageControl.currentPage = page - 1;
        
        if (page == 0 && yu <= 0)
        {
            if (_direction == Horizontal) {
                [_rootScrollView setContentOffset:CGPointMake(_dataSourceArray.count * _rootScrollView.frame.size.width, 0)];
                _clickButton.frame = CGRectMake(_dataSourceArray.count * _rootScrollView.frame.size.width, 0, _clickButton.frame.size.width, _clickButton.frame.size.height);
            }
            if (_direction == Vertical) {
                [_rootScrollView setContentOffset:CGPointMake(0, _dataSourceArray.count * _rootScrollView.frame.size.height)];
                _clickButton.frame = CGRectMake(0, _dataSourceArray.count * _rootScrollView.frame.size.height, _clickButton.frame.size.width, _clickButton.frame.size.height);
            }

            _rootPageControl.currentPage = _dataSourceArray.count - 1;
            _clickButton.tag = page - 1;
            page = _dataSourceArray.count;
        }
        else if (page == _dataSourceArray.count + 1)
        {
            
            if (_direction == Horizontal) {
                [_rootScrollView setContentOffset:CGPointMake(_rootScrollView.frame.size.width, 0)];
                _clickButton.frame = CGRectMake(_rootScrollView.frame.size.width, 0, _clickButton.frame.size.width, _clickButton.frame.size.height);
            }
            if (_direction == Vertical) {
                [_rootScrollView setContentOffset:CGPointMake(0,_rootScrollView.frame.size.height)];
                _clickButton.frame = CGRectMake(0, _rootScrollView.frame.size.height, _clickButton.frame.size.width, _clickButton.frame.size.height);
            }
            
            _rootPageControl.currentPage = 0;
            _clickButton.tag = 0;
            page = 1;
        }
        
        if (_dataSourceArray.count != 0)
        {
            [self imageViewWithPageNum:page - 1];
            [self imageViewWithPageNum:page];
            [self imageViewWithPageNum:page + 1];
        }
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(upDataScrollView) withObject:nil afterDelay:_timeInterval];
}




@end
