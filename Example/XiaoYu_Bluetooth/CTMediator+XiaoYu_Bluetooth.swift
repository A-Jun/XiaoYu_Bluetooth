//
//  da.swift
//  XiaoYu_Bluetooth_Example
//
//  Created by RJ on 2018/8/30.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import CoreBluetooth
import CTMediator

/// 日期设置处理
public typealias SetDateHandler = (_ success:Bool) -> Void
/// 主界面数据处理
public typealias RequestHomeDataWithFirstFeedbackDataInOneDayHandler      = (_ info:[String:Any]?) -> Void
/// 主界面数据处理
public typealias RequestHomeDataWithSecondFeedbackDataInOneDayHandler     = (_ info:[String:Any]?) -> Void
/// 主界面数据处理
public typealias RequestHomepageDataWithReceiveAllDataHandler             = (_ success:Bool) -> Void
/// 进入实时模式状态
typealias EnterRealTimeModelStateHandler = (_ success:Bool) -> Void
/// 进入实时模式后的蓝牙返回数据处理
typealias EnterRealTimeModelDataHandler = (_ responceValue:[String:Any]?) -> Void

/// 详情界面 处理数据上传
typealias DetailPageUploadDataHandler = (_ responceValue:[String:Any]?) -> Void
/// 详情界面 处理数据上传完成
typealias DetailPageUploadDataCompleteHandler = (_ success:Bool) -> Void

/// 3D挥拍曲线 一拍的总数据
typealias TotalDataOfSingleSwingHandler = (_ infoDic:[String:Any]?) -> Void
/// 3D挥拍曲线 一拍的3D运动曲线数据
typealias U3DDataOfSingleSwingHandler = (_ infoDic:[String:Any]?) -> Void

/// 固件升级:准备工作
typealias CheckPreparationForUpdateFirmwareHandler = (_ infoDic:[String:Any]?) -> Void
/// 固件升级进度
typealias UpdateFirmwareProgressHandler = (_ progress:Double?) -> Void
/// 请求电池电量
typealias requestBattryEnergyHandler = (_ batteryEnergy:Int?) -> Void


/// 请求版本号
typealias RequestVersionHandler = (_ version:[String:Any]?) -> Void
/// 读取MAC地址
typealias ReadMacAddressHandler = (_ macAddress:String?) -> Void
/// 蓝牙指令原句返回
typealias ReturnTheSameCommandHanler = (_ success:Bool) -> Void


let targaetName = "XiaoYu_BluetoothHelper"
var defaultParams :[AnyHashable :Any] = ["defaultKey":"defaultValue",
                                         kCTMediatorParamsKeySwiftTargetModuleName:"XiaoYu_Bluetooth"]
private enum ActionName:String {
    case ScanSensor
    case StopScan
    case Connect
    case DisConnect
    
    case SetDate
    case RequestBatteryEnergy
    case RequestVersion
    case CheckPreparationForUpdateFirmware
    case UpdateFirmware
    case AutoSleep
    case ModifyEquipmentName
    case SetLeftRightHand
    
    case RequestHomePageData
    case EnterRealTimeMode
    case ExitRealTimeModel
    case DetailPage
    case Enter3DSwingTrainingCurvePage
    case Recive3DSwingTrainingCurveDataAtIndex
    case ReciveAll3DSwingTrainingCurveDataEnd
    case Exit3DSwingTrainingCurvePage
    
    //小羽2.0指令
    case ReadMacAddress
    case ShutDown
    case StandBy
    case ReStart
    case ClearCache
    case ReStored

}

typealias SensorInfo = [String:Any]
typealias ScanSensorResultHandler_XiaoYu        = (_ peripherals:[SensorInfo])->Void
typealias ConnectSensorResultHandler_XiaoYu     = (_ success:Bool )->Void
typealias DisConnectSensorResultHandler_XiaoYu  = (_ success:Bool )->Void
//MARK: - 连接外设
extension CTMediator {
    /// 搜索外设
    ///
    /// - Parameters:
    ///   - services: 服务
    ///   - options: 可选字典，指定用于自定义扫描的选项 是否重复扫描已发现的设备 默认为NO
    ///              CBCentralManagerScanOptionAllowDuplicatesKey:false
    class func scanSensor(withServices services :[CBUUID]?, options:[String : Any]? , handler:ScanSensorResultHandler_XiaoYu?)  {
        if services != nil {
            defaultParams["services"] = services!
        }
        if options != nil {
            defaultParams["options"]  = options!
        }
        if handler != nil {
            defaultParams["handler"]  = handler!
        }
        performAction(.ScanSensor)
    }
    /// 结束搜索外设
    class func stopScan()  {
        performAction(.StopScan)
    }
    
