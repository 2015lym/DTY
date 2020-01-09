//
//  SBTSModel.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/10/9.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "SBTSModel.h"

@implementation SBTSModel
//异或和效验
-(Byte)YHH:(Byte [])src forLenght:(int)lenght
{
    Byte bjy=0x0;;
    for(int i =0;i<lenght;i++)
    {
        Byte bcurr=src[i];
        bjy=bjy^bcurr;
    }
    return bjy;
}

//DataForInt
-(NSData *)getByteForInt:(NSString *)string
{
    int intAngle = [string intValue];
    //1.
    Byte src[4];
    src[0] =   ((intAngle>>24) & 0xFF);
    src[1] =   ((intAngle>>16) & 0xFF);
    src[2] =   ((intAngle>>8) & 0xFF);
    src[3] =   (intAngle & 0xFF);
    
    NSData *data0 = [[NSData alloc] initWithBytes:src length:4];
    return data0;
}



//生成指令E1
-(NSData *)getE1:(NSData *)data
{
    Byte *appUserId=(Byte *)[data bytes];
    
    //1.
    Byte src_e1[5];
    src_e1[0]=0xe1;
    src_e1[1]=appUserId[0];
    src_e1[2]=appUserId[1];
    src_e1[3]=appUserId[2];
    src_e1[4]=appUserId[3];
    Byte byhh=[self YHH:src_e1 forLenght:5];
    
    //2.
    Byte src_new[6];
    src_new[0]=src_e1[0];
    src_new[1]=src_e1[1];
    src_new[2]=src_e1[2];
    src_new[3]=src_e1[3];
    src_new[4]=src_e1[4];
    src_new[5]=byhh;
    
    NSData *data0 = [[NSData alloc] initWithBytes:src_new length:6];
    return data0;
}

//生成指令E2
-(NSData *)getE2
{
    //1.
    Byte src_e1[3];
    src_e1[0]=0xe2;
    src_e1[1]=0x00;
    Byte byhh=[self YHH:src_e1 forLenght:2];
    
    //2.
    Byte src_new[3];
    src_new[0]=src_e1[0];
    src_new[1]=src_e1[1];
    src_new[2]=byhh;
    
    NSData *data0 = [[NSData alloc] initWithBytes:src_new length:3];
    return data0;
}

//生成指令E2——1
-(NSData *)getE2_1:(NSData *)data forzcCode:(NSString  *)zcCode forType :(Byte)type
{
    Byte *appUserId=(Byte *)[data bytes];
    
    //1.
    Byte src_e1[26];
    src_e1[0]=0xe2;
    src_e1[1]=type;
    
    NSData *data0 =[zcCode dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytezcCode=(Byte *)[data0 bytes];
    src_e1[2]=bytezcCode[0];
    src_e1[3]=bytezcCode[1];
    src_e1[4]=bytezcCode[2];
    src_e1[5]=bytezcCode[3];
    src_e1[6]=bytezcCode[4];
    src_e1[7]=bytezcCode[5];
    src_e1[8]=bytezcCode[6];
    src_e1[9]=bytezcCode[7];
    src_e1[10]=bytezcCode[8];
    src_e1[11]=bytezcCode[9];
    src_e1[12]=bytezcCode[10];
    src_e1[13]=bytezcCode[11];
    src_e1[14]=bytezcCode[12];
    src_e1[15]=bytezcCode[13];
    src_e1[16]=bytezcCode[14];
    src_e1[17]=bytezcCode[15];
    src_e1[18]=bytezcCode[16];
    src_e1[19]=bytezcCode[17];
    src_e1[20]=bytezcCode[18];
    src_e1[21]=bytezcCode[19];
   
    
    src_e1[22]=appUserId[0];
    src_e1[23]=appUserId[1];
    src_e1[24]=appUserId[2];
    src_e1[25]=appUserId[3];
    Byte byhh=[self YHH:src_e1 forLenght:26];
    
    //2.
    Byte src_new[27];
    src_new[0]=src_e1[0];
    src_new[1]=src_e1[1];
    src_new[2]=src_e1[2];
    src_new[3]=src_e1[3];
    src_new[4]=src_e1[4];
    
    src_new[5]=src_e1[5];
    src_new[6]=src_e1[6];
    src_new[7]=src_e1[7];
    src_new[8]=src_e1[8];
    src_new[9]=src_e1[9];
    src_new[10]=src_e1[10];
    src_new[11]=src_e1[11];
    src_new[12]=src_e1[12];
    src_new[13]=src_e1[13];
    src_new[14]=src_e1[14];
    src_new[15]=src_e1[15];
    src_new[16]=src_e1[16];
    src_new[17]=src_e1[17];
    src_new[18]=src_e1[18];
    src_new[19]=src_e1[19];
    src_new[20]=src_e1[20];
    src_new[21]=src_e1[21];
    src_new[22]=src_e1[22];
    src_new[23]=src_e1[23];
    src_new[24]=src_e1[24];
    src_new[25]=src_e1[25];
    src_new[26]=byhh;
    
    NSData *datanew = [[NSData alloc] initWithBytes:src_new length:27];
    return datanew;
}

//生成指令E3
-(NSData *)getE3:(NSData *)data forType:(Byte)type
{
    Byte *appUserId=(Byte *)[data bytes];
    
    //1.
    Byte src_e1[6];
    src_e1[0]=0xe3;
    src_e1[1]=type;
    src_e1[2]=appUserId[0];
    src_e1[3]=appUserId[1];
    src_e1[4]=appUserId[2];
    src_e1[5]=appUserId[3];
    Byte byhh=[self YHH:src_e1 forLenght:6];
    
    //2.
    Byte src_new[7];
    src_new[0]=src_e1[0];
    src_new[1]=src_e1[1];
    src_new[2]=src_e1[2];
    src_new[3]=src_e1[3];
    src_new[4]=src_e1[4];
    src_new[5]=src_e1[5];
    src_new[6]=byhh;
    
    
    NSData *data0 = [[NSData alloc] initWithBytes:src_e1 length:7];
    return data0;
}
@end
