//
//  AlgorithmManager.m
//  ObjcDemo
//
//  Created by Dongdong on 17/2/24.
//  Copyright © 2017年 com. All rights reserved.
//

#import "AlgorithmManager.h"

@implementation AlgorithmManager
/*
+ (void)bubbleSortWithArray:(NSMutableArray *)array{
    
    for (int i = 0; i < array.count; i++) {
        for (int j = 0; j < array.count - i - 1; j++) {
            if (array[j] < array[j+1]) {
                int temp = [array[j] intValue];
                array[j] = array[j + 1];
                array[j + 1] = [NSNumber numberWithInt:temp];
            }
        }
    }
}
*/

//线性查找
/// 冒泡排序
+ (void)bubbleSortWithArray:(NSMutableArray *)array withFirst:(NSInteger)first withEnd:(NSInteger)end{
    for (NSInteger i = first ; i < end; i++) {
        for (NSInteger j = end; j > i; j--) {
            if (array[j] < array[j-1]) {
                id temp = array[j];
                array[j] = array[j - 1];
                array[j - 1] = temp;
            }
        }
    }
}

+ (void)bubbleSortWithArray:(NSMutableArray *)array{
    return [self bubbleSortWithArray:array withFirst:0 withEnd:[array count] - 1];
}


//求取最小的k个数
//数组a中从a[p]到a[r]的元素按照x划分,大于或者等于x的在右边,小于x的在左边
+ (NSInteger)partitionModify:(NSMutableArray *)a withP:(NSInteger)p withR:(NSInteger)r withX:(NSInteger)x{
    NSInteger i,j;
    
    j = r;
    
    for (i = p; i < j; i++) {
        if ([a[i] integerValue] >= x) {
            while (i<j && [a[j] integerValue] >= x) j--;
            if (i != j) {
                id t = a[i];
                a[i] = a[j];
                a[j] = t;
                j--;
            }
            else break;
        }
    }
    
    /*上面的循环结束分为几种情况
     1 i > j 此时必定有 a[i] >= x，否则 a[j+1] = a[i] < x 与 a[j+1] >= x 矛盾 ,如果不是边界，进入if语句
     2 i = j 此时如果 a[i] < x 则a[i+1] = a[j+1] >x 返回 i
     3 当i==p,此时直接返回边界元素下标
     4 当i == r,此时为右边界，此时a[i]肯定为x，返回i - 1，也即r - 1
     */
    
    if ([a[i] integerValue] >= x && i > p) {
        return i - 1;
    }
    return i;
}

//将r-p+1个数据按五个元素分为一组，分别找出各组的中位数，
//再将各组的中位数与数组开头的数据在组的顺序依次交换，对这些各组的中位数
//按同样的方法继续求出中位数，最后得出的整个数组的中位数，利用中位数就可以将数据按照与中位数的比较来划分
+ (NSInteger)selectModify:(NSMutableArray *)array withP:(NSInteger)p withR:(NSInteger)r withK:(NSInteger)k{
    NSInteger i;
    if (r - p + 1 <= 5) {
        [self bubbleSortWithArray:array withFirst:p withEnd:r];
        return [array[p + k - 1] integerValue];
    }
    
    //将r-p+1个数据按五个元素分为一组，可以分为(r - p + 1) / 5组
    //分别找出各组的中位数，再将各组的中位数与数组开头的数据按组的顺序依次交换
    for (i = 0; i < (r-p+1)/5;i++ ) {
        NSInteger s = p + 5*i,t=s+4;
        [self bubbleSortWithArray:array withFirst:s withEnd:t];
        id temp = array[p + i];
        array[p + i] = array[s + 2];
        array[s + 2] = temp;
    }
    //对这些各组的中位数
    //按同样的方法继续求出中位数，最后得出的整个数组的中位数 x
    NSInteger x = [self selectModify:array withP:p withR: p + (r - p + 1) / 5 - 1 withK:(r - p + 6) / 10];
    
    i = [self partitionModify:array withP:p withR:r withX:x];
    
    NSInteger j = i - p + 1;
    
    if (k <= j) {
        return [self selectModify:array withP:p withR:i withK:k];
    }else{
        return [self selectModify:array withP:i+1 withR:r withK:k-j];
    }
}


+ (NSInteger)selectModify:(NSMutableArray *)array withNum:(NSInteger)n{
    if (n == 0 || n > [array count]) return -1;// 未查到
    
    return [self selectModify:array withP:0 withR:[array count] - 1 withK:n];
}

/********************************************************************************/