    /// 连接外设
    ///
    /// - Parameters:
    ///   - sensor: 外设模型
    ///   - options: 可选字典，指定用于连接状态的提示的选项
    class func connect(_ peripheral: CBPeripheral?, _ options:[String : Any]? , connnectHandler:ConnectSensorResultHandler_XiaoYu?,_ disConnectHandler:DisConnectSensorResultHandler_XiaoYu? ) -> Void {
        defaultParams["options"]    = options
        defaultParams["connectHandler"]    = connnectHandler
        defaultParams["disConnectHandler"]    = disConnectHandler
        defaultParams["peripheral"] = peripheral
        performAction(.Connect)
    }
    
    /// 断开与外设的连接
    class func disConnect() -> Void {
        performAction(.DisConnect)
    }
}


extension CTMediator {
    
    /// 请求日期设置
    ///
    /// - Parameter params: 字典 参数 handler : ((_ success:Bool) -> Void)?
    class func SetDate(_ handler:SetDateHandler?) -> Void  {
        defaultParams["handler"] = handler
        performAction(.SetDate)
    }

    /// 请求主界面数据
    ///
    /// - Parameters:
    ///   - day: 指定请求具体日期 默认为0  返回最近10天数据
    ///   - handler: 回调
    class func requestHomePageData(_ day:Int = 0 , FirstFeedbackDataInOneDay:RequestHomeDataWithFirstFeedbackDataInOneDayHandler?
                                                 , SecondFeedbackDataInOneDay:RequestHomeDataWithSecondFeedbackDataInOneDayHandler?
                                                 , handler:RequestHomepageDataWithReceiveAllDataHandler?) -> Void {
        defaultParams["day"] = day
        defaultParams["first"]  = FirstFeedbackDataInOneDay
        defaultParams["second"]  = SecondFeedbackDataInOneDay
        defaultParams["handler"]  = handler
        performAction(.RequestHomePageData)
    }
    /// 进入实时模式
    ///
    /// - Parameter handler: 回调
    class func enterRealTimeMode(state:EnterRealTimeModelStateHandler? , _ handler:EnterRealTimeModelDataHandler?) -> Void {
        defaultParams["state"]  = state
        defaultParams["handler"]  = handler
        performAction(.EnterRealTimeMode)
    }
    
    /// 退出实时模式
    class func exitRealTimeModel() -> Void {
        performAction(.ExitRealTimeModel)
    }
    
