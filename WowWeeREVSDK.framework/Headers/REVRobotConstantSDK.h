//
//  REVRobotConstantSDK.h
//  REV
//
//  Created by DavidFF Chan on 12/1/2016.
//  Copyright © 2016 ___WOWWEE___. All rights reserved.
//

#ifndef REVRobotConstantSDK_h
#define REVRobotConstantSDK_h

// Device Information Service
#define kRevDeviceInformationServiceString                              "deviceInfo"
#define kRevDeviceInformationServiceUUID                                0x180A
#define kRevHardwareRevisionCharacteristicString                        "hardware"
#define kRevHardwareRevisionCharacteristicUUID                          0x2A27

typedef enum : uint8_t {
    REVTrackingUserControl = 0x01,
    REVTrackingChase = 0x02,
    REVTrackingTurret = 0x03,
    REVTrackingAvoid = 0x04,
    REVTrackingBeacon = 0x05,
    REVTrackingRamp = 0x06,
    REVTrackingCircle = 0x07,
} REVRobotTrackingMode;

typedef enum : uint8_t {
    REVRobotTrackingSignalRight = 0x00,
    REVRobotTrackingSignalLeft = 0x01,
} REVRobotTrackingSignalDirection;

typedef enum : uint8_t {
    REVRobotRXSensorFront = 0x01,
    REVRobotRXSensorRear = 0x02,
    REVRobotRXSensorLeft = 0x03,
    REVRobotRXSensorRight = 0x04,
} REVRobotRXSensor;

typedef enum : uint8_t {
    REVTrackingDistanceFar = 0x01,
    REVTrackingDistanceMedium = 0x02,
    REVTrackingDistanceClose = 0x03,
    REVTrackingDistanceVeryClose = 0x04,
} REVRobotTrackingDistance;

typedef enum : uint8_t {
    REVRobotTrackingSpeed1 = 0x01,
    REVRobotTrackingSpeed2,
    REVRobotTrackingSpeed3,
    REVRobotTrackingSpeed4,
    REVRobotTrackingSpeed5,
    REVRobotTrackingSpeed6,
    REVRobotTrackingSpeed7,
    REVRobotTrackingSpeed8,
    REVRobotTrackingSpeed9,
    REVRobotTrackingSpeed10,
} REVRobotTrackingSpeed;

typedef enum : uint8_t {
    REVRobotColorRed = 0x01,
    REVRobotColorGreen,
    REVRobotColorYellow,
    REVRobotColorBlue,
    REVRobotColorMagenta,
    REVRobotColorCyan,
    REVRobotColorWhite,
    REVRobotColorBlack,
} REVRobotColor;

typedef enum : uint8_t {
    REVTXFront = 0x01,
    REVTXAll,
    REVTXPlane,     // Coming soon
} REVTXDirection;

typedef enum : uint8_t {
    RampTXAll = 0x01,
    RampTXAllWithoutFront = 0x02,
    RampTXShooterIR = 0x03,
} RampTXDirection;

typedef enum : uint8_t {
    REVTractionStandard = 0x01,
    REVTractionHigh = 0x02,
    REVTractionLow = 0x03,
} REVTraction;

typedef enum : uint8_t {
    REVActivationStatus_Unactivated = 0x00,
    REVActivationStatus_Activated = 0x01,
} REVActivationStatus;


typedef enum : uint8_t {
    REVRampShoot_Invincible = 0x10,
    REVRampShoot_HealthPack = 0x11,
    REVRampShoot_SnowFlake = 0x12,
    REVRampShoot_EMP = 0x0a,
} REVRampShootID;

#endif /* REVRobotConstantSDK_h */