//插入排序
+ (void)insertSort:(NSMutableArray *)list{
    for (int i = 1; i < [list count]; i++) {
        int j = i;
        NSInteger temp = [[list objectAtIndex:i] integerValue];
        while (j >0 && temp < [[list objectAtIndex:j - 1] integerValue]) {
            [list replaceObjectAtIndex:j withObject:[list objectAtIndex:(j - 1)]];
            j--;
        }
        [list replaceObjectAtIndex:j withObject:[NSNumber numberWithInteger:temp]];
    }
}

+ (void)binaryInsertSort:(NSMutableArray *)list{
    for (int i = 1; i < [list count]; i++) {
        NSInteger temp = [[list objectAtIndex:i] integerValue];
        int left = 0;
        int right = i - 1;
        while (left <= right) {
            int middle = (left + right) / 2;
            if (temp < [[list objectAtIndex:middle] integerValue]) {
                right = middle - 1;
            }else{
                left = middle + 1;
            }
        }
        for (int j = i; j > left; j--) {
            [list replaceObjectAtIndex:j withObject:[list objectAtIndex:j-1]];
        }
        [list replaceObjectAtIndex:left withObject:[NSNumber numberWithInteger:temp]];
    }
}

//快速排序
+ (void)quickSortWithArray:(NSMutableArray *)array withLeft:(NSInteger)left andRight:(NSInteger)right{
    if (left >= right) return;
    
    NSInteger i = left;
    NSInteger j = right;
    NSInteger key = [array[left] integerValue];
    
    while (i < j) {
        while (i < j && key <= [array[j] integerValue]) {
            j--;
        }
        array[i] = array[j];
        while (i < j && key >= [array[i] integerValue]) {
            i++;
        }
        array[j] = array[i];
    }
    array[i] = [NSNumber numberWithInteger:key];
    
    [[self class] quickSortWithArray:array withLeft:left andRight:i - 1];
    [[self class] quickSortWithArray:array withLeft:i + 1 andRight:right];
}

//希尔排序
+ (void)shellSort:(NSMutableArray *)list{
    int gap = [list count]/2.0;
    while (gap >= 1) {
        for (int i = gap ; i < [list count]; i++) {
            NSInteger temp = [[list objectAtIndex:i] integerValue];
            int j = i;
            while (j >= gap && temp < [[list objectAtIndex:(j-gap)] integerValue]) {
                [list replaceObjectAtIndex:j withObject:[list objectAtIndex:j-gap]];
                j-=gap;
            }
            [list replaceObjectAtIndex:j withObject:[NSNumber numberWithInteger:temp]];
        }
        gap = gap/2;
    }
}

//二分查找
+ (NSInteger)binarySearchNoRecursion:(NSArray *)srcArray withDes:(NSNumber *)des{
    NSInteger low = 0;
    NSInteger high = [srcArray count] - 1;
    while (low <= high) {
        NSInteger middle = low + ((high + low)>>1);//中间位置计算,low+ 最高位置减去最低位置,右移一位,相当于除2.也可以用(high+low)/2
        if ([des integerValue] == [srcArray[middle] integerValue]) return middle;
        else if([des integerValue] < [srcArray[middle] integerValue]) high = middle - 1;
        else low = middle + 1;
    }
    return -1;
}

+ (NSInteger)binarySearchWithRecursion:(NSArray *)srcArray withDes:(NSNumber *)des{
    NSInteger low = 0;
    NSInteger high = [srcArray count] - 1;
    return [self binSearch:srcArray withLow:low withHigh:high withKey:des];
}

+ (NSInteger)binSearch:(NSArray *)srcArray withLow:(NSInteger)low withHigh:(NSInteger)high withKey:(NSNumber *)key{
    if (low <= high) {
        NSInteger mid = (low + high)/2;
        if ([key integerValue] == [srcArray[mid] integerValue]) return mid;
        else if([key integerValue] < [srcArray[mid] integerValue]) return [self binSearch:srcArray withLow:low withHigh:(mid - 1) withKey:key];
        else return [self binSearch:srcArray withLow:mid+1 withHigh:high withKey:key];
    }else{
        return -1;
    }
}

/// 最大堆heap  最大／最小优先级队列
+ (void)createBiggestHeap:(NSMutableArray *)list withSize:(int)size beIndex:(int)element{
    int lchild = element * 2 + 1,rchild = lchild + 1;//左右子树
    while (rchild < size) {//子树均在范围内
        //如果比左右子树都小，完成整理
        if (list[element] <= list[lchild] && list[element] <= list[rchild]) return;
        //如果左边最小
        if(list[lchild] <= list[rchild]){
            [list exchangeObjectAtIndex:element withObjectAtIndex:lchild];//把左面的提到上面
            element = lchild;//循环时整理子树
        }else{
            //否则右面最小
            [list exchangeObjectAtIndex:element withObjectAtIndex:rchild];
            element = rchild;
        }
        lchild = element * 2 + 1;
        rchild = lchild + 1;//重新计算子树位置
    }
    //只有左子树且子树小于自己
    if (lchild < size && list[lchild] < list[element]) {
        [list exchangeObjectAtIndex:lchild withObjectAtIndex:element];
    }
}

