//
//  VoiceMarkViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/4/9.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "VoiceMarkViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface VoiceMarkViewController ()
@property (nonatomic, strong) AVAudioSession *session;
@property (nonatomic, strong) AVAudioRecorder *recorder;//录音器
@property (nonatomic, strong) AVAudioPlayer *player; //播放器
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger countDown;

@property (nonatomic, strong) NSURL *recordFileUrl; //文件地址

@end

@implementation VoiceMarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _countDown = 0;
    self.navigationItem.title = @"语音备注";
    [self initPlayer];
    if (_isPreview) {
        self.navigationItem.title = @"语音预览";
        _timeLabel.text = @"点击下面按钮播放";
        [self playtest];
        _okButton.hidden = YES;
        _resetButton.hidden = YES;
    }
}

- (void)playtest {
    [self.recorder stop];
    
    if ([self.player isPlaying]) return;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recordFileUrl error:nil];
    NSLog(@"%@", self.recordFileUrl);
    NSLog(@"%li",self.player.data.length/1024);
    
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.player play];
}

- (void)initPlayer {
    AVAudioSession *session =[AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if (session == nil) {
        NSLog(@"Error creating session: %@",[sessionError description]);
    } else {
        [session setActive:YES error:nil];
    }
    
    self.session = session;
    
    
    //1.获取沙盒地址
    if (!_isPreview) {
        _fileName = [NSString stringWithFormat:@"%@.aac", [BaseFunction getTimestamp]];
    }
    NSString *filePath;
    
    
    if (_isUpload) {
        [self playNetMusic];
    } else {
        filePath = [NSString stringWithFormat:@"%@/%@", [FileFunction getSandBoxPath], _fileName];
        //2.获取文件路径
        self.recordFileUrl = [NSURL fileURLWithPath:filePath];
    }
    
    
    
    
    
    //设置参数
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   //采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey,
                                   // 音频格式
                                   [NSNumber numberWithInt: kAudioFormatMPEG4AAC],AVFormatIDKey,
                                   //采样位数  8、16、24、32 默认为16
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                   // 音频通道数 1 或 2
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                   //录音质量
                                   [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                                   nil];
    
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileUrl settings:recordSetting error:nil];
}

- (void)playNetMusic {
    NSString *urlStr;
    if ([_fileName containsString:@"http"]) {
        urlStr = _fileName;
    } else {
        [NSString stringWithFormat:@"%@%@", Ksdby_api_Img, _fileName];
    }
    
    NSURL *url = [[NSURL alloc]initWithString:urlStr];
    NSData * audioData = [NSData dataWithContentsOfURL:url];
    
    //将数据保存到本地指定位置
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.aac", docDirPath , @"temp"];
    [audioData writeToFile:filePath atomically:YES];
    
    //播放本地音乐
    self.recordFileUrl = [NSURL fileURLWithPath:filePath];
}

- (void)timerAdd {
    _countDown++;
    _timeLabel.text = [NSString stringWithFormat:@"%ld秒", _countDown];
}

- (IBAction)startOrStopAction:(UIButton *)sender {
    if (_isPreview) {
        [self playtest];
        return;
    }
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        [sender setBackgroundImage:[UIImage imageNamed:@"备注-正在录音"] forState:UIControlStateNormal];
        if (!_timer) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAdd) userInfo:nil repeats:YES];
        } else {
            _timer.fireDate = [NSDate date];
        }
        [_recorder prepareToRecord];
        [_recorder record];
    } else {
        [sender setBackgroundImage:[UIImage imageNamed:@"备注-开始录音"] forState:UIControlStateNormal];
        [_recorder pause];
        _timer.fireDate = [NSDate distantFuture];
    }
    
}

- (IBAction)resetAction:(id)sender {
    [self.recorder stop];
    _countDown = 0;
    _timeLabel.text = [NSString stringWithFormat:@"%ld秒", _countDown];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isOK = [fileManager removeItemAtPath:[[FileFunction getSandBoxPath] stringByAppendingPathComponent:_fileName] error:NULL];
    NSLog(@"%d", isOK);
    [self initPlayer];
}

- (IBAction)okAction:(id)sender {
    [self.recorder stop];
    if ([self.delegate respondsToSelector:@selector(voicePath:)]) {
        [self.delegate voicePath:_fileName];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
