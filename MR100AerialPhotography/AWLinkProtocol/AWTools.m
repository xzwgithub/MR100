//
//  AWTools.m
//  MR100AerialPhotography
//
//  Created by xzw on 17/8/21.
//  Copyright © 2017年 AllWinner. All rights reserved.
//

#import "AWTools.h"
#import <sys/sysctl.h>
#import <mach/mach.h>
#import <sys/mount.h>

@implementation AWTools

//当前设备可用内存(单位：MB)
+(NSString*)availableMemory
{
   return  [self fileSizeToString:[self getAvailableMemorySize]];
}

//cpu占有率
+(float)cpu_usage
{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}



//获取总内存大小
+(long long)getTotalMemorySize
{
    return [NSProcessInfo processInfo].physicalMemory;
}

//获取当前可用内存
+(long long)getAvailableMemorySize
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if (kernReturn != KERN_SUCCESS)
    {
        return NSNotFound;
    }
    
    return ((vm_page_size * vmStats.free_count + vm_page_size * vmStats.inactive_count));
}

//获取总磁盘容量
+(long long)getTotalDiskSize
{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_blocks);
    }
    return freeSpace;
}

//获取可用磁盘容量
+(long long)getAvailableDiskSize
{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_bavail);
    }
    return freeSpace;
}

+(NSString *)fileSizeToString:(unsigned long long)fileSize
{
    NSInteger KB = 1024;
    NSInteger MB = KB*KB;
    NSInteger GB = MB*KB;
    
    if (fileSize < 10)
    {
        return @"0 B";
        
    }else if (fileSize < KB)
    {
        return @"< 1 KB";
        
    }else if (fileSize < MB)
    {
        return [NSString stringWithFormat:@"%.1f KB",((CGFloat)fileSize)/KB];
        
    }else if (fileSize < GB)
    {
        return [NSString stringWithFormat:@"%.1f MB",((CGFloat)fileSize)/MB];
        
    }else
    {
        return [NSString stringWithFormat:@"%.1f GB",((CGFloat)fileSize)/GB];
    }
}




@end
