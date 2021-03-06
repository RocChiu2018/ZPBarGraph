//
//  ZPBarGraph.m
//  柱状图
//
//  Created by 赵鹏 on 2018/12/27.
//  Copyright © 2018 赵鹏. All rights reserved.
//

#import "ZPBarGraph.h"

@implementation ZPBarGraph

#pragma mark ————— 随机数组 —————
- (NSArray *)randomArray
{
    int total = 100;
    
    NSMutableArray *mulArray = [NSMutableArray array];
    
    int temp = 0;
    
    for (int i = 0; i < arc4random_uniform(10) + 1; i++)  //从0~9里面选随机数然后加1就变成了从1~10里面选随机数，这就避免了选到0的情况，因为选到0的话就没办法进入到for循环里面了。随机数的个数代表会把圆分成几个部分。
    {
        temp = arc4random_uniform(total) + 1;  //从0~99里面选随机数然后加1就变成了从1~100里面选随机数，这就避免了选到0的情况。temp代表饼状图中每个部分是多少。
        
        [mulArray addObject:[NSNumber numberWithInt:temp]];
        
        //如果随机选中的temp为100的话则说明整个饼状图就只有一个部分，这个temp占据了整个饼状图，所以需要直接退出for循环。
        if (temp == total)
        {
            break;
        }
        
        total -= temp;
    }
    
    /**
     假如上面的for循环循环了3次：
     1、第0次：在1~100里面选随机数，假如选到了30，剩下70进入下次循环；
     2、第1次：在1~71里面选随机数，假如选到了40，剩下30进入到下次循环；
     3、第2次：在1~31里面选随机数，假如选到了25，循环结束，剩下了的5要加入到可变数组中。
     */
    if (total)
    {
        [mulArray addObject:[NSNumber numberWithInt:total]];
    }
    
    return mulArray;
}

#pragma mark ————— 画柱状图 —————
- (void)drawRect:(CGRect)rect
{
    NSArray *array = [self randomArray];
    
    CGFloat x = 0;  //每个柱子的x坐标
    CGFloat y = 0;  //每个柱子的y坐标
    CGFloat w = 0;  //每个柱子的宽度
    CGFloat h = 0;  //每个柱子的高度
    
    for (int i = 0; i < array.count; i++)
    {
        w = rect.size.width / (2 * array.count - 1);
        x = 2 * w * i;
        h = [[array objectAtIndex:i] floatValue] / 100.0 * rect.size.height;
        y = rect.size.height - h;
        
        //用贝塞尔路径绘制柱状图
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, w, h)];
        
        //给柱状图设置颜色
        [[self colorRandom] set];
        
        /**
         必须是一个完整的封闭路径才能够填充了；
         如果不是封闭的路径，使用"fill"方法，默认会自动关闭路径，然后进行填充。
         */
        [path fill];
    }
}

#pragma mark ————— 随机色 —————
- (UIColor *)colorRandom
{
    CGFloat r = arc4random_uniform(256) / 255.0;
    CGFloat g = arc4random_uniform(256) / 255.0;
    CGFloat b = arc4random_uniform(256) / 255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

#pragma mark ————— 点击这个View的时候重绘柱状图 —————
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setNeedsDisplay];
}

@end
