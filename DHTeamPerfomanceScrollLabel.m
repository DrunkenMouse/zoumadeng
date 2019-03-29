//
//  DHTeamPerfomanceScrollLabel.m
//  Project_Model
//
//  Created by 王奥东 on 2018/1/25.
//  Copyright © 2018年 北京搭伙科技. All rights reserved.
//

#import "DHTeamPerfomanceScrollLabel.h"
@interface DHTeamPerfomanceScrollLabel()

@end

@implementation DHTeamPerfomanceScrollLabel {
    
    UIScrollView *_labelScroll;
    NSTimer *_timer;
    NSMutableArray  <UILabel *>* _scrollLabelArr;
    CGFloat _labelWidth;
}

-(void)initCustomUI {
    
    _labelScroll = [[UIScrollView alloc] init];

    _labelScroll.userInteractionEnabled = NO;
    [self addSubview:_labelScroll];
    [_labelScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(repeatsLabel) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    _scrollLabelArr = [NSMutableArray array];
    
    _labelWidth = SCREEN_WIDTH - DHAdaptive(160);
}

-(void)repeatsLabel {
    
    if (_labelScroll.contentOffset.x + _labelWidth < _labelScroll.contentSize.width) {
        
        [_labelScroll setContentOffset:CGPointMake(_labelScroll.contentOffset.x + _labelWidth , 0) animated:YES];
        
    }else {
        [_labelScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

-(void)setTextArr:(NSMutableArray<NSString *> *)textArr {
    
    _textArr = textArr;
    [_labelScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    
    //释放或创建对象会消耗内存，所以能减少几次是几次,labelScroll高度为DHAdaptive(80)
    
    //Label不够就添加
    if (_scrollLabelArr.count <= _textArr.count) {

        for (int i = 0; i < _scrollLabelArr.count; i++) {

            _scrollLabelArr[i].text = textArr[i];
        }
        
        NSInteger index = textArr.count - _scrollLabelArr.count;
        
        UILabel *lastLabel;
        NSInteger scrollLabelCount = _scrollLabelArr.count;//保存Label时，scrollLabelArr数组会变长
        for (NSInteger i = 0; i < index; i++) {

            UILabel * tempLabel =[[UILabel alloc] init];
            
            [_labelScroll addSubview:tempLabel];//展示
            
            tempLabel.frame = CGRectMake(i * _labelWidth, DHAdaptive(50)/2, _labelWidth, DHAdaptive(30));
            
            tempLabel.text = textArr[scrollLabelCount + i];
            tempLabel.textAlignment = NSTextAlignmentCenter;
            tempLabel.backgroundColor = DHWhiteColor;
            tempLabel.textColor = DHTextHexColor_Dark_222222;
            tempLabel.font = [UIFont systemFontOfSize:14];
            tempLabel.tag = i+1;

            [_scrollLabelArr addObject:tempLabel];//保存
            lastLabel = tempLabel;
        }


    }else {//Label太多就移除
        for (int i = 0; i < _textArr.count; i++) {

            _scrollLabelArr[i].text = textArr[i];
        }

         NSInteger index = _scrollLabelArr.count - textArr.count;

        for (NSInteger i = 1; i <= index; i++) {
            [_scrollLabelArr[_scrollLabelArr.count - i] removeFromSuperview];
        }
    }

    _labelScroll.contentSize = CGSizeMake(_labelWidth* (textArr.count - 1), 0);
    
}


@end