//堆排序time:O(nlgn)
+ (void)heapSort:(NSMutableArray *)list{
    int i , size;
    size = [list count]/1.0;
    // 从子树开始整理树
    for (i = [list count]/1.0 - 1; i >= 0; i--) {
        [self createBiggestHeap:list withSize:size beIndex:i];
    }
    //拆除树
    while (size > 0) {
        [list exchangeObjectAtIndex:size - 1 withObjectAtIndex:0];//将根（最小）与数组最末交换
        size--;//树大小减小
        [self createBiggestHeap:list withSize:size beIndex:0];//整理树
    }
}

//归并排序
+ (void)mergearray:(NSMutableArray *)ary withFirst:(NSInteger)first withMid:(NSInteger)mid withLast:(NSInteger)last ResultAry:(NSMutableArray *)temp{
    NSInteger i = first, j = mid + 1;
    NSInteger m = mid ,n = last;
    NSInteger k = 0;
    
    while (i <= m && j <= n) {
        if (ary[i] <= ary[j])  temp[k++] = ary[i++];
        else temp[k++] = ary[j++];
    }
    
    while (i <= m) temp[k++] = ary[i++];
    
    while (j <= n) temp[k++] = ary[j++];
    
    for (i = 0; i < k; i++) ary[first + i] = temp[i];
}

+ (void)mergeSort:(NSMutableArray *)ary withFirst:(NSInteger)first withLast:(NSInteger)last ResultAry:(NSMutableArray *)temp{
    if (first < last) {
        NSInteger mid = (first + last) / 2;
        [self mergeSort:ary withFirst:first withLast:mid ResultAry:temp]; // 左边有序
        [self mergeSort:ary withFirst:mid + 1 withLast:last ResultAry:temp]; // 右边有序
        [self mergearray:ary withFirst:first withMid:mid withLast:last ResultAry:temp];// 将二个有序数列合并
    }
}

+ (NSMutableArray *)mergeSort:(NSMutableArray *)ary withCapacity:(NSInteger)n{
    NSMutableArray *p = [NSMutableArray arrayWithCapacity:n];
    [self mergeSort:ary withFirst:0 withLast:n-1 ResultAry:p];
    return p;
}

//动态规划
+ (NSString *)getRandomString:(NSInteger)length{
    NSString *str = @"abcdefghijklmnopqrstuvwxyz";
    NSMutableString *res = [[NSMutableString alloc] initWithCapacity:length];
    for (int i = 0; i < length; i++) {
        NSRange range;
        range.length = 1;
        range.location = arc4random()%length;
        NSString *r = [str substringWithRange:range];
        [res appendString:r];
    }
    return res;
}

+ (NSString *)lcs:(NSString *)str1 withOtherString:(NSString *)str2{
    int length1 = (int)[str1 length];
    int length2 = (int)[str2 length];
    NSMutableArray *p1 = [NSMutableArray arrayWithCapacity:length2 + 1];
    // 构造二维数组记录子问题x[i]和y[i]的LCS的长度
    NSMutableArray *opt = [NSMutableArray arrayWithCapacity:length1 + 1];
    for (int i = 0; i < length2 + 1; i++) {
        [p1 addObject:@0];
    }
    
    for (int i = 0; i < length1 + 1; i++) {
        [opt addObject:p1];
    }
    
    
    
    for (int i = length1 - 1; i >= 0; i--) {
        for (int j = length2 - 1; j >= 0; j--) {
            NSRange range1 = {i,1};
            NSRange range2 = {j,1};
            if ([[str1 substringWithRange:range1] isEqualToString:[str2 substringWithRange:range2]]) {
                opt[i][j] = @([opt[i+1][j+1] integerValue] + 1);
            }else{
                int i1 = [opt[i+1][j] intValue] , i2 = [opt[i][j+1] intValue];
                opt[i][j] = @(MAX(i1,i2));
            }
        }
    }
    
    int i = 0,j = 0;
    NSMutableString *result = [[NSMutableString alloc] init];
    
    while (i < length1 && j < length2) {
        NSRange range1 = {i,1};
        NSRange range2 = {j,1};
        if ([[str1 substringWithRange:range1] isEqualToString:[str2 substringWithRange:range2]]) {
            [result appendString:[str1 substringWithRange:range1]];
            i++;
            j++;
        }else if([opt[i + 1][j] intValue] >= [opt[i][j + 1] intValue]){
            i++;
        }else{
            j++;
        }
    }
    return result;
}

@end
