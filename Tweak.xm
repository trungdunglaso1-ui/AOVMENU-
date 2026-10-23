#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>
#import <mach/vm_map.h>

// ==========================================
// KHAI BÁO OFFSET
// ==========================================
#define OFF_CAM_1           0x554b9ec
#define OFF_CAM_2           0x5561e44
#define BYTE_CAM            0x200080D2C0035FD6

#define OFF_UNTY            0x5f1c2b4
#define OFF_ULTI            0x5f1c3ac
#define OFF_TO_CAO          0x5adf5a8
#define OFF_BO_TRO          0x5fbe014
#define BYTE_MACRO_UI       0x200080D2C0035FD6
#define BYTE_ULTI           0x330080D2

#define OFF_HACK_MAP        0x4A38174
#define BYTE_HACK_MAP       0x1F2003D5

#define OFF_AC_1            0x5A78334
#define OFF_AC_2            0x4BF89BC
#define OFF_AC_3            0x4BF90A0
#define OFF_AC_4            0x47EDCA8
#define OFF_AC_5            0x78B6D70
#define OFF_AC_6            0x78B6D00
#define OFF_AC_7            0x5CC137C
#define OFF_AC_8            0x4D9A320
#define OFF_AC_9            0x73B736C
#define BYTE_AC_RET         0xC0035FD6
#define BYTE_AC_7           0x000080D2C0035FD6

// ==========================================
// LOGIC PATCH BỘ NHỚ
// ==========================================
static uintptr_t g_baseAddr = 0;

uintptr_t get_base_address() {
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        const char *name = _dyld_get_image_name(i);
        if (name && (strstr(name, "UnityFramework") || strstr(name, "kgvn"))) {
            return (uintptr_t)_dyld_get_image_header(i);
        }
    }
    return 0;
}

void patch_mem(uintptr_t addr, uint64_t value, int byte_count) {
    vm_protect(mach_task_self(), addr, byte_count, false, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY);
    if (byte_count == 4) *(uint32_t*)addr = (uint32_t)value;
    else if (byte_count == 8) *(uint64_t*)addr = value;
    vm_protect(mach_task_self(), addr, byte_count, false, VM_PROT_READ | VM_PROT_EXECUTE);
}

void do_cam_xa() { if (!g_baseAddr) g_baseAddr = get_base_address(); patch_mem(g_baseAddr + OFF_CAM_1, BYTE_CAM, 8); patch_mem(g_baseAddr + OFF_CAM_2, BYTE_CAM, 8); }
void do_hack_map() { if (!g_baseAddr) g_baseAddr = get_base_address(); patch_mem(g_baseAddr + OFF_HACK_MAP, BYTE_HACK_MAP, 4); }
void do_hien_ui() { if (!g_baseAddr) g_baseAddr = get_base_address(); patch_mem(g_baseAddr + OFF_UNTY, BYTE_MACRO_UI, 8); patch_mem(g_baseAddr + OFF_TO_CAO, BYTE_MACRO_UI, 8); patch_mem(g_baseAddr + OFF_BO_TRO, BYTE_MACRO_UI, 8); patch_mem(g_baseAddr + OFF_ULTI, BYTE_ULTI, 4); }
void do_bypass_ac() {
    if (!g_baseAddr) g_baseAddr = get_base_address();
    patch_mem(g_baseAddr + OFF_AC_1, BYTE_AC_RET, 4); patch_mem(g_baseAddr + OFF_AC_2, BYTE_AC_RET, 4);
    patch_mem(g_baseAddr + OFF_AC_3, BYTE_AC_RET, 4); patch_mem(g_baseAddr + OFF_AC_4, BYTE_AC_RET, 4);
    patch_mem(g_baseAddr + OFF_AC_5, BYTE_AC_RET, 4); patch_mem(g_baseAddr + OFF_AC_6, BYTE_AC_RET, 4);
    patch_mem(g_baseAddr + OFF_AC_7, BYTE_AC_7, 8); patch_mem(g_baseAddr + OFF_AC_8, BYTE_AC_RET, 4);
    patch_mem(g_baseAddr + OFF_AC_9, BYTE_AC_RET, 4);
}

// ==========================================
// UI MENU (PHONG CÁCH AOV VIP)
// ==========================================
@interface AOVMenuView : UIView
@end

