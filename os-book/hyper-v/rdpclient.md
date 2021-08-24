# RdpClient

## 可配置项

## AxMsRdpClient9NotSafeForScripting

```cs
public interface IMsTscAdvancedSettings
{
    int Compress { get; set; }
    int BitmapPeristence { get; set; }
    int allowBackgroundInput { get; set; }
    string KeyBoardLayoutStr { set; }
    string PluginDlls { set; }
    string IconFile { set; }
    int IconIndex { set; }
    int ContainerHandledFullScreen { get; set; }
    int DisableRdpdr { get; set; }
}

public interface IMsTscDebug
{
    int HatchBitmapPDU { get; set; }
    int HatchSSBOrder { get; set; }
    int HatchMembltOrder { get; set; }
    int HatchIndexPDU { get; set; }
    int LabelMemblt { get; set; }
    int BitmapCacheMonitor { get; set; }
    int MallocFailuresPercent { get; set; }
    int MallocHugeFailuresPercent { get; set; }
    int NetThroughput { get; set; }
    string CLXCmdLine { get; set; }
    string CLXDll { get; set; }
    int RemoteProgramsHatchVisibleRegion { get; set; }
    int RemoteProgramsHatchVisibleNoDataRegion { get; set; }
    int RemoteProgramsHatchNonVisibleRegion { get; set; }
    int RemoteProgramsHatchWindow { get; set; }
    int RemoteProgramsStayConnectOnBadCaps { get; set; }
    uint ControlType { get; }
    bool DecodeGfx { set; }
}

public interface IMsRdpClientAdvancedSettings : IMsTscAdvancedSettings
{
    void set_ConnectWithEndpoint(ref object value);

    int Compress { get; set; }
    int BitmapPeristence { get; set; }
    int allowBackgroundInput { get; set; }
    string KeyBoardLayoutStr { set; }
    string PluginDlls { set; }
    string IconFile { set; }
    int IconIndex { set; }
    int ContainerHandledFullScreen { get; set; }
    int DisableRdpdr { get; set; }
    int SmoothScroll { get; set; }
    int AcceleratorPassthrough { get; set; }
    int ShadowBitmap { get; set; }
    int TransportType { get; set; }
    int SasSequence { get; set; }
    int EncryptionEnabled { get; set; }
    int DedicatedTerminal { get; set; }
    int RDPPort { get; set; }
    int EnableMouse { get; set; }
    int DisableCtrlAltDel { get; set; }
    int EnableWindowsKey { get; set; }
    int DoubleClickDetect { get; set; }
    int MaximizeShell { get; set; }
    int HotKeyFullScreen { get; set; }
    int HotKeyCtrlEsc { get; set; }
    int HotKeyAltEsc { get; set; }
    int HotKeyAltTab { get; set; }
    int HotKeyAltShiftTab { get; set; }
    int HotKeyAltSpace { get; set; }
    int HotKeyCtrlAltDel { get; set; }
    int orderDrawThreshold { get; set; }
    int BitmapCacheSize { get; set; }
    int BitmapVirtualCacheSize { get; set; }
    int ScaleBitmapCachesByBPP { get; set; }
    int NumBitmapCaches { get; set; }
    int CachePersistenceActive { get; set; }
    string PersistCacheDirectory { set; }
    int brushSupportLevel { get; set; }
    int minInputSendInterval { get; set; }
    int InputEventsAtOnce { get; set; }
    int maxEventCount { get; set; }
    int keepAliveInterval { get; set; }
    int shutdownTimeout { get; set; }
    int overallConnectionTimeout { get; set; }
    int singleConnectionTimeout { get; set; }
    int KeyboardType { get; set; }
    int KeyboardSubType { get; set; }
    int KeyboardFunctionKey { get; set; }
    int WinceFixedPalette { get; set; }
    bool ConnectToServerConsole { get; set; }
    int BitmapPersistence { get; set; }
    int MinutesToIdleTimeout { get; set; }
    bool SmartSizing { get; set; }
    string RdpdrLocalPrintingDocName { get; set; }
    string RdpdrClipCleanTempDirString { get; set; }
    string RdpdrClipPasteInfoString { get; set; }
    string ClearTextPassword { set; }
    bool DisplayConnectionBar { get; set; }
    bool PinConnectionBar { get; set; }
    bool GrabFocusOnConnect { get; set; }
    string LoadBalanceInfo { get; set; }
    bool RedirectDrives { get; set; }
    bool RedirectPrinters { get; set; }
    bool RedirectPorts { get; set; }
    bool RedirectSmartCards { get; set; }
    int BitmapVirtualCache16BppSize { get; set; }
    int BitmapVirtualCache24BppSize { get; set; }
    int PerformanceFlags { get; set; }
    IntPtr ConnectWithEndpoint { set; }
    bool NotifyTSPublicKey { get; set; }
}

public interface IMsRdpClientSecuredSettings : IMsTscSecuredSettings
{
    string StartProgram { get; set; }
    string WorkDir { get; set; }
    int FullScreen { get; set; }
    int KeyboardHookMode { get; set; }
    int AudioRedirectionMode { get; set; }
}

public interface IMsRdpClientAdvancedSettings2 : IMsRdpClientAdvancedSettings
{
    void set_ConnectWithEndpoint(ref object value);

    int Compress { get; set; }
    int BitmapPeristence { get; set; }
    int allowBackgroundInput { get; set; }
    string KeyBoardLayoutStr { set; }
    string PluginDlls { set; }
    string IconFile { set; }
    int IconIndex { set; }
    int ContainerHandledFullScreen { get; set; }
    int DisableRdpdr { get; set; }
    int SmoothScroll { get; set; }
    int AcceleratorPassthrough { get; set; }
    int ShadowBitmap { get; set; }
    int TransportType { get; set; }
    int SasSequence { get; set; }
    int EncryptionEnabled { get; set; }
    int DedicatedTerminal { get; set; }
    int RDPPort { get; set; }
    int EnableMouse { get; set; }
    int DisableCtrlAltDel { get; set; }
    int EnableWindowsKey { get; set; }
    int DoubleClickDetect { get; set; }
    int MaximizeShell { get; set; }
    int HotKeyFullScreen { get; set; }
    int HotKeyCtrlEsc { get; set; }
    int HotKeyAltEsc { get; set; }
    int HotKeyAltTab { get; set; }
    int HotKeyAltShiftTab { get; set; }
    int HotKeyAltSpace { get; set; }
    int HotKeyCtrlAltDel { get; set; }
    int orderDrawThreshold { get; set; }
    int BitmapCacheSize { get; set; }
    int BitmapVirtualCacheSize { get; set; }
    int ScaleBitmapCachesByBPP { get; set; }
    int NumBitmapCaches { get; set; }
    int CachePersistenceActive { get; set; }
    string PersistCacheDirectory { set; }
    int brushSupportLevel { get; set; }
    int minInputSendInterval { get; set; }
    int InputEventsAtOnce { get; set; }
    int maxEventCount { get; set; }
    int keepAliveInterval { get; set; }
    int shutdownTimeout { get; set; }
    int overallConnectionTimeout { get; set; }
    int singleConnectionTimeout { get; set; }
    int KeyboardType { get; set; }
    int KeyboardSubType { get; set; }
    int KeyboardFunctionKey { get; set; }
    int WinceFixedPalette { get; set; }
    bool ConnectToServerConsole { get; set; }
    int BitmapPersistence { get; set; }
    int MinutesToIdleTimeout { get; set; }
    bool SmartSizing { get; set; }
    string RdpdrLocalPrintingDocName { get; set; }
    string RdpdrClipCleanTempDirString { get; set; }
    string RdpdrClipPasteInfoString { get; set; }
    string ClearTextPassword { set; }
    bool DisplayConnectionBar { get; set; }
    bool PinConnectionBar { get; set; }
    bool GrabFocusOnConnect { get; set; }
    string LoadBalanceInfo { get; set; }
    bool RedirectDrives { get; set; }
    bool RedirectPrinters { get; set; }
    bool RedirectPorts { get; set; }
    bool RedirectSmartCards { get; set; }
    int BitmapVirtualCache16BppSize { get; set; }
    int BitmapVirtualCache24BppSize { get; set; }
    int PerformanceFlags { get; set; }
    IntPtr ConnectWithEndpoint { set; }
    bool NotifyTSPublicKey { get; set; }
    bool CanAutoReconnect { get; }
    bool EnableAutoReconnect { get; set; }
    int MaxReconnectAttempts { get; set; }
}

public interface IMsRdpClientTransportSettings
{
    string GatewayHostname { get; set; }
    uint GatewayUsageMethod { get; set; }
    uint GatewayProfileUsageMethod { get; set; }
    uint GatewayCredsSource { get; set; }
    uint GatewayUserSelectedCredsSource { get; set; }
    int GatewayIsSupported { get; }
    uint GatewayDefaultUsageMethod { get; }
}

public interface IMsRdpClientAdvancedSettings5 : IMsRdpClientAdvancedSettings4
{
    void set_ConnectWithEndpoint(ref object value);

    int Compress { get; set; }
    int BitmapPeristence { get; set; }
    int allowBackgroundInput { get; set; }
    string KeyBoardLayoutStr { set; }
    string PluginDlls { set; }
    string IconFile { set; }
    int IconIndex { set; }
    int ContainerHandledFullScreen { get; set; }
    int DisableRdpdr { get; set; }
    int SmoothScroll { get; set; }
    int AcceleratorPassthrough { get; set; }
    int ShadowBitmap { get; set; }
    int TransportType { get; set; }
    int SasSequence { get; set; }
    int EncryptionEnabled { get; set; }
    int DedicatedTerminal { get; set; }
    int RDPPort { get; set; }
    int EnableMouse { get; set; }
    int DisableCtrlAltDel { get; set; }
    int EnableWindowsKey { get; set; }
    int DoubleClickDetect { get; set; }
    int MaximizeShell { get; set; }
    int HotKeyFullScreen { get; set; }
    int HotKeyCtrlEsc { get; set; }
    int HotKeyAltEsc { get; set; }
    int HotKeyAltTab { get; set; }
    int HotKeyAltShiftTab { get; set; }
    int HotKeyAltSpace { get; set; }
    int HotKeyCtrlAltDel { get; set; }
    int orderDrawThreshold { get; set; }
    int BitmapCacheSize { get; set; }
    int BitmapVirtualCacheSize { get; set; }
    int ScaleBitmapCachesByBPP { get; set; }
    int NumBitmapCaches { get; set; }
    int CachePersistenceActive { get; set; }
    string PersistCacheDirectory { set; }
    int brushSupportLevel { get; set; }
    int minInputSendInterval { get; set; }
    int InputEventsAtOnce { get; set; }
    int maxEventCount { get; set; }
    int keepAliveInterval { get; set; }
    int shutdownTimeout { get; set; }
    int overallConnectionTimeout { get; set; }
    int singleConnectionTimeout { get; set; }
    int KeyboardType { get; set; }
    int KeyboardSubType { get; set; }
    int KeyboardFunctionKey { get; set; }
    int WinceFixedPalette { get; set; }
    bool ConnectToServerConsole { get; set; }
    int BitmapPersistence { get; set; }
    int MinutesToIdleTimeout { get; set; }
    bool SmartSizing { get; set; }
    string RdpdrLocalPrintingDocName { get; set; }
    string RdpdrClipCleanTempDirString { get; set; }
    string RdpdrClipPasteInfoString { get; set; }
    string ClearTextPassword { set; }
    bool DisplayConnectionBar { get; set; }
    bool PinConnectionBar { get; set; }
    bool GrabFocusOnConnect { get; set; }
    string LoadBalanceInfo { get; set; }
    bool RedirectDrives { get; set; }
    bool RedirectPrinters { get; set; }
    bool RedirectPorts { get; set; }
    bool RedirectSmartCards { get; set; }
    int BitmapVirtualCache16BppSize { get; set; }
    int BitmapVirtualCache24BppSize { get; set; }
    int PerformanceFlags { get; set; }
    IntPtr ConnectWithEndpoint { set; }
    bool NotifyTSPublicKey { get; set; }
    bool CanAutoReconnect { get; }
    bool EnableAutoReconnect { get; set; }
    int MaxReconnectAttempts { get; set; }
    bool ConnectionBarShowMinimizeButton { get; set; }
    bool ConnectionBarShowRestoreButton { get; set; }
    uint AuthenticationLevel { get; set; }
    bool RedirectClipboard { get; set; }
    uint AudioRedirectionMode { get; set; }
    bool ConnectionBarShowPinButton { get; set; }
    bool PublicMode { get; set; }
    bool RedirectDevices { get; set; }
    bool RedirectPOSDevices { get; set; }
    int BitmapVirtualCache32BppSize { get; set; }
}

public interface ITSRemoteProgram
{
    void ServerStartProgram(string bstrExecutablePath, string bstrFilePath, string bstrWorkingDirectory, bool vbExpandEnvVarInWorkingDirectoryOnServer, string bstrArguments, bool vbExpandEnvVarInArgumentsOnServer);

    bool RemoteProgramMode { get; set; }
}

public interface IMsRdpClientShell
{
    void Launch();
    void SetRdpProperty(string szProperty, object Value);
    object GetRdpProperty(string szProperty);
    void ShowTrustedSitesManagementDialog();

    string RdpFileContents { get; set; }
    bool IsRemoteProgramClientInstalled { get; }
    bool PublicMode { get; set; }
}

public interface IMsRdpClientAdvancedSettings6 : IMsRdpClientAdvancedSettings5
{
    void set_ConnectWithEndpoint(ref object value);

    int Compress { get; set; }
    int BitmapPeristence { get; set; }
    int allowBackgroundInput { get; set; }
    string KeyBoardLayoutStr { set; }
    string PluginDlls { set; }
    string IconFile { set; }
    int IconIndex { set; }
    int ContainerHandledFullScreen { get; set; }
    int DisableRdpdr { get; set; }
    int SmoothScroll { get; set; }
    int AcceleratorPassthrough { get; set; }
    int ShadowBitmap { get; set; }
    int TransportType { get; set; }
    int SasSequence { get; set; }
    int EncryptionEnabled { get; set; }
    int DedicatedTerminal { get; set; }
    int RDPPort { get; set; }
    int EnableMouse { get; set; }
    int DisableCtrlAltDel { get; set; }
    int EnableWindowsKey { get; set; }
    int DoubleClickDetect { get; set; }
    int MaximizeShell { get; set; }
    int HotKeyFullScreen { get; set; }
    int HotKeyCtrlEsc { get; set; }
    int HotKeyAltEsc { get; set; }
    int HotKeyAltTab { get; set; }
    int HotKeyAltShiftTab { get; set; }
    int HotKeyAltSpace { get; set; }
    int HotKeyCtrlAltDel { get; set; }
    int orderDrawThreshold { get; set; }
    int BitmapCacheSize { get; set; }
    int BitmapVirtualCacheSize { get; set; }
    int ScaleBitmapCachesByBPP { get; set; }
    int NumBitmapCaches { get; set; }
    int CachePersistenceActive { get; set; }
    string PersistCacheDirectory { set; }
    int brushSupportLevel { get; set; }
    int minInputSendInterval { get; set; }
    int InputEventsAtOnce { get; set; }
    int maxEventCount { get; set; }
    int keepAliveInterval { get; set; }
    int shutdownTimeout { get; set; }
    int overallConnectionTimeout { get; set; }
    int singleConnectionTimeout { get; set; }
    int KeyboardType { get; set; }
    int KeyboardSubType { get; set; }
    int KeyboardFunctionKey { get; set; }
    int WinceFixedPalette { get; set; }
    bool ConnectToServerConsole { get; set; }
    int BitmapPersistence { get; set; }
    int MinutesToIdleTimeout { get; set; }
    bool SmartSizing { get; set; }
    string RdpdrLocalPrintingDocName { get; set; }
    string RdpdrClipCleanTempDirString { get; set; }
    string RdpdrClipPasteInfoString { get; set; }
    string ClearTextPassword { set; }
    bool DisplayConnectionBar { get; set; }
    bool PinConnectionBar { get; set; }
    bool GrabFocusOnConnect { get; set; }
    string LoadBalanceInfo { get; set; }
    bool RedirectDrives { get; set; }
    bool RedirectPrinters { get; set; }
    bool RedirectPorts { get; set; }
    bool RedirectSmartCards { get; set; }
    int BitmapVirtualCache16BppSize { get; set; }
    int BitmapVirtualCache24BppSize { get; set; }
    int PerformanceFlags { get; set; }
    IntPtr ConnectWithEndpoint { set; }
    bool NotifyTSPublicKey { get; set; }
    bool CanAutoReconnect { get; }
    bool EnableAutoReconnect { get; set; }
    int MaxReconnectAttempts { get; set; }
    bool ConnectionBarShowMinimizeButton { get; set; }
    bool ConnectionBarShowRestoreButton { get; set; }
    uint AuthenticationLevel { get; set; }
    bool RedirectClipboard { get; set; }
    uint AudioRedirectionMode { get; set; }
    bool ConnectionBarShowPinButton { get; set; }
    bool PublicMode { get; set; }
    bool RedirectDevices { get; set; }
    bool RedirectPOSDevices { get; set; }
    int BitmapVirtualCache32BppSize { get; set; }
    bool RelativeMouseMode { get; set; }
    string AuthenticationServiceClass { get; set; }
    string PCB { get; set; }
    int HotKeyFocusReleaseLeft { get; set; }
    int HotKeyFocusReleaseRight { get; set; }
    bool EnableCredSspSupport { get; set; }
    uint AuthenticationType { get; }
    bool ConnectToAdministerServer { get; set; }
}

public interface IMsRdpClientTransportSettings2 : IMsRdpClientTransportSettings
{
    string GatewayHostname { get; set; }
    uint GatewayUsageMethod { get; set; }
    uint GatewayProfileUsageMethod { get; set; }
    uint GatewayCredsSource { get; set; }
    uint GatewayUserSelectedCredsSource { get; set; }
    int GatewayIsSupported { get; }
    uint GatewayDefaultUsageMethod { get; }
    uint GatewayCredSharing { get; set; }
    uint GatewayPreAuthRequirement { get; set; }
    string GatewayPreAuthServerAddr { get; set; }
    string GatewaySupportUrl { get; set; }
    string GatewayEncryptedOtpCookie { get; set; }
    uint GatewayEncryptedOtpCookieSize { get; set; }
    string GatewayUsername { get; set; }
    string GatewayDomain { get; set; }
    string GatewayPassword { set; }
}

public interface IMsRdpClientAdvancedSettings7 : IMsRdpClientAdvancedSettings6
{
    void set_ConnectWithEndpoint(ref object value);

    int Compress { get; set; }
    int BitmapPeristence { get; set; }
    int allowBackgroundInput { get; set; }
    string KeyBoardLayoutStr { set; }
    string PluginDlls { set; }
    string IconFile { set; }
    int IconIndex { set; }
    int ContainerHandledFullScreen { get; set; }
    int DisableRdpdr { get; set; }
    int SmoothScroll { get; set; }
    int AcceleratorPassthrough { get; set; }
    int ShadowBitmap { get; set; }
    int TransportType { get; set; }
    int SasSequence { get; set; }
    int EncryptionEnabled { get; set; }
    int DedicatedTerminal { get; set; }
    int RDPPort { get; set; }
    int EnableMouse { get; set; }
    int DisableCtrlAltDel { get; set; }
    int EnableWindowsKey { get; set; }
    int DoubleClickDetect { get; set; }
    int MaximizeShell { get; set; }
    int HotKeyFullScreen { get; set; }
    int HotKeyCtrlEsc { get; set; }
    int HotKeyAltEsc { get; set; }
    int HotKeyAltTab { get; set; }
    int HotKeyAltShiftTab { get; set; }
    int HotKeyAltSpace { get; set; }
    int HotKeyCtrlAltDel { get; set; }
    int orderDrawThreshold { get; set; }
    int BitmapCacheSize { get; set; }
    int BitmapVirtualCacheSize { get; set; }
    int ScaleBitmapCachesByBPP { get; set; }
    int NumBitmapCaches { get; set; }
    int CachePersistenceActive { get; set; }
    string PersistCacheDirectory { set; }
    int brushSupportLevel { get; set; }
    int minInputSendInterval { get; set; }
    int InputEventsAtOnce { get; set; }
    int maxEventCount { get; set; }
    int keepAliveInterval { get; set; }
    int shutdownTimeout { get; set; }
    int overallConnectionTimeout { get; set; }
    int singleConnectionTimeout { get; set; }
    int KeyboardType { get; set; }
    int KeyboardSubType { get; set; }
    int KeyboardFunctionKey { get; set; }
    int WinceFixedPalette { get; set; }
    bool ConnectToServerConsole { get; set; }
    int BitmapPersistence { get; set; }
    int MinutesToIdleTimeout { get; set; }
    bool SmartSizing { get; set; }
    string RdpdrLocalPrintingDocName { get; set; }
    string RdpdrClipCleanTempDirString { get; set; }
    string RdpdrClipPasteInfoString { get; set; }
    string ClearTextPassword { set; }
    bool DisplayConnectionBar { get; set; }
    bool PinConnectionBar { get; set; }
    bool GrabFocusOnConnect { get; set; }
    string LoadBalanceInfo { get; set; }
    bool RedirectDrives { get; set; }
    bool RedirectPrinters { get; set; }
    bool RedirectPorts { get; set; }
    bool RedirectSmartCards { get; set; }
    int BitmapVirtualCache16BppSize { get; set; }
    int BitmapVirtualCache24BppSize { get; set; }
    int PerformanceFlags { get; set; }
    IntPtr ConnectWithEndpoint { set; }
    bool NotifyTSPublicKey { get; set; }
    bool CanAutoReconnect { get; }
    bool EnableAutoReconnect { get; set; }
    int MaxReconnectAttempts { get; set; }
    bool ConnectionBarShowMinimizeButton { get; set; }
    bool ConnectionBarShowRestoreButton { get; set; }
    uint AuthenticationLevel { get; set; }
    bool RedirectClipboard { get; set; }
    uint AudioRedirectionMode { get; set; }
    bool ConnectionBarShowPinButton { get; set; }
    bool PublicMode { get; set; }
    bool RedirectDevices { get; set; }
    bool RedirectPOSDevices { get; set; }
    int BitmapVirtualCache32BppSize { get; set; }
    bool RelativeMouseMode { get; set; }
    string AuthenticationServiceClass { get; set; }
    string PCB { get; set; }
    int HotKeyFocusReleaseLeft { get; set; }
    int HotKeyFocusReleaseRight { get; set; }
    bool EnableCredSspSupport { get; set; }
    uint AuthenticationType { get; }
    bool ConnectToAdministerServer { get; set; }
    bool AudioCaptureRedirectionMode { get; set; }
    uint VideoPlaybackMode { get; set; }
    bool EnableSuperPan { get; set; }
    uint SuperPanAccelerationFactor { get; set; }
    bool NegotiateSecurityLayer { get; set; }
    uint AudioQualityMode { get; set; }
    bool RedirectDirectX { get; set; }
    uint NetworkConnectionType { get; set; }
}

public interface IMsRdpClientTransportSettings3 : IMsRdpClientTransportSettings2
{
    string GatewayHostname { get; set; }
    uint GatewayUsageMethod { get; set; }
    uint GatewayProfileUsageMethod { get; set; }
    uint GatewayCredsSource { get; set; }
    uint GatewayUserSelectedCredsSource { get; set; }
    int GatewayIsSupported { get; }
    uint GatewayDefaultUsageMethod { get; }
    uint GatewayCredSharing { get; set; }
    uint GatewayPreAuthRequirement { get; set; }
    string GatewayPreAuthServerAddr { get; set; }
    string GatewaySupportUrl { get; set; }
    string GatewayEncryptedOtpCookie { get; set; }
    uint GatewayEncryptedOtpCookieSize { get; set; }
    string GatewayUsername { get; set; }
    string GatewayDomain { get; set; }
    string GatewayPassword { set; }
    uint GatewayCredSourceCookie { get; set; }
    string GatewayAuthCookieServerAddr { get; set; }
    string GatewayEncryptedAuthCookie { get; set; }
    uint GatewayEncryptedAuthCookieSize { get; set; }
    string GatewayAuthLoginPage { get; set; }
}

public interface IMsRdpClientSecuredSettings2 : IMsRdpClientSecuredSettings
{
    string StartProgram { get; set; }
    string WorkDir { get; set; }
    int FullScreen { get; set; }
    int KeyboardHookMode { get; set; }
    int AudioRedirectionMode { get; set; }
    string PCB { get; set; }
}

public interface ITSRemoteProgram2 : ITSRemoteProgram
{
    void ServerStartProgram(string bstrExecutablePath, string bstrFilePath, string bstrWorkingDirectory, bool vbExpandEnvVarInWorkingDirectoryOnServer, string bstrArguments, bool vbExpandEnvVarInArgumentsOnServer);

    bool RemoteProgramMode { get; set; }
    string RemoteApplicationName { set; }
    string RemoteApplicationProgram { set; }
    string RemoteApplicationArgs { set; }
}

public interface IMsRdpClientAdvancedSettings8 : IMsRdpClientAdvancedSettings7
{
    void set_ConnectWithEndpoint(ref object value);

    int Compress { get; set; }
    int BitmapPeristence { get; set; }
    int allowBackgroundInput { get; set; }
    string KeyBoardLayoutStr { set; }
    string PluginDlls { set; }
    string IconFile { set; }
    int IconIndex { set; }
    int ContainerHandledFullScreen { get; set; }
    int DisableRdpdr { get; set; }
    int SmoothScroll { get; set; }
    int AcceleratorPassthrough { get; set; }
    int ShadowBitmap { get; set; }
    int TransportType { get; set; }
    int SasSequence { get; set; }
    int EncryptionEnabled { get; set; }
    int DedicatedTerminal { get; set; }
    int RDPPort { get; set; }
    int EnableMouse { get; set; }
    int DisableCtrlAltDel { get; set; }
    int EnableWindowsKey { get; set; }
    int DoubleClickDetect { get; set; }
    int MaximizeShell { get; set; }
    int HotKeyFullScreen { get; set; }
    int HotKeyCtrlEsc { get; set; }
    int HotKeyAltEsc { get; set; }
    int HotKeyAltTab { get; set; }
    int HotKeyAltShiftTab { get; set; }
    int HotKeyAltSpace { get; set; }
    int HotKeyCtrlAltDel { get; set; }
    int orderDrawThreshold { get; set; }
    int BitmapCacheSize { get; set; }
    int BitmapVirtualCacheSize { get; set; }
    int ScaleBitmapCachesByBPP { get; set; }
    int NumBitmapCaches { get; set; }
    int CachePersistenceActive { get; set; }
    string PersistCacheDirectory { set; }
    int brushSupportLevel { get; set; }
    int minInputSendInterval { get; set; }
    int InputEventsAtOnce { get; set; }
    int maxEventCount { get; set; }
    int keepAliveInterval { get; set; }
    int shutdownTimeout { get; set; }
    int overallConnectionTimeout { get; set; }
    int singleConnectionTimeout { get; set; }
    int KeyboardType { get; set; }
    int KeyboardSubType { get; set; }
    int KeyboardFunctionKey { get; set; }
    int WinceFixedPalette { get; set; }
    bool ConnectToServerConsole { get; set; }
    int BitmapPersistence { get; set; }
    int MinutesToIdleTimeout { get; set; }
    bool SmartSizing { get; set; }
    string RdpdrLocalPrintingDocName { get; set; }
    string RdpdrClipCleanTempDirString { get; set; }
    string RdpdrClipPasteInfoString { get; set; }
    string ClearTextPassword { set; }
    bool DisplayConnectionBar { get; set; }
    bool PinConnectionBar { get; set; }
    bool GrabFocusOnConnect { get; set; }
    string LoadBalanceInfo { get; set; }
    bool RedirectDrives { get; set; }
    bool RedirectPrinters { get; set; }
    bool RedirectPorts { get; set; }
    bool RedirectSmartCards { get; set; }
    int BitmapVirtualCache16BppSize { get; set; }
    int BitmapVirtualCache24BppSize { get; set; }
    int PerformanceFlags { get; set; }
    IntPtr ConnectWithEndpoint { set; }
    bool NotifyTSPublicKey { get; set; }
    bool CanAutoReconnect { get; }
    bool EnableAutoReconnect { get; set; }
    int MaxReconnectAttempts { get; set; }
    bool ConnectionBarShowMinimizeButton { get; set; }
    bool ConnectionBarShowRestoreButton { get; set; }
    uint AuthenticationLevel { get; set; }
    bool RedirectClipboard { get; set; }
    uint AudioRedirectionMode { get; set; }
    bool ConnectionBarShowPinButton { get; set; }
    bool PublicMode { get; set; }
    bool RedirectDevices { get; set; }
    bool RedirectPOSDevices { get; set; }
    int BitmapVirtualCache32BppSize { get; set; }
    bool RelativeMouseMode { get; set; }
    string AuthenticationServiceClass { get; set; }
    string PCB { get; set; }
    int HotKeyFocusReleaseLeft { get; set; }
    int HotKeyFocusReleaseRight { get; set; }
    bool EnableCredSspSupport { get; set; }
    uint AuthenticationType { get; }
    bool ConnectToAdministerServer { get; set; }
    bool AudioCaptureRedirectionMode { get; set; }
    uint VideoPlaybackMode { get; set; }
    bool EnableSuperPan { get; set; }
    uint SuperPanAccelerationFactor { get; set; }
    bool NegotiateSecurityLayer { get; set; }
    uint AudioQualityMode { get; set; }
    bool RedirectDirectX { get; set; }
    uint NetworkConnectionType { get; set; }
    bool BandwidthDetection { get; set; }
    ClientSpec ClientProtocolSpec { get; set; }
}

public interface IMsRdpClientTransportSettings4 : IMsRdpClientTransportSettings3
{
    string GatewayHostname { get; set; }
    uint GatewayUsageMethod { get; set; }
    uint GatewayProfileUsageMethod { get; set; }
    uint GatewayCredsSource { get; set; }
    uint GatewayUserSelectedCredsSource { get; set; }
    int GatewayIsSupported { get; }
    uint GatewayDefaultUsageMethod { get; }
    uint GatewayCredSharing { get; set; }
    uint GatewayPreAuthRequirement { get; set; }
    string GatewayPreAuthServerAddr { get; set; }
    string GatewaySupportUrl { get; set; }
    string GatewayEncryptedOtpCookie { get; set; }
    uint GatewayEncryptedOtpCookieSize { get; set; }
    string GatewayUsername { get; set; }
    string GatewayDomain { get; set; }
    string GatewayPassword { set; }
    uint GatewayCredSourceCookie { get; set; }
    string GatewayAuthCookieServerAddr { get; set; }
    string GatewayEncryptedAuthCookie { get; set; }
    uint GatewayEncryptedAuthCookieSize { get; set; }
    string GatewayAuthLoginPage { get; set; }
    uint GatewayBrokeringType { set; }
}

public interface IMsRdpClientAdvancedSettings4 : IMsRdpClientAdvancedSettings3
{
    void set_ConnectWithEndpoint(ref object value);

    int Compress { get; set; }
    int BitmapPeristence { get; set; }
    int allowBackgroundInput { get; set; }
    string KeyBoardLayoutStr { set; }
    string PluginDlls { set; }
    string IconFile { set; }
    int IconIndex { set; }
    int ContainerHandledFullScreen { get; set; }
    int DisableRdpdr { get; set; }
    int SmoothScroll { get; set; }
    int AcceleratorPassthrough { get; set; }
    int ShadowBitmap { get; set; }
    int TransportType { get; set; }
    int SasSequence { get; set; }
    int EncryptionEnabled { get; set; }
    int DedicatedTerminal { get; set; }
    int RDPPort { get; set; }
    int EnableMouse { get; set; }
    int DisableCtrlAltDel { get; set; }
    int EnableWindowsKey { get; set; }
    int DoubleClickDetect { get; set; }
    int MaximizeShell { get; set; }
    int HotKeyFullScreen { get; set; }
    int HotKeyCtrlEsc { get; set; }
    int HotKeyAltEsc { get; set; }
    int HotKeyAltTab { get; set; }
    int HotKeyAltShiftTab { get; set; }
    int HotKeyAltSpace { get; set; }
    int HotKeyCtrlAltDel { get; set; }
    int orderDrawThreshold { get; set; }
    int BitmapCacheSize { get; set; }
    int BitmapVirtualCacheSize { get; set; }
    int ScaleBitmapCachesByBPP { get; set; }
    int NumBitmapCaches { get; set; }
    int CachePersistenceActive { get; set; }
    string PersistCacheDirectory { set; }
    int brushSupportLevel { get; set; }
    int minInputSendInterval { get; set; }
    int InputEventsAtOnce { get; set; }
    int maxEventCount { get; set; }
    int keepAliveInterval { get; set; }
    int shutdownTimeout { get; set; }
    int overallConnectionTimeout { get; set; }
    int singleConnectionTimeout { get; set; }
    int KeyboardType { get; set; }
    int KeyboardSubType { get; set; }
    int KeyboardFunctionKey { get; set; }
    int WinceFixedPalette { get; set; }
    bool ConnectToServerConsole { get; set; }
    int BitmapPersistence { get; set; }
    int MinutesToIdleTimeout { get; set; }
    bool SmartSizing { get; set; }
    string RdpdrLocalPrintingDocName { get; set; }
    string RdpdrClipCleanTempDirString { get; set; }
    string RdpdrClipPasteInfoString { get; set; }
    string ClearTextPassword { set; }
    bool DisplayConnectionBar { get; set; }
    bool PinConnectionBar { get; set; }
    bool GrabFocusOnConnect { get; set; }
    string LoadBalanceInfo { get; set; }
    bool RedirectDrives { get; set; }
    bool RedirectPrinters { get; set; }
    bool RedirectPorts { get; set; }
    bool RedirectSmartCards { get; set; }
    int BitmapVirtualCache16BppSize { get; set; }
    int BitmapVirtualCache24BppSize { get; set; }
    int PerformanceFlags { get; set; }
    IntPtr ConnectWithEndpoint { set; }
    bool NotifyTSPublicKey { get; set; }
    bool CanAutoReconnect { get; }
    bool EnableAutoReconnect { get; set; }
    int MaxReconnectAttempts { get; set; }
    bool ConnectionBarShowMinimizeButton { get; set; }
    bool ConnectionBarShowRestoreButton { get; set; }
    uint AuthenticationLevel { get; set; }
}

public interface IMsRdpClientAdvancedSettings3 : IMsRdpClientAdvancedSettings2
{
    void set_ConnectWithEndpoint(ref object value);

    int Compress { get; set; }
    int BitmapPeristence { get; set; }
    int allowBackgroundInput { get; set; }
    string KeyBoardLayoutStr { set; }
    string PluginDlls { set; }
    string IconFile { set; }
    int IconIndex { set; }
    int ContainerHandledFullScreen { get; set; }
    int DisableRdpdr { get; set; }
    int SmoothScroll { get; set; }
    int AcceleratorPassthrough { get; set; }
    int ShadowBitmap { get; set; }
    int TransportType { get; set; }
    int SasSequence { get; set; }
    int EncryptionEnabled { get; set; }
    int DedicatedTerminal { get; set; }
    int RDPPort { get; set; }
    int EnableMouse { get; set; }
    int DisableCtrlAltDel { get; set; }
    int EnableWindowsKey { get; set; }
    int DoubleClickDetect { get; set; }
    int MaximizeShell { get; set; }
    int HotKeyFullScreen { get; set; }
    int HotKeyCtrlEsc { get; set; }
    int HotKeyAltEsc { get; set; }
    int HotKeyAltTab { get; set; }
    int HotKeyAltShiftTab { get; set; }
    int HotKeyAltSpace { get; set; }
    int HotKeyCtrlAltDel { get; set; }
    int orderDrawThreshold { get; set; }
    int BitmapCacheSize { get; set; }
    int BitmapVirtualCacheSize { get; set; }
    int ScaleBitmapCachesByBPP { get; set; }
    int NumBitmapCaches { get; set; }
    int CachePersistenceActive { get; set; }
    string PersistCacheDirectory { set; }
    int brushSupportLevel { get; set; }
    int minInputSendInterval { get; set; }
    int InputEventsAtOnce { get; set; }
    int maxEventCount { get; set; }
    int keepAliveInterval { get; set; }
    int shutdownTimeout { get; set; }
    int overallConnectionTimeout { get; set; }
    int singleConnectionTimeout { get; set; }
    int KeyboardType { get; set; }
    int KeyboardSubType { get; set; }
    int KeyboardFunctionKey { get; set; }
    int WinceFixedPalette { get; set; }
    bool ConnectToServerConsole { get; set; }
    int BitmapPersistence { get; set; }
    int MinutesToIdleTimeout { get; set; }
    bool SmartSizing { get; set; }
    string RdpdrLocalPrintingDocName { get; set; }
    string RdpdrClipCleanTempDirString { get; set; }
    string RdpdrClipPasteInfoString { get; set; }
    string ClearTextPassword { set; }
    bool DisplayConnectionBar { get; set; }
    bool PinConnectionBar { get; set; }
    bool GrabFocusOnConnect { get; set; }
    string LoadBalanceInfo { get; set; }
    bool RedirectDrives { get; set; }
    bool RedirectPrinters { get; set; }
    bool RedirectPorts { get; set; }
    bool RedirectSmartCards { get; set; }
    int BitmapVirtualCache16BppSize { get; set; }
    int BitmapVirtualCache24BppSize { get; set; }
    int PerformanceFlags { get; set; }
    IntPtr ConnectWithEndpoint { set; }
    bool NotifyTSPublicKey { get; set; }
    bool CanAutoReconnect { get; }
    bool EnableAutoReconnect { get; set; }
    int MaxReconnectAttempts { get; set; }
    bool ConnectionBarShowMinimizeButton { get; set; }
    bool ConnectionBarShowRestoreButton { get; set; }
}
public virtual bool FullScreen { get; set; }

public virtual int StartConnected { get; set; }
public virtual int DesktopHeight { get; set; }
public virtual int DesktopWidth { get; set; }
public virtual short Connected { get; }
public virtual string ConnectingText { get; set; }
public virtual string DisconnectedText { get; set; }
public virtual string UserName { get; set; }
public virtual string Domain { get; set; }
public virtual string Server { get; set; }
public virtual int HorizontalScrollBarVisible { get; }


public virtual void attachEvent(string eventName, object callback);
public virtual void Connect();
public virtual void CreateVirtualChannels(string newVal);
public virtual void detachEvent(string eventName, object callback);
public virtual void Disconnect();
public virtual string GetErrorDescription(uint disconnectReason, uint extendedDisconnectReason);
public virtual string GetStatusText(uint statusCode);
public virtual int GetVirtualChannelOptions(string chanName);
public virtual ControlReconnectStatus Reconnect(uint ulWidth, uint ulHeight);
public virtual ControlCloseStatus RequestClose();
public virtual void SendOnVirtualChannel(string chanName, string chanData);
public virtual void SendRemoteAction(RemoteSessionActionType actionType);
public virtual void SetVirtualChannelOptions(string chanName, int chanOptions);
public virtual void SyncSessionDisplaySettings();
public virtual void UpdateSessionDisplaySettings(uint ulDesktopWidth, uint ulDesktopHeight, uint ulPhysicalWidth, uint ulPhysicalHeight, uint ulOrientation, uint ulDesktopScaleFactor, uint ulDeviceScaleFactor);
protected override void AttachInterfaces();
protected override void CreateSink();
protected override void DetachSink();

```

