//
//  ViewController.m
//  AudioDemo
//

#import "ViewController.h"
#import "PlayCenter.h"

@interface ViewController (){
    
    BOOL isPause;
    UIButton *buttonPause;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isPause = NO;
    PlayCenter *center = [PlayCenter shareCenter];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"3" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSDictionary *dict = [center play:url];

    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, 180.0f, 280.0f, 280.0f)];
    MPMediaItemArtwork *work = dict[MPMediaItemPropertyArtwork];
    _imageView.image = [work imageWithSize:_imageView.frame.size];
    
    [self.view addSubview:_imageView];
    
    UIButton *buttonForward = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonForward.frame = CGRectMake(20.0f, 130.0f, 80.0f, 40.0f);
    buttonForward.backgroundColor = [UIColor redColor];
    [buttonForward setTitle:@"上一首" forState:UIControlStateNormal];
    [buttonForward addTarget:self action:@selector(forWardMusic:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonForward];
    
    UIButton *buttonNext = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonNext.frame = CGRectMake(120.0f, 130.0f, 80.0f, 40.0f);
    buttonNext.backgroundColor = [UIColor redColor];
    [buttonNext setTitle:@"下一首" forState:UIControlStateNormal];
    [buttonNext addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonNext];
    
    buttonPause = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonPause.frame = CGRectMake(220.0f, 130.0f, 80.0f, 40.0f);
    buttonPause.backgroundColor = [UIColor redColor];
    [buttonPause setTitle:@"暂停" forState:UIControlStateNormal];
    [buttonPause addTarget:self action:@selector(PauseMusic:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonPause];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, 320.0f, 88.0f)];
    _label.textColor = [UIColor blackColor];
    _label.numberOfLines = 0;
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = [NSString stringWithFormat:@"%@ \n%@ - %@",dict[MPMediaItemPropertyTitle],dict[MPMediaItemPropertyAlbumTitle],dict[MPMediaItemPropertyArtist]];
    [self.view addSubview:_label];

    [center addObserver:self forKeyPath:@"info" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)buttonTouch:(UIButton *)sender{
    [[PlayCenter shareCenter] nextItem];
    [buttonPause setTitle:@"暂停" forState:UIControlStateNormal];
    isPause = NO;
}

- (void)forWardMusic:(UIButton *)button {
    [[PlayCenter shareCenter] forwardItem];
    [buttonPause setTitle:@"暂停" forState:UIControlStateNormal];
    isPause = NO;
}

- (void)PauseMusic:(UIButton *)button {
    
    if (isPause == NO) {
        [[PlayCenter shareCenter] pause];
        [button setTitle:@"播放" forState:UIControlStateNormal];
        isPause = YES;
    } else {
        
        [[PlayCenter shareCenter] play];
        [button setTitle:@"暂停" forState:UIControlStateNormal];
        isPause = NO;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSDictionary *dict = [PlayCenter shareCenter].info;

    MPMediaItemArtwork *work = dict[MPMediaItemPropertyArtwork];
    _imageView.image = [work imageWithSize:_imageView.frame.size];
    _label.text = [NSString stringWithFormat:@"%@ \n%@ - %@",dict[MPMediaItemPropertyTitle],dict[MPMediaItemPropertyAlbumTitle],dict[MPMediaItemPropertyArtist]];

}
- (void)dealloc{

    
    [[PlayCenter shareCenter] removeObserver:self forKeyPath:@"info"];
}
@end
