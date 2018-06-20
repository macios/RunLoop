//
//  ViewController.m
//  runLoop
//
//  Created by ac hu on 2018/6/20.
//  Copyright © 2018年 ac hu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong) NSThread *myThread;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self alwaysLiveBackGoundThread];
}

- (void)alwaysLiveBackGoundThread{
    
    //线程执行完任务后就死掉了
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(myThreadRun) object:@"etund"];
    self.myThread = thread;
    [self.myThread start];
    
//    NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
//    [myTimer fire];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        
        [myTimer fire];
        //以上代码只会跑一次
        //原因：NSTimer,只有注册到RunLoop之后才会生效，主线程是是由系统自动给我们完成的
        //加上这句话也不行
//        [[NSRunLoop currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];
        //这个才可以
//        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
//        [runLoop run];
    });
    
}

-(void)timerAction{
    NSLog(@"正在执行%@",[NSThread currentThread]);
}

- (void)myThreadRun{
    NSLog(@"第一次执行的任务");
    //我们加上这句话，就可以保证线程不死掉，这个线程的RunLoop添加一个source，那么这个线程就会检测这个source等待执行，而不至于死亡(有工作的强烈愿望而不死亡)，他还有没有做完的东西
    [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
//    //这下面一直不会执行
//    NSLog(@"第一次执行的任务");
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"%@",self.myThread);
    [self performSelector:@selector(doBackGroundThreadWork) onThread:self.myThread withObject:nil waitUntilDone:NO];
}
- (void)doBackGroundThreadWork{
    
    NSLog(@"每点击一次执行的任务 %s",__FUNCTION__);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