## AxHost

This is an abstract class.

```cs
//
// Summary:
//     Wraps ActiveX controls and exposes them as fully featured Windows Forms controls.
[ClassInterface(ClassInterfaceType.AutoDispatch)]
[ComVisible(true)]
[DefaultEvent("Enter")]
[Designer("System.Windows.Forms.Design.AxHostDesigner, System.Design, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")]
[DesignTimeVisible(false)]
[ToolboxItem(false)]
public abstract class AxHost : Control, ISupportInitialize, ICustomTypeDescriptor
{
    //
    // Summary:
    //     Initializes a new instance of the System.Windows.Forms.AxHost class, wrapping
    //     the ActiveX control indicated by the specified CLSID.
    //
    // Parameters:
    //   clsid:
    //     The CLSID of the ActiveX control to wrap.
    protected AxHost(string clsid);
    //
    // Summary:
    //     Initializes a new instance of the System.Windows.Forms.AxHost class, wrapping
    //     the ActiveX control indicated by the specified CLSID, and using the shortcut-menu
    //     behavior indicated by the specified flags value.
    //
    // Parameters:
    //   clsid:
    //     The CLSID of the ActiveX control to wrap.
    //
    //   flags:
    //     An System.Int32 that modifies the shortcut-menu behavior for the control.
    protected AxHost(string clsid, int flags);

    //
    // Summary:
    //     This property is not relevant for this class.
    //
    // Returns:
    //     An System.Windows.Forms.ImeMode value.
    [Browsable(false)]
    [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public ImeMode ImeMode { get; set; }
    //
    // Summary:
    //     This property is not relevant for this class.
    //
    // Returns:
    //     The foreground color of the control.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public override Cursor Cursor { get; set; }
    //
    // Summary:
    //     This property is not relevant for this class.
    //
    // Returns:
    //     The shortcut menu associated with the control.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public override ContextMenu ContextMenu { get; set; }
    //
    // Summary:
    //     This property is not relevant for this class.
    //
    // Returns:
    //     A System.Boolean value.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public virtual bool Enabled { get; set; }
    //
    // Summary:
    //     This property is not relevant for this class.
    //
    // Returns:
    //     The font of the text displayed by the control.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public override Font Font { get; set; }
    //
    // Summary:
    //     This property is not relevant for this class.
    //
    // Returns:
    //     The foreground color of the control.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public override Color ForeColor { get; set; }
    //
    // Summary:
    //     This property is not relevant for this class.
    //
    // Returns:
    //     A System.Boolean value.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    [Localizable(true)]
    public virtual bool RightToLeft { get; set; }
    //
    // Summary:
    //     This property is not relevant for this class.
    //
    // Returns:
    //     The text associated with this control.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public override string Text { get; set; }
    //
    // Summary:
    //     Returns a value that indicates whether the hosted control is in edit mode.
    //
    // Returns:
    //     true if the hosted control is in edit mode; otherwise, false.
    [Browsable(false)]
    [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    public bool EditMode { get; }
    //
    // Summary:
    //     Gets a value indicating whether the ActiveX control has an About dialog box.
    //
    // Returns:
    //     true if the ActiveX control has an About dialog box; otherwise, false.
    [Browsable(false)]
    [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    public bool HasAboutBox { get; }
    //
    // Summary:
    //     Gets or sets the site of the control.
    //
    // Returns:
    //     The System.ComponentModel.ISite associated with the Control, if any.
    public override ISite Site { set; }
    //
    // Summary:
    //     Gets or sets the persisted state of the ActiveX control.
    //
    // Returns:
    //     A System.Windows.Forms.AxHost.State that represents the persisted state of the
    //     ActiveX control.
    //
    // Exceptions:
    //   T:System.Exception:
    //     The ActiveX control is already loaded.
    [Browsable(false)]
    [DefaultValue(null)]
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    [RefreshProperties(RefreshProperties.All)]
    public State OcxState { get; set; }
    //
    // Summary:
    //     Gets or sets the control containing the ActiveX control.
    //
    // Returns:
    //     A System.Windows.Forms.ContainerControl that represents the control containing
    //     the ActiveX control.
    [Browsable(false)]
    [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    public ContainerControl ContainingControl { get; set; }
    //
    // Summary:
    //     This property is not relevant for this class.
    //
    // Returns:
    //     The background image displayed in the control.
    [Browsable(false)]
    [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public override Image BackgroundImage { get; set; }
    //
    // Summary:
    //     This member is not meaningful for this control.
    //
    // Returns:
    //     A Color that represents the background color of the control.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public override Color BackColor { get; set; }
    //
    // Summary:
    //     This property is not relevant for this class.
    //
    // Returns:
    //     An System.Windows.Forms.ImageLayout value.
    [Browsable(false)]
    [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public override ImageLayout BackgroundImageLayout { get; set; }
    //
    // Summary:
    //     Gets the required creation parameters when the control handle is created.
    //
    // Returns:
    //     A System.Windows.Forms.CreateParams that contains the required creation parameters
    //     when the handle to the control is created.
    protected override CreateParams CreateParams { get; }
    //
    // Summary:
    //     Gets the default size of the control.
    //
    // Returns:
    //     The default System.Drawing.Size of the control.
    protected override Drawing.Size DefaultSize { get; }

    //
    // Summary:
    //     The System.Windows.Forms.AxHost.KeyPress event is not supported by the System.Windows.Forms.AxHost
    //     class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event KeyPressEventHandler KeyPress;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.Layout event is not supported by the System.Windows.Forms.AxHost
    //     class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event LayoutEventHandler Layout;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.KeyUp event is not supported by the System.Windows.Forms.AxHost
    //     class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event KeyEventHandler KeyUp;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.DragEnter event is not supported by the System.Windows.Forms.AxHost
    //     class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event DragEventHandler DragEnter;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.KeyDown event is not supported by the System.Windows.Forms.AxHost
    //     class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event KeyEventHandler KeyDown;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.ImeModeChanged event is not supported by the
    //     System.Windows.Forms.AxHost class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event EventHandler ImeModeChanged;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.DoubleClick event is not supported by the System.Windows.Forms.AxHost
    //     class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event EventHandler DoubleClick;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.QueryAccessibilityHelp event is not supported
    //     by the System.Windows.Forms.AxHost class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event QueryAccessibilityHelpEventHandler QueryAccessibilityHelp;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.QueryContinueDrag event is not supported by the
    //     System.Windows.Forms.AxHost class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event QueryContinueDragEventHandler QueryContinueDrag;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.Paint event is not supported by the System.Windows.Forms.AxHost
    //     class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event PaintEventHandler Paint;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.HelpRequested event is not supported by the System.Windows.Forms.AxHost
    //     class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event HelpEventHandler HelpRequested;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.GiveFeedback event is not supported by the System.Windows.Forms.AxHost
    //     class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event GiveFeedbackEventHandler GiveFeedback;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.DragLeave event is not supported by the System.Windows.Forms.AxHost
    //     class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event EventHandler DragLeave;
    //
    // Summary:
    //     This event is not relevant for this class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event EventHandler MouseClick;
    //
    // Summary:
    //     This event is not relevant for this class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event EventHandler MouseDoubleClick;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.BackColorChanged event is not supported by the
    //     System.Windows.Forms.AxHost class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event EventHandler BackColorChanged;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.BackgroundImageChanged event is not supported
    //     by the System.Windows.Forms.AxHost class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event EventHandler BackgroundImageChanged;
    //
    // Summary:
    //     This event is not relevant for this class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event EventHandler BackgroundImageLayoutChanged;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.BindingContextChanged event is not supported
    //     by the System.Windows.Forms.AxHost class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event EventHandler BindingContextChanged;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.ContextMenuChanged event is not supported by
    //     the System.Windows.Forms.AxHost class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event EventHandler ContextMenuChanged;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.CursorChanged event is not supported by the System.Windows.Forms.AxHost
    //     class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event EventHandler CursorChanged;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.EnabledChanged event is not supported by the
    //     System.Windows.Forms.AxHost class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event EventHandler EnabledChanged;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.FontChanged event is not supported by the System.Windows.Forms.AxHost
    //     class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event EventHandler FontChanged;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.ForeColorChanged event is not supported by the
    //     System.Windows.Forms.AxHost class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event EventHandler ForeColorChanged;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.RightToLeftChanged event is not supported by
    //     the System.Windows.Forms.AxHost class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event EventHandler RightToLeftChanged;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.TextChanged event is not supported by the System.Windows.Forms.AxHost
    //     class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event EventHandler TextChanged;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.Click event is not supported by the System.Windows.Forms.AxHost
    //     class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event EventHandler Click;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.DragDrop event is not supported by the System.Windows.Forms.AxHost
    //     class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event DragEventHandler DragDrop;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.MouseDown event is not supported by the System.Windows.Forms.AxHost
    //     class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event MouseEventHandler MouseDown;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.MouseEnter event is not supported by the System.Windows.Forms.AxHost
    //     class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event EventHandler MouseEnter;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.DragOver event is not supported by the System.Windows.Forms.AxHost
    //     class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event DragEventHandler DragOver;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.MouseHover event is not supported by the System.Windows.Forms.AxHost
    //     class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event EventHandler MouseHover;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.MouseUp event is not supported by the System.Windows.Forms.AxHost
    //     class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event MouseEventHandler MouseUp;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.MouseMove event is not supported by the System.Windows.Forms.AxHost
    //     class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event MouseEventHandler MouseMove;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.MouseLeave event is not supported by the System.Windows.Forms.AxHost
    //     class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event EventHandler MouseLeave;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.StyleChanged event is not supported by the System.Windows.Forms.AxHost
    //     class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event EventHandler StyleChanged;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.MouseWheel event is not supported by the System.Windows.Forms.AxHost
    //     class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event MouseEventHandler MouseWheel;
    //
    // Summary:
    //     The System.Windows.Forms.AxHost.ChangeUICues event is not supported by the System.Windows.Forms.AxHost
    //     class.
    [Browsable(false)]
    [EditorBrowsable(EditorBrowsableState.Never)]
    public event UICuesEventHandler ChangeUICues;

    //
    // Summary:
    //     Returns a System.Drawing.Color structure that corresponds to the specified OLE
    //     color value.
    //
    // Parameters:
    //   color:
    //     The OLE color value to translate.
    //
    // Returns:
    //     The System.Drawing.Color structure that represents the translated OLE color value.
    [CLSCompliant(false)]
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    protected static Color GetColorFromOleColor(uint color);
    //
    // Summary:
    //     Returns a System.Drawing.Font created from the specified OLE IFont object.
    //
    // Parameters:
    //   font:
    //     The IFont to create a System.Drawing.Font from.
    //
    // Returns:
    //     The System.Drawing.Font created from the specified IFont, System.Windows.Forms.Control.DefaultFont
    //     if the font could not be created, or null if font is null.
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    protected static Font GetFontFromIFont(object font);
    //
    // Summary:
    //     Returns a System.Drawing.Font created from the specified OLE IFontDisp object.
    //
    // Parameters:
    //   font:
    //     The IFontDisp to create a System.Drawing.Font from.
    //
    // Returns:
    //     The System.Drawing.Font created from the specified IFontDisp, System.Windows.Forms.Control.DefaultFont
    //     if the font could not be created, or null if font is null.
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    protected static Font GetFontFromIFontDisp(object font);
    //
    // Summary:
    //     Returns an OLE IFontDisp object created from the specified System.Drawing.Font
    //     object.
    //
    // Parameters:
    //   font:
    //     The font to create an IFontDisp object from.
    //
    // Returns:
    //     The IFontDisp object created from the specified font or null if font is null.
    //
    // Exceptions:
    //   T:System.ArgumentException:
    //     The System.Drawing.Font.Unit property value is not System.Drawing.GraphicsUnit.Point.
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    protected static object GetIFontDispFromFont(Font font);
    //
    // Summary:
    //     Returns an OLE IFont object created from the specified System.Drawing.Font object.
    //
    // Parameters:
    //   font:
    //     The font to create an IFont object from.
    //
    // Returns:
    //     The IFont object created from the specified font, or null if font is null or
    //     the IFont could not be created.
    //
    // Exceptions:
    //   T:System.ArgumentException:
    //     The System.Drawing.Font.Unit property value is not System.Drawing.GraphicsUnit.Point.
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    protected static object GetIFontFromFont(Font font);
    //
    // Summary:
    //     Returns an OLE IPictureDisp object corresponding to the specified System.Drawing.Image.
    //
    // Parameters:
    //   image:
    //     The System.Drawing.Image to convert.
    //
    // Returns:
    //     An System.Object representing the OLE IPictureDisp object.
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    protected static object GetIPictureDispFromPicture(Image image);
    //
    // Summary:
    //     Returns an OLE IPicture object corresponding to the specified System.Windows.Forms.Cursor.
    //
    // Parameters:
    //   cursor:
    //     A System.Windows.Forms.Cursor, which is an image that represents the Windows
    //     mouse pointer.
    //
    // Returns:
    //     An System.Object representing the OLE IPicture object.
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    protected static object GetIPictureFromCursor(Cursor cursor);
    //
    // Summary:
    //     Returns an OLE IPicture object corresponding to the specified System.Drawing.Image.
    //
    // Parameters:
    //   image:
    //     The System.Drawing.Image to convert.
    //
    // Returns:
    //     An System.Object representing the OLE IPicture object.
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    protected static object GetIPictureFromPicture(Image image);
    //
    // Summary:
    //     Returns an OLE Automation date that corresponds to the specified System.DateTime
    //     structure.
    //
    // Parameters:
    //   time:
    //     The System.DateTime structure to translate.
    //
    // Returns:
    //     A double-precision floating-point number that contains an OLE Automation date
    //     equivalent to specified time value.
    //
    // Exceptions:
    //   T:System.OverflowException:
    //     The value of this instance cannot be represented as an OLE Automation Date.
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    protected static double GetOADateFromTime(DateTime time);
    //
    // Summary:
    //     Returns an OLE color value that corresponds to the specified System.Drawing.Color
    //     structure.
    //
    // Parameters:
    //   color:
    //     The System.Drawing.Color structure to translate.
    //
    // Returns:
    //     The OLE color value that represents the translated System.Drawing.Color structure.
    [CLSCompliant(false)]
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    protected static uint GetOleColorFromColor(Color color);
    //
    // Summary:
    //     Returns an System.Drawing.Image corresponding to the specified OLE IPicture object.
    //
    // Parameters:
    //   picture:
    //     The IPicture to convert.
    //
    // Returns:
    //     An System.Drawing.Image representing the IPicture.
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    protected static Image GetPictureFromIPicture(object picture);
    //
    // Summary:
    //     Returns an System.Drawing.Image corresponding to the specified OLE IPictureDisp
    //     object.
    //
    // Parameters:
    //   picture:
    //     The IPictureDisp to convert.
    //
    // Returns:
    //     An System.Drawing.Image representing the IPictureDisp.
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    protected static Image GetPictureFromIPictureDisp(object picture);
    //
    // Summary:
    //     Returns a System.DateTime structure that corresponds to the specified OLE Automation
    //     date.
    //
    // Parameters:
    //   date:
    //     The OLE Automate date to translate.
    //
    // Returns:
    //     A System.DateTime that represents the same date and time as date.
    //
    // Exceptions:
    //   T:System.ArgumentException:
    //     The date is not a valid OLE Automation Date value.
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    protected static DateTime GetTimeFromOADate(double date);
    //
    // Summary:
    //     Begins the initialization of the ActiveX control.
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    public void BeginInit();
    //
    // Summary:
    //     Requests that an object perform an action in response to an end-user's action.
    //
    // Parameters:
    //   verb:
    //     One of the actions enumerated for the object in IOleObject::EnumVerbs.
    public void DoVerb(int verb);
    //
    // Summary:
    //     This method is not supported by this control.
    //
    // Parameters:
    //   bitmap:
    //     A System.Drawing.Bitmap.
    //
    //   targetBounds:
    //     A System.Drawing.Rectangle.
    [EditorBrowsable(EditorBrowsableState.Never)]
    public void DrawToBitmap(Bitmap bitmap, Rectangle targetBounds);
    //
    // Summary:
    //     Ends the initialization of an ActiveX control.
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    public void EndInit();
    //
    // Summary:
    //     Retrieves a reference to the underlying ActiveX control.
    //
    // Returns:
    //     An object that represents the ActiveX control.
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    public object GetOcx();
    //
    // Summary:
    //     Determines if the ActiveX control has a property page.
    //
    // Returns:
    //     true if the ActiveX control has a property page; otherwise, false.
    public bool HasPropertyPages();
    //
    // Summary:
    //     Attempts to activate the editing mode of the hosted control.
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    public void InvokeEditMode();
    //
    // Summary:
    //     Announces to the component change service that the System.Windows.Forms.AxHost
    //     has changed.
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    public void MakeDirty();
    //
    // Summary:
    //     Preprocesses keyboard or input messages within the message loop before they are
    //     dispatched.
    //
    // Parameters:
    //   msg:
    //     A System.Windows.Forms.Message, passed by reference, that represents the message
    //     to process. The possible values are WM_KEYDOWN, WM_SYSKEYDOWN, WM_CHAR, and WM_SYSCHAR.
    //
    // Returns:
    //     true if the message was processed by the control; otherwise, false.
    public override bool PreProcessMessage(ref Message msg);
    //
    // Summary:
    //     Displays the ActiveX control's About dialog box.
    public void ShowAboutBox();
    //
    // Summary:
    //     Displays the property pages associated with the ActiveX control assigned to the
    //     specified parent control.
    //
    // Parameters:
    //   control:
    //     The parent System.Windows.Forms.Control of the ActiveX control.
    public void ShowPropertyPages(Control control);
    //
    // Summary:
    //     Displays the property pages associated with the ActiveX control.
    public void ShowPropertyPages();
    //
    // Summary:
    //     When overridden in a derived class, attaches interfaces to the underlying ActiveX
    //     control.
    protected virtual void AttachInterfaces();
    //
    // Summary:
    //     Creates a handle for the control.
    protected override void CreateHandle();
    //
    // Summary:
    //     Called by the system to create the ActiveX control.
    //
    // Parameters:
    //   clsid:
    //     The CLSID of the ActiveX control.
    //
    // Returns:
    //     An System.Object representing the ActiveX control.
    protected virtual object CreateInstanceCore(Guid clsid);
    //
    // Summary:
    //     Called by the control to prepare it for listening to events.
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    protected virtual void CreateSink();
    //
    // Summary:
    //     Destroys the handle associated with the control.
    protected override void DestroyHandle();
    //
    // Summary:
    //     Called by the control when it stops listening to events.
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    protected virtual void DetachSink();
    //
    // Summary:
    //     Releases the unmanaged resources used by the System.Windows.Forms.Control and
    //     its child controls and optionally releases the managed resources.
    //
    // Parameters:
    //   disposing:
    //     true to release both managed and unmanaged resources; false to release only unmanaged
    //     resources.
    protected override void Dispose(bool disposing);
    //
    // Summary:
    //     Called by the system to retrieve the current bounds of the ActiveX control.
    //
    // Parameters:
    //   bounds:
    //     The original bounds of the ActiveX control.
    //
    //   factor:
    //     A scaling factor.
    //
    //   specified:
    //     A System.Windows.Forms.BoundsSpecified value.
    //
    // Returns:
    //     The unmodified bounds value.
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    protected override Rectangle GetScaledBounds(Rectangle bounds, SizeF factor, BoundsSpecified specified);
    //
    // Summary:
    //     Determines if a character is an input character that the ActiveX control recognizes.
    //
    // Parameters:
    //   charCode:
    //     The character to test.
    //
    // Returns:
    //     true if the character should be sent directly to the ActiveX control and not
    //     preprocessed; otherwise, false.
    protected override bool IsInputChar(char charCode);
    //
    // Summary:
    //     Raises the System.Windows.Forms.Control.BackColorChanged event.
    //
    // Parameters:
    //   e:
    //     An System.EventArgs that contains the event data.
    protected override void OnBackColorChanged(EventArgs e);
    //
    // Summary:
    //     Raises the System.Windows.Forms.Control.FontChanged event.
    //
    // Parameters:
    //   e:
    //     An System.EventArgs that contains the event data.
    protected override void OnFontChanged(EventArgs e);
    //
    // Summary:
    //     Raises the System.Windows.Forms.Control.ForeColorChanged event.
    //
    // Parameters:
    //   e:
    //     An System.EventArgs that contains the event data.
    protected override void OnForeColorChanged(EventArgs e);
    //
    // Summary:
    //     Raises the System.Windows.Forms.Control.HandleCreated event.
    //
    // Parameters:
    //   e:
    //     An System.EventArgs that contains the event data.
    protected override void OnHandleCreated(EventArgs e);
    //
    // Summary:
    //     Called when the control transitions to the in-place active state.
    protected virtual void OnInPlaceActive();
    //
    // Summary:
    //     Raises the System.Windows.Forms.Control.LostFocus event.
    //
    // Parameters:
    //   e:
    //     An System.EventArgs that contains the event data.
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    protected override void OnLostFocus(EventArgs e);
    //
    // Summary:
    //     Processes a dialog key.
    //
    // Parameters:
    //   keyData:
    //     One of the System.Windows.Forms.Keys values that represents the key to process.
    //
    // Returns:
    //     true if the key was processed by the control; otherwise, false.
    protected override bool ProcessDialogKey(Keys keyData);
    //
    // Summary:
    //     Returns a value that indicates whether the hosted control is in a state in which
    //     its properties can be accessed.
    //
    // Returns:
    //     true if the properties of the hosted control can be accessed; otherwise, false.
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    protected bool PropsValid();
    //
    // Summary:
    //     Raises the System.Windows.Forms.AxHost.MouseDown event using the specified objects.
    //
    // Parameters:
    //   o1:
    //     One of the System.Windows.Forms.MouseButtons values that indicate which mouse
    //     button was pressed.
    //
    //   o2:
    //     Not used.
    //
    //   o3:
    //     The x-coordinate of a mouse click, in pixels.
    //
    //   o4:
    //     The y-coordinate of a mouse click, in pixels.
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    protected void RaiseOnMouseDown(object o1, object o2, object o3, object o4);
    //
    // Summary:
    //     Raises the System.Windows.Forms.AxHost.MouseDown event using the specified 32-bit
    //     signed integers.
    //
    // Parameters:
    //   button:
    //     One of the System.Windows.Forms.MouseButtons values that indicate which mouse
    //     button was pressed.
    //
    //   shift:
    //     Not used.
    //
    //   x:
    //     The x-coordinate of a mouse click, in pixels.
    //
    //   y:
    //     The y-coordinate of a mouse click, in pixels.
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    protected void RaiseOnMouseDown(short button, short shift, int x, int y);
    //
    // Summary:
    //     Raises the System.Windows.Forms.AxHost.MouseDown event using the specified single-precision
    //     floating-point numbers.
    //
    // Parameters:
    //   button:
    //     One of the System.Windows.Forms.MouseButtons values that indicate which mouse
    //     button was pressed.
    //
    //   shift:
    //     Not used.
    //
    //   x:
    //     The x-coordinate of a mouse click, in pixels.
    //
    //   y:
    //     The y-coordinate of a mouse click, in pixels.
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    protected void RaiseOnMouseDown(short button, short shift, float x, float y);
    //
    // Summary:
    //     Raises the System.Windows.Forms.AxHost.MouseMove event using the specified single-precision
    //     floating-point numbers.
    //
    // Parameters:
    //   button:
    //     One of the System.Windows.Forms.MouseButtons values that indicate which mouse
    //     button was pressed.
    //
    //   shift:
    //     Not used.
    //
    //   x:
    //     The x-coordinate of a mouse click, in pixels.
    //
    //   y:
    //     The y-coordinate of a mouse click, in pixels.
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    protected void RaiseOnMouseMove(short button, short shift, float x, float y);
    //
    // Summary:
    //     Raises the System.Windows.Forms.AxHost.MouseMove event using the specified 32-bit
    //     signed integers.
    //
    // Parameters:
    //   button:
    //     One of the System.Windows.Forms.MouseButtons values that indicate which mouse
    //     button was pressed.
    //
    //   shift:
    //     Not used.
    //
    //   x:
    //     The x-coordinate of a mouse click, in pixels.
    //
    //   y:
    //     The y-coordinate of a mouse click, in pixels.
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    protected void RaiseOnMouseMove(short button, short shift, int x, int y);
    //
    // Summary:
    //     Raises the System.Windows.Forms.AxHost.MouseMove event using the specified objects.
    //
    // Parameters:
    //   o1:
    //     One of the System.Windows.Forms.MouseButtons values that indicate which mouse
    //     button was pressed.
    //
    //   o2:
    //     Not used.
    //
    //   o3:
    //     The x-coordinate of a mouse click, in pixels.
    //
    //   o4:
    //     The y-coordinate of a mouse click, in pixels.
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    protected void RaiseOnMouseMove(object o1, object o2, object o3, object o4);
    //
    // Summary:
    //     Raises the System.Windows.Forms.AxHost.MouseUp event using the specified single-precision
    //     floating-point numbers.
    //
    // Parameters:
    //   button:
    //     One of the System.Windows.Forms.MouseButtons values that indicate which mouse
    //     button was pressed.
    //
    //   shift:
    //     Not used.
    //
    //   x:
    //     The x-coordinate of a mouse click, in pixels.
    //
    //   y:
    //     The y-coordinate of a mouse click, in pixels.
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    protected void RaiseOnMouseUp(short button, short shift, float x, float y);
    //
    // Summary:
    //     Raises the System.Windows.Forms.AxHost.MouseUp event using the specified 32-bit
    //     signed integers.
    //
    // Parameters:
    //   button:
    //     One of the System.Windows.Forms.MouseButtons values that indicate which mouse
    //     button was pressed.
    //
    //   shift:
    //     Not used.
    //
    //   x:
    //     The x-coordinate of a mouse click, in pixels.
    //
    //   y:
    //     The y-coordinate of a mouse click, in pixels.
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    protected void RaiseOnMouseUp(short button, short shift, int x, int y);
    //
    // Summary:
    //     Raises the System.Windows.Forms.AxHost.MouseUp event using the specified objects.
    //
    // Parameters:
    //   o1:
    //     One of the System.Windows.Forms.MouseButtons values that indicate which mouse
    //     button was pressed.
    //
    //   o2:
    //     Not used.
    //
    //   o3:
    //     The x-coordinate of a mouse click, in pixels.
    //
    //   o4:
    //     The y-coordinate of a mouse click, in pixels.
    [EditorBrowsable(EditorBrowsableState.Advanced)]
    protected void RaiseOnMouseUp(object o1, object o2, object o3, object o4);
    //
    // Summary:
    //     Calls the System.Windows.Forms.AxHost.ShowAboutBox method to display the ActiveX
    //     control's About dialog box.
    //
    // Parameters:
    //   d:
    //     The System.Windows.Forms.AxHost.AboutBoxDelegate to call.
    protected void SetAboutBoxDelegate(AboutBoxDelegate d);
    //
    // Summary:
    //     Performs the work of setting the specified bounds of this control.
    //
    // Parameters:
    //   x:
    //     The new System.Windows.Forms.Control.Left property value of the control.
    //
    //   y:
    //     The new System.Windows.Forms.Control.Top property value of the control.
    //
    //   width:
    //     The new System.Windows.Forms.Control.Width property value of the control.
    //
    //   height:
    //     The new System.Windows.Forms.Control.Height property value of the control.
    //
    //   specified:
    //     A bitwise combination of the System.Windows.Forms.BoundsSpecified values.
    protected override void SetBoundsCore(int x, int y, int width, int height, BoundsSpecified specified);
    //
    // Summary:
    //     Sets the control to the specified visible state.
    //
    // Parameters:
    //   value:
    //     true to make the control visible; otherwise, false.
    protected override void SetVisibleCore(bool value);
    //
    // Summary:
    //     Processes Windows messages.
    //
    // Parameters:
    //   m:
    //     The Windows System.Windows.Forms.Message to process.
    protected override void WndProc(ref Message m);
    //
    // Summary:
    //     Processes a mnemonic character.
    //
    // Parameters:
    //   charCode:
    //     The character to process.
    //
    // Returns:
    //     true if the character was processed as a mnemonic by the control; otherwise,
    //     false.
    protected internal override bool ProcessMnemonic(char charCode);

    //
    // Summary:
    //     Specifies the type of member that referenced the ActiveX control while it was
    //     in an invalid state.
    public enum ActiveXInvokeKind
    {
        //
        // Summary:
        //     A method referenced the ActiveX control.
        MethodInvoke = 0,
        //
        // Summary:
        //     The get accessor of a property referenced the ActiveX control.
        PropertyGet = 1,
        //
        // Summary:
        //     The set accessor of a property referenced the ActiveX control.
        PropertySet = 2
    }

    //
    // Summary:
    //     Specifies the CLSID of an ActiveX control hosted by an System.Windows.Forms.AxHost
    //     control.
    [AttributeUsage(AttributeTargets.Class, Inherited = false)]
    public sealed class ClsidAttribute : Attribute
    {
        //
        // Summary:
        //     Initializes a new instance of the System.Windows.Forms.AxHost.ClsidAttribute
        //     class.
        //
        // Parameters:
        //   clsid:
        //     The CLSID of the ActiveX control.
        public ClsidAttribute(string clsid);

        //
        // Summary:
        //     The CLSID of the ActiveX control.
        //
        // Returns:
        //     The CLSID of the ActiveX control.
        public string Value { get; }
    }
    //
    // Summary:
    //     Specifies a date and time associated with the type library of an ActiveX control
    //     hosted by an System.Windows.Forms.AxHost control.
    [AttributeUsage(AttributeTargets.Assembly, Inherited = false)]
    public sealed class TypeLibraryTimeStampAttribute : Attribute
    {
        //
        // Summary:
        //     Initializes a new instance of the System.Windows.Forms.AxHost.TypeLibraryTimeStampAttribute
        //     class.
        //
        // Parameters:
        //   timestamp:
        //     A System.DateTime value representing the date and time to associate with the
        //     type library.
        public TypeLibraryTimeStampAttribute(string timestamp);

        //
        // Summary:
        //     The date and time to associate with the type library.
        //
        // Returns:
        //     A System.DateTime value representing the date and time to associate with the
        //     type library.
        public DateTime Value { get; }
    }
    //
    // Summary:
    //     Connects an ActiveX control to a client that handles the control's events.
    public class ConnectionPointCookie
    {
        //
        // Summary:
        //     Initializes a new instance of the System.Windows.Forms.AxHost.ConnectionPointCookie
        //     class.
        //
        // Parameters:
        //   source:
        //     A connectable object that contains connection points.
        //
        //   sink:
        //     The client's sink which receives outgoing calls from the connection point.
        //
        //   eventInterface:
        //     The outgoing interface whose connection point object is being requested.
        //
        // Exceptions:
        //   T:System.ArgumentException:
        //     source does not implement eventInterface.
        //
        //   T:System.InvalidCastException:
        //     sink does not implement eventInterface. -or- source does not implement System.Runtime.InteropServices.ComTypes.IConnectionPointContainer.
        //
        //   T:System.InvalidOperationException:
        //     The connection point has already reached its limit of connections and cannot
        //     accept any more.
        public ConnectionPointCookie(object source, object sink, Type eventInterface);

        //
        // Summary:
        //     Releases the unmanaged resources used by the System.Windows.Forms.AxHost.ConnectionPointCookie
        //     class.
        ~ConnectionPointCookie();

        //
        // Summary:
        //     Disconnects the ActiveX control from the client.
        public void Disconnect();
    }
    //
    // Summary:
    //     The exception that is thrown when the ActiveX control is referenced while in
    //     an invalid state.
    public class InvalidActiveXStateException : Exception
    {
        //
        // Summary:
        //     Initializes a new instance of the System.Windows.Forms.AxHost.InvalidActiveXStateException
        //     class without specifying information about the member that referenced the ActiveX
        //     control.
        public InvalidActiveXStateException();
        //
        // Summary:
        //     Initializes a new instance of the System.Windows.Forms.AxHost.InvalidActiveXStateException
        //     class and indicates the name of the member that referenced the ActiveX control
        //     and the kind of reference it made.
        //
        // Parameters:
        //   name:
        //     The name of the member that referenced the ActiveX control while it was in an
        //     invalid state.
        //
        //   kind:
        //     One of the System.Windows.Forms.AxHost.ActiveXInvokeKind values.
        public InvalidActiveXStateException(string name, ActiveXInvokeKind kind);

        //
        // Summary:
        //     Creates and returns a string representation of the current exception.
        //
        // Returns:
        //     A string representation of the current exception.
        public override string ToString();
    }
    //
    // Summary:
    //     Converts System.Windows.Forms.AxHost.State objects from one data type to another.
    public class StateConverter : TypeConverter
    {
        //
        // Summary:
        //     Initializes a new instance of the System.Windows.Forms.AxHost.StateConverter
        //     class.
        public StateConverter();

        //
        // Summary:
        //     Returns whether the System.Windows.Forms.AxHost.StateConverter can convert an
        //     object of the specified type to an System.Windows.Forms.AxHost.State, using the
        //     specified context.
        //
        // Parameters:
        //   context:
        //     An System.ComponentModel.ITypeDescriptorContext that provides a format context.
        //
        //   sourceType:
        //     A System.Type that represents the type from which to convert.
        //
        // Returns:
        //     true if the System.Windows.Forms.AxHost.StateConverter can perform the conversion;
        //     otherwise, false.
        public override bool CanConvertFrom(ITypeDescriptorContext context, Type sourceType);
        //
        // Summary:
        //     Returns whether the System.Windows.Forms.AxHost.StateConverter can convert an
        //     object to the given destination type using the context.
        //
        // Parameters:
        //   context:
        //     An System.ComponentModel.ITypeDescriptorContext that provides a format context.
        //
        //   destinationType:
        //     A System.Type that represents the type from which to convert.
        //
        // Returns:
        //     true if the System.Windows.Forms.AxHost.StateConverter can perform the conversion;
        //     otherwise, false.
        public override bool CanConvertTo(ITypeDescriptorContext context, Type destinationType);
        //
        // Summary:
        //     This member overrides System.ComponentModel.TypeConverter.ConvertFrom(System.ComponentModel.ITypeDescriptorContext,System.Globalization.CultureInfo,System.Object).
        //
        // Parameters:
        //   context:
        //     An System.ComponentModel.ITypeDescriptorContext that provides a format context.
        //
        //   culture:
        //     The System.Globalization.CultureInfo to use as the current culture.
        //
        //   value:
        //     The System.Object to convert.
        //
        // Returns:
        //     An System.Object that represents the converted value.
        public override object ConvertFrom(ITypeDescriptorContext context, CultureInfo culture, object value);
        //
        // Summary:
        //     This member overrides System.ComponentModel.TypeConverter.ConvertTo(System.ComponentModel.ITypeDescriptorContext,System.Globalization.CultureInfo,System.Object,System.Type).
        //
        // Parameters:
        //   context:
        //     An System.ComponentModel.ITypeDescriptorContext that provides a format context.
        //
        //   culture:
        //     A System.Globalization.CultureInfo. If null is passed, the current culture is
        //     assumed.
        //
        //   value:
        //     The System.Object to convert.
        //
        //   destinationType:
        //     The System.Type to convert the value parameter to.
        //
        // Returns:
        //     An System.Object that represents the converted value.
        //
        // Exceptions:
        //   T:System.ArgumentNullException:
        //     destinationType is null.
        public override object ConvertTo(ITypeDescriptorContext context, CultureInfo culture, object value, Type destinationType);
    }
    //
    // Summary:
    //     Encapsulates the persisted state of an ActiveX control.
    [TypeConverter(typeof(TypeConverter))]
    public class State : ISerializable
    {
        //
        // Summary:
        //     Initializes a new instance of the System.Windows.Forms.AxHost.State class for
        //     serializing a state.
        //
        // Parameters:
        //   ms:
        //     A System.IO.Stream in which the state is stored.
        //
        //   storageType:
        //     An System.Int32 indicating the storage type.
        //
        //   manualUpdate:
        //     true for manual updates; otherwise, false.
        //
        //   licKey:
        //     The license key of the control.
        public State(Stream ms, int storageType, bool manualUpdate, string licKey);
        //
        // Summary:
        //     Initializes a new instance of the System.Windows.Forms.AxHost.State class for
        //     deserializing a state.
        //
        // Parameters:
        //   info:
        //     A System.Runtime.Serialization.SerializationInfo value.
        //
        //   context:
        //     A System.Runtime.Serialization.StreamingContext value.
        protected State(SerializationInfo info, StreamingContext context);
    }
    //
    // Summary:
    //     Provides an editor that uses a modal dialog box to display a property page for
    //     an ActiveX control.
    [ComVisible(false)]
    public class AxComponentEditor : WindowsFormsComponentEditor
    {
        //
        // Summary:
        //     Initializes a new instance of the System.Windows.Forms.AxHost.AxComponentEditor
        //     class.
        public AxComponentEditor();

        //
        // Summary:
        //     Creates an editor window that allows the user to edit the specified component.
        //
        // Parameters:
        //   context:
        //     An System.ComponentModel.ITypeDescriptorContext that can be used to gain additional
        //     context information.
        //
        //   obj:
        //     The component to edit.
        //
        //   parent:
        //     An System.Windows.Forms.IWin32Window that the component belongs to.
        //
        // Returns:
        //     true if the component was changed during editing; otherwise, false.
        public override bool EditComponent(ITypeDescriptorContext context, object obj, IWin32Window parent);
    }

    //
    // Summary:
    //     Represents the method that will display an ActiveX control's About dialog box.
    protected delegate void AboutBoxDelegate();
}
```