//
//  ViewController.m
//  ObjcDemo
//
//  Created by Dongdong on 16/12/22.
//  Copyright © 2016年 com. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import <sqlite3.h>
#import "NextViewController.h"

/*
使用数据库注意事项
1.使用数据库时,要保证数据库文件存在
2.使用数据库前,要保证数据库是打开状态
3.使用数据库后,要关闭数据库
*/
@interface ViewController ()
{
    sqlite3 *_db;
    UITextField *_nameTF;
    UITextField *_passwordTF;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"push" style:UIBarButtonItemStylePlain target:self action:@selector(pushToNext)];
    
    UITextField *nameTF = [[UITextField alloc] init];
    nameTF.borderStyle = UITextBorderStyleRoundedRect;
    nameTF.placeholder = @"用户名";
    [self.view addSubview:nameTF];
    _nameTF = nameTF;
    
    UITextField *passwordTF = [[UITextField alloc] init];
    passwordTF.borderStyle = UITextBorderStyleRoundedRect;
    passwordTF.placeholder = @"密码";
    [self.view addSubview:passwordTF];
    _passwordTF = passwordTF;
    
    [nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.leading.mas_equalTo(20);
        make.trailing.mas_equalTo(-20);
        make.height.mas_equalTo(44);
    }];
    
    [passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameTF.mas_bottom).offset(10);
        make.leading.mas_equalTo(20);
        make.trailing.mas_equalTo(-20);
        make.height.mas_equalTo(44);
    }];
    
    NSArray *titles = @[@"增", @"删", @"改", @"查"];
    
    for (NSInteger i = 0 ; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(20+ 40 * i);
            make.top.equalTo(passwordTF.mas_bottom).offset(20);
            make.size.mas_equalTo(CGSizeMake(40, 30));
        }];
    }
    
    [self createTable];
}

- (void)pushToNext {
    [self.navigationController pushViewController:[NextViewController new] animated:YES];
}

#pragma mark - 创建数据库文件并打开数据库
- (BOOL)openDataBase {
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/student.sqlite"];
    const char *fileName = [filePath UTF8String];
    int result = sqlite3_open(fileName, &_db);
    if (result == SQLITE_OK) {
        NSLog(@"数据库打开成功");
        return YES;
    } else {
        NSLog(@"数据库打开失败");
        sqlite3_close(_db);
        return NO;
    }
}

#pragma mark - 创建表

- (void)createTable {
    if (![self openDataBase]) {
        return;
    }
    NSString *str = @"CREATE TABLE IF NOT EXISTS student (student_id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT , age INTEGER)";
    char *error = nil;
    //sqlite3_exec对数据库的操作:创建表,增删改,都是用这个方法
    //参数 1.数据库对象 2.sql语句 3.回调函数nil 4.回调函数的参数nil
    if (sqlite3_exec(_db, [str UTF8String], nil, nil, &error) == SQLITE_OK) {
        NSLog(@"创建表成功");
    } else {
        NSLog(@"创建表失败");
    }
    sqlite3_close(_db);
}

#pragma mark - 增

- (void)addData {
    if (![self openDataBase]) {
        return;
    }
    NSString *str = [NSString stringWithFormat:@"insert into student (name , age) values ('%@',%d)",_nameTF.text,_passwordTF.text.intValue];
    char *error = nil;
    if (sqlite3_exec(_db, [str UTF8String], nil, nil, &error) == SQLITE_OK) {
        NSLog(@"插入数据成功");
    } else {
        NSString *errorMsg = [NSString stringWithUTF8String:error];
        NSLog(@"插入数据失败: %@", errorMsg);
    }
    sqlite3_close(_db);
}

#pragma mark - 删

- (void)deleteData {
    if (![self openDataBase]) {
        return;
    }
    NSString *str = [NSString stringWithFormat:@"delete from student where age < 22"];
    char *error = nil;
    if (sqlite3_exec(_db, [str UTF8String], nil, nil, &error) == SQLITE_OK) {
        NSLog(@"删除数据成功");
    } else {
        NSString *errorMsg = [NSString stringWithUTF8String:error];
        NSLog(@"删除数据失败: %@", errorMsg);
    }
    sqlite3_close(_db);
}

#pragma mark 改

- (void)modifyData {
    if (![self openDataBase]) {
        return;
    }
    NSString *str = [NSString stringWithFormat:@"update student set name = '%@' where student_id =%d",@"xiaoming",2];;
    char *error = nil;
    if (sqlite3_exec(_db, [str UTF8String], nil, nil, &error) == SQLITE_OK) {
        NSLog(@"修改数据成功");
    } else {
        NSString *errorMsg = [NSString stringWithUTF8String:error];
        NSLog(@"修改数据失败: %@", errorMsg);
    }
    sqlite3_close(_db);
}

#pragma mark -查

- (void)searchData {
    if (![self openDataBase]) {
        return;
    }
    NSString *str = @"select * from student";
    sqlite3_stmt *stmt = nil;
    char *error = nil;
    //sqlite3_prepare 把sql语句放入缓存区
    //参数1.数据库对象2.sql语句 3.sql语句的长度,-1全部的sql语句 4.缓存区 5.剩余部分的sql语句
    if (sqlite3_prepare(_db, [str UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        //sqlite3_step 单步查询数据,一次只查询一条数据
        //SQLITE_ROW表示数据库中还有数据继续下一个查询
        //SQLITE_DONE 表示数据查询完毕
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //sqlite3_column_text 查询字符串的方法
            //参数1.缓存区 2.字段所在的列号
            char *name = (char *)sqlite3_column_text(stmt, 1);
            int age = sqlite3_column_int(stmt, 2);
            NSString *nameString = [NSString stringWithUTF8String:name];
            int count = sqlite3_column_count(stmt);
            int type = sqlite3_column_type(stmt, 0);
            NSLog(@"%@-----%d---列数:%d,数据类型: %d", nameString, age, count, type);
        }
        sqlite3_finalize(stmt);
    } else {
        NSString *errorMsg = [NSString stringWithUTF8String:error];
        NSLog(@"查询数据失败: %@", errorMsg);
    }
    sqlite3_close(_db);
}

#pragma mark - button event

- (void)buttonClick:(UIButton *)btn {
    switch (btn.tag) {
        case 0:
        {
            [self addData];
        }
            break;
        case 1:
        {
            [self deleteData];
        }
            break;
        case 2:
        {
            [self modifyData];
        }
            break;
        case 3:
        {
            [self searchData];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