    /// 详情界面
    ///
    /// - Parameters:
    ///   - day: 哪天:1BYTE，范围 1~10，1 表示当天，2 表示有数据记录的前一天，依此类推，0 则连 续发送 10 天数据
    ///   - startIndex: 第几条:2BYTE，从第几条数据开始发送，从 0 开始
    ///   - needIndexs: 多少条:2BYTE，要发送多少条数据，0 表示发送该天所有数据
    class func detailPage(_ day:Int ,_  startIndex:Int ,_  needIndexs:Int , uploadHnaler:DetailPageUploadDataHandler? , completeHandler:DetailPageUploadDataCompleteHandler?) -> Void {
        defaultParams["day"]  = day
        defaultParams["startIndex"]  = startIndex
        defaultParams["needIndexs"]  = needIndexs
        defaultParams["uploadHandler"]  = uploadHnaler
        defaultParams["completeHandler"]  = completeHandler
        performAction(.DetailPage)
    }
    /// 3D挥拍练习曲线界面
    ///
    /// - Parameters:
    ///   - enter3DHandler: 进入3D挥拍练习模式成功与否的回调
    ///   - totalDataHandler: 单次挥拍的总数据
    ///   - u3DDataHandler:   单次挥拍的U3D数据
    class func enter3DSwingTrainCurvePage(_ enter3DHandler:ReturnTheSameCommandHanler? , _ totalDataHandler:TotalDataOfSingleSwingHandler? ,_ u3DDataHandler:U3DDataOfSingleSwingHandler?) -> Void{
        defaultParams["enter3DHandler"]  = enter3DHandler
        defaultParams["totalDataHandler"]  = totalDataHandler
        defaultParams["u3DDataHandler"]  = u3DDataHandler
        performAction(.Enter3DSwingTrainingCurvePage)
    }
    /// APP 退出3D挥拍练习曲线模式: 球拍原句返回
    ///
    /// - Parameter handler: 回调
    class func exit3DSwingTrainingCurvePage(_ handler:ReturnTheSameCommandHanler?) -> Void{
        defaultParams["handler"]  = handler
        performAction(.Exit3DSwingTrainingCurvePage)
    }
    /// 请求电池电量
    ///
    /// - Parameter handler: 回调
    class func requestBatteryEnergy(_ handler:requestBattryEnergyHandler?) -> Void {
        defaultParams["handler"]  = handler
        performAction(.RequestBatteryEnergy)
    }
    /// 检查固件升级准备工作
    ///
    /// - Parameter handler: 回调
    class func checkPreparationForUpdateFirmware(_ handler:CheckPreparationForUpdateFirmwareHandler?) -> Void {
        defaultParams["handler"]  = handler
        performAction(.CheckPreparationForUpdateFirmware)
    }
    /// 固件升级
    ///
    /// - Parameter handler: 回调
    class func updateFirmware(_ progressHandler:UpdateFirmwareProgressHandler? , _ handler:ReturnTheSameCommandHanler?) -> Void {
        defaultParams["progressHandler"]  = progressHandler
        defaultParams["handler"]  = handler
        performAction(.UpdateFirmware)
    }
    /// 请求版本号
    ///
    /// - Parameter handler: 回调
    class func requestVersion(_ handler:RequestVersionHandler?) -> Void {
        defaultParams["handler"]  = handler
        performAction(.RequestVersion)
    }
    /// 自动休眠
    ///
    /// - Parameter handler: 回调
    class func autoSleep(_ sleep:Bool , _ handler:ReturnTheSameCommandHanler?) -> Void {
        defaultParams["sleep"]  = sleep
        defaultParams["handler"]  = handler
        performAction(.AutoSleep)
    }
    /// 修改设备名称
    ///
    /// - Parameter handler: 回调
    class func modifyEquipmentName(_ name:String? ,_ handler:ReturnTheSameCommandHanler?) -> Void {
        defaultParams["name"]  = name
        defaultParams["handler"]  = handler
        performAction(.ModifyEquipmentName)
    }
    /// 设置左右手
    ///
    /// - Parameter handler: 回调
    class func SetLeftRightHand(_ right:Bool ,_ handler:ReturnTheSameCommandHanler?) -> Void {
        defaultParams["right"]    = right
        defaultParams["handler"]  = handler
        performAction(.SetLeftRightHand)
    }
    
    /// 读取MAC地址
    ///
    /// - Parameter handler: 回调
    class func readMacAddress(_ handler:ReadMacAddressHandler?) -> Void {
        defaultParams["handler"]  = handler
        performAction(.ReadMacAddress)
    }
    /// 关机
    ///
    /// - Parameter handler: 回调
    class func shutDown(_ handler:ReturnTheSameCommandHanler?) -> Void {
        defaultParams["handler"]  = handler
        performAction(.ShutDown)
    }
    /// 待机
    ///
    /// - Parameter handler: 回调
    class func standBy(_ handler:ReturnTheSameCommandHanler?) -> Void {
        defaultParams["handler"]  = handler
        performAction(.StandBy)
    }
    /// 重启
    ///
    /// - Parameter handler: 回调
    class func reStart(_ handler:ReturnTheSameCommandHanler?) -> Void {
        defaultParams["handler"]  = handler
        performAction(.ReStart)
    }
    /// 清空缓存
    ///
    /// - Parameter handler: 回调
    class func clearCache(_ handler:ReturnTheSameCommandHanler?) -> Void {
        defaultParams["handler"]  = handler
        performAction(.ClearCache)
    }
    /// 还原出厂设置
    ///
    /// - Parameter handler: 回调
    class func reStored(_ handler:ReturnTheSameCommandHanler?) -> Void {
        defaultParams["handler"]  = handler
        performAction(.ReStored)
    }
    
    /// 选择方法执行
    ///
    /// - Parameter action: 方法类型
    private class func performAction(_ action:ActionName) -> Void {
        CTMediator.sharedInstance().performTarget(targaetName, action: action.rawValue, params: defaultParams, shouldCacheTarget: true)
    }
}