@implementation AOVMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 20;
        self.clipsToBounds = YES;
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor colorWithRed:0.4 green:0.5 blue:0.9 alpha:1.0].CGColor;

        // Header
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 60)];
        header.backgroundColor = [UIColor whiteColor];
        [self addSubview:header];

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, frame.size.width - 60, 30)];
        title.text = @"CHỨC NĂNG CHÍNH";
        title.textColor = [UIColor colorWithRed:0.1 green:0.2 blue:0.6 alpha:1.0];
        title.font = [UIFont boldSystemFontOfSize:20];
        title.textAlignment = NSTextAlignmentCenter;
        [header addSubview:title];

        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        closeBtn.frame = CGRectMake(frame.size.width - 45, 15, 30, 30);
        [closeBtn setImage:[UIImage systemImageNamed:@"power"] forState:UIControlStateNormal];
        [closeBtn setTintColor:[UIColor redColor]];
        [closeBtn addTarget:self action:@selector(closeMenu) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:closeBtn];

        // Khung chứa các nút
        UIView *box = [[UIView alloc] initWithFrame:CGRectMake(15, 70, frame.size.width - 30, 250)];
        box.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
        box.layer.cornerRadius = 15;
        [self addSubview:box];

        UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 20)];
        subTitle.text = @"CHỨC NĂNG CHÍNH";
        subTitle.textColor = [UIColor colorWithRed:0.1 green:0.2 blue:0.6 alpha:1.0];
        subTitle.font = [UIFont boldSystemFontOfSize:14];
        [box addSubview:subTitle];

        // Hàm tạo nút gạt
        #define ADD_TOGGLE(title, desc, yPos, action) { \
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, yPos, 130, 20)]; \
            lbl.text = title; lbl.textColor = [UIColor blackColor]; lbl.font = [UIFont boldSystemFontOfSize:13]; \
            [box addSubview:lbl]; \
            UILabel *sub = [[UILabel alloc] initWithFrame:CGRectMake(15, yPos + 18, 130, 15)]; \
            sub.text = desc; sub.textColor = [UIColor grayColor]; sub.font = [UIFont systemFontOfSize:10]; \
            [box addSubview:sub]; \
            UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(box.frame.size.width - 60, yPos, 50, 30)]; \
            sw.onTintColor = [UIColor colorWithRed:0.4 green:0.5 blue:0.9 alpha:1.0]; \
            [sw addTarget:self action:@selector(action:) forControlEvents:UIControlEventValueChanged]; \
            [box addSubview:sw]; \
        }

        ADD_TOGGLE(@"CAMERA", @"Bật Cam Xa", 40, toggleCam)
        ADD_TOGGLE(@"HACK MAP", @"Xuyên Địa Hình", 100, toggleMap)
        ADD_TOGGLE(@"HIỆN LSD", @"Xem Tỏ, Xem Tỉ Yêu", 160, toggleUI)
        
        // Nút Bypass
        UILabel *lblAC = [[UILabel alloc] initWithFrame:CGRectMake(15, 220, 130, 20)];
        lblAC.text = @"BYPASS AC"; lblAC.textColor = [UIColor redColor]; lblAC.font = [UIFont boldSystemFontOfSize:13];
        [box addSubview:lblAC];
        
        UISwitch *swAC = [[UISwitch alloc] initWithFrame:CGRectMake(box.frame.size.width - 60, 215, 50, 30)];
        swAC.onTintColor = [UIColor redColor];
        [swAC addTarget:self action:@selector(toggleAC:) forControlEvents:UIControlEventValueChanged];
        [box addSubview:swAC];

        // Kéo thả
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)toggleCam:(UISwitch *)s { if (s.isOn) do_cam_xa(); }
- (void)toggleMap:(UISwitch *)s { if (s.isOn) do_hack_map(); }
- (void)toggleUI:(UISwitch *)s { if (s.isOn) do_hien_ui(); }
- (void)toggleAC:(UISwitch *)s { if (s.isOn) do_bypass_ac(); }
- (void)closeMenu { [self removeFromSuperview]; }

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self];
    self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    [gesture setTranslation:CGPointZero inView:self];
}
@end

// ==========================================
// HOOK KHỞI TẠO
// ==========================================
%hook UIWindow
- (instancetype)initWithFrame:(CGRect)frame {
    id ret = %orig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // Kích thước menu
            AOVMenuView *menu = [[AOVMenuView alloc] initWithFrame:CGRectMake(20, 100, 340, 340)];
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            [window addSubview:menu];
        });
    });
    return ret;
}
%end