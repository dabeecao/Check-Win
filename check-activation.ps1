<#
.SYNOPSIS
    Script kiem tra ban quyen Windows va phat hien cac nguy co/dau hieu su dung crack.
.DESCRIPTION
    Script thuc hien phan tich trang thai kich hoat Windows, kiem tra may chu KMS cau hinh,
    quet cac tep tin, dich vu, tac vu dinh ky va cac dau vet forensic cua cong cu crack (KMSpico, KMSAuto, MAS).
.NOTES
    Yeu cau quyen Administrator de quet day du thong tin he thong.
#>

# 1. LUA CHON NGON NGU (LANGUAGE SELECTION)
Clear-Host
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "  SELECT LANGUAGE / CHON NGON NGU" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "  [1] Tieng Viet (Unaccented)" -ForegroundColor White
Write-Host "  [2] English" -ForegroundColor White
Write-Host "==============================================" -ForegroundColor Cyan
$choice = Read-Host "Nhap lua chon cua ban (1/2) / Enter choice (1/2)"

$lang = "VI"
if ($choice -eq "2") {
    $lang = "EN"
}

# Ham ghi log co mau sac (Colored Logging Functions)
function Write-Header ($Text) {
    Write-Host "`n=== $Text ===" -ForegroundColor Cyan
}

function Write-Info ($Text) {
    Write-Host "[*] $Text" -ForegroundColor White
}

function Write-Success ($Text) {
    Write-Host "[+] $Text" -ForegroundColor Green
}

function Write-Warn ($Text) {
    if ($lang -eq "VI") {
        Write-Host "[!] CANH BAO: $Text" -ForegroundColor Yellow
    } else {
        Write-Host "[!] WARNING: $Text" -ForegroundColor Yellow
    }
}

function Write-Danger ($Text) {
    if ($lang -eq "VI") {
        Write-Host "[X] NGUY CO: $Text" -ForegroundColor Red
    } else {
        Write-Host "[X] RISK: $Text" -ForegroundColor Red
    }
}

# Tu dien ngon ngu (Localization Dictionary)
$MSG = @{
    VI = @{
        HeaderScan = "BAT DAU QUET HE THONG KIEM TRA BAN QUYEN WINDOWS"
        AdminCheck = "KIEM TRA QUYEN ADMINISTRATOR"
        AdminWarn = "Script khong chay bang quyen Administrator.`nMot so chuc nang quet he thong (Services, Tasks, Registry) co the bi gioi han hoac thieu chinh xac.`nKhuyen dung: Chuot phai vao PowerShell chon 'Run as Administrator' roi chay lai script."
        AdminSuccess = "Da xac nhan quyen Administrator. Bat dau quet chuyen sau..."
        OSInfo = "THONG TIN HE DIEU HANH"
        OSName = "He dieu hanh"
        OSVersion = "Phien ban"
        DomainInfo = "Thuoc Domain"
        Yes = "Co"
        No = "Khong"
        LicenseHeader = "PHAN TICH THONG TIN BAN QUYEN WINDOWS"
        LicenseNotInstalled = "Khong tim thay thong tin ban quyen Windows hop le trong SoftwareLicensingProduct."
        LicenseQueryErr = "Loi khi truy van SoftwareLicensingProduct"
        ProductName = "San pham"
        ProductDesc = "Mo ta"
        ProductKey = "Khoa san pham (5 ky tu cuoi)"
        ActivationStatus = "Trang thai kich hoat"
        LicenseChannel = "Kenh ban quyen phat hien"
        KmsHeader = "PHAN TICH MAY CHU KICH HOAT KMS"
        KmsConfig = "May chu kich hoat KMS cau hinh"
        KmsNoManual = "Khong phat hien may chu KMS nao duoc cau hinh thu cong."
        KmsQueryErr = "Khong the truy van thong tin cau hinh KMS dich vu"
        KmsEmulatorWarn = "He thong dang su dung May chu kich hoat noi bo gia lap (KMS Emulator) tren localhost. Day la dau hieu quan trong cua phan mem crack nhu KMSpico hoac KMSAuto."
        KmsPublicWarn = "He thong dang tro toi may chu KMS lau cong cong ({0}). Day la hinh thuc kich hoat lau qua mang (Online KMS Crack)."
        KmsPrivateWarn = "May tinh khong thuoc Domain cong ty nhung lai cau hinh may chu KMS noi bo ({0}). Co the do dung tool crack tu dong thiet lap IP gia lap trong mang LAN hoac may ao."
        KmsWorkgroupWarn = "May khach Workgroup dang dung may chu KMS ngoai mang ({0}). Can kiem tra xem may chu cua ban co thuoc so huu cua to chuc hay khong."
        KmsSafe = "May chu KMS hoat dong binh thuong (Co the thuoc ha tang noi bo doanh nghiep cua ban)."
        FileHeader = "QUET FILE HE THONG VA THU MUC UNG DUNG CRACK"
        FileFound = "Phat hien tep tin cua {0} tai duong dan: {1}"
        FolderFound = "Phat hien thu muc cua {0} tai duong dan: {1}"
        NoFilesFound = "Khong tim thay tep tin hoac thu muc dac trung cua cac cong cu crack."
        ServiceHeader = "KIEM TRA DICH VU WINDOWS SERVICES CHAY NGAM"
        ServiceFound = "Phat hien dich vu kich hoat dang ngo dang chay: {0} ({1}) - Trang thai: {2}"
        NoServicesFound = "Khong phat hien dich vu he thong dang ngo nao lien quan den crack."
        ServiceSkip = "Bo qua quet Services do thieu quyen Administrator."
        TaskHeader = "KIEM TRA CAC TAC VU DINH KY TRONG TASK SCHEDULER"
        TaskFound = "Phat hien Tac vu dinh ky dang ngo: Path: {0} | Trang thai: {1}"
        NoTasksFound = "Khong phat hien tac vu dinh ky tu dong kich hoat nao dang ngo."
        TaskSkip = "Bo qua quet Task Scheduler do thieu quyen Administrator."
        TaskErr = "Loi khi quet cac tac vu trong Task Scheduler"
        HostsHeader = "KIEM TRA FILE HOSTS DE PHAT HIEN CHAN/CHUYEN HUONG KICH HOAT"
        HostsFound = "Phat hien dong cau hinh nghi van trong file Hosts: {0}"
        HostsClean = "File Hosts sach. Khong phat hien cau hinh chan hoac chuyen huong may chu kich hoat Microsoft."
        HostsErr = "Khong the doc hoac phan tich file Hosts"
        HostsNotFound = "Khong tim thay file Hosts tai duong dan tieu chuan."
        VerdictHeader = "KET LUAN & DANH GIA MUC DO RUI RO"
        VerdictTitle = "DANH GIA CHUNG"
        VerdictSafe = "AN TOAN (GENUINE / SAFE)"
        VerdictSafeDesc = "He thong dang su dung ban quyen Windows hop phap va hoat dong binh thuong."
        VerdictUnactivated = "CHUA KICH HOAT (UNACTIVATED / SAFE)"
        VerdictUnactivatedDesc = "He thong chua kich hoat ban quyen chinh thuc nhung sach, khong dung cong cu be khoa lau."
        VerdictWarning = "CANH BAO (WARNING / SUSPICIOUS)"
        VerdictWarningDesc = "Chua phat hien truc tiep tep tin cua cong cu be khoa, nhung he thong co cac thiet lap dang ngo hoac dau vet lich su chay cong cu be khoa."
        VerdictHighRisk = "NGUY CO CAO (CRACKED / MALICIOUS ACTIVATION)"
        VerdictHighRiskDesc = "Da tim thay cac tep tin, dich vu, hoac cau hinh be khoa ro rang (nhu KMS Emulator hoac KMS38) tren may tinh nay."
        VerdictThreatDesc = "Nguy co tiem an: Cac cong cu crack (nhu KMSpico, KMSAuto, v.v.) thuong yeu cau tat phan mem diet virus khi chay, co kha nang cao dinh kem phan mem doc hai (Trojan, Ransomware, Keylogger, CoinMiner) gay mat an toan thong tin."
        ReportHeader = "XUAT FILE BAO CAO"
        ReportSuccessTxt = "Da xuat bao cao dang Text tai"
        ReportSuccessJson = "Da xuat bao cao dang JSON tai"
        ReportErr = "Khong the xuat file bao cao"
        ScanComplete = "Qua trinh kiem tra hoan tat."
        ReportTitle = "BAO CAO KIEM TRA BAN QUYEN WINDOWS VA NGUY CO CRACK"
        ReportTime = "Thoi gian quet"
        ReportOSInfo = "1. THONG TIN HE THONG"
        ReportLicense = "2. TRANG THAI BAN QUYEN"
        ReportKms = "3. CAU HINH KMS"
        ReportCrack = "4. DAU VET CRACK PHAT HIEN"
        ReportHosts = "5. PHAN TICH FILE HOSTS"
        ReportSummary = "Mo ta tom tat"
        NoDetections = "Khong phat hien dau vet nao."
        
        # Advanced localization keys
        Kms38Detect = "PHAT HIEN KMS38 ACTIVATION (CRACK): Thoi gian hieu luc con lai lon hon 180 ngay ({0} ngay) doi voi Volume KMS client. Day la dau hieu cua phan mem be khoa KMS38."
        GvlkKeyWarn = "PHAT HIEN KHOA GVLK MAC DINH ({0}): May tinh dung khoa KMS cong khai cua Microsoft nhung dang o che do Workgroup. Rat co the da dung cong cu crack de kich hoat KMS gia."
        OhookRegWarn = "PHAT HIEN DAU VET OHOOK (CRACK OFFICE/WINDOWS): Khoa registry Resiliency '{0}' chua gia tri gia han den tuong lai rat xa ({1}). Day la phuong phap chan canh bao ban quyen cua Ohook."
        AdvancedHeader = "KIEM TRA CAC PHUONG PHAP BE KHOA NANG CAO (KMS38, OHOOK, GVLK)"
        
        # Forensic localization keys
        ForensicHeader = "KIEM TRA DAU VET LICH SU HE THONG (FORENSIC AUDIT - MAS/HWID)"
        PsHistoryWarn = "PHAT HIEN LICH SU LENH POWERSHELL: Nguoi dung da tung thuc thi lenh tai va chay MAS tu massgrave/get.activated.win vao ngay: {0}. Cau lenh chay: '{1}'"
        EventLogWarn = "PHAT HIEN LOG THUC THI SCRIPTS: Event Log PowerShell ghi nhan script blocks co tu khoa MAS hoac massgrave: {0} dong duoc tim thay."
        HwidKeyWarn = "PHAT HIEN KHOA RETAIL GENERIC HWID ({0}): May dang kich hoat bang khoa Generic mac dinh cua MAS HWID nhung khong dung khoa OEM trong BIOS ({1})."
        HwidGenericWarn = "PHAT HIEN KHOA RETAIL GENERIC HWID ({0}): May dang dung khoa mac dinh cua MAS HWID nhung BIOS khong co san khoa ban quyen OEM mac dinh."
        BiosMsdmFound = "Tim thay khoa OEM nhung trong BIOS: {0}"
        BiosMsdmNotFound = "Khong tim thay khoa OEM trong BIOS (Co the day la may tu lap rap hoac khong co ban quyen kem theo mainboard)."
        
        # Service status check keys
        SvcHeader = "KIEM TRA CAC DICH VU HE THONG COT LOI"
        SvcDisabledWarn = "PHAT HIEN DICH VU '{0}' ({1}) DANG BI VO HIEU HOA (Disabled). Day la dau hieu cho thay he thong da bi can thiep de tranh kiem tra ban quyen hoac chan quet bao mat."
        SvcNormal = "Dich vu '{0}' ({1}) dang o trang thai san sang."
        SvcNotFound = "Khong tim thay dich vu '{0}' ({1}) tren he thong."
        SvcPromptEnable = "Ban co muon tu dong bat va khoi chay dich vu '{0}' khong? (Y/N): "
        SvcEnableSuccess = "Da kich hoat va khoi chay thanh cong dich vu '{0}'."
        SvcEnableFail = "Khong the bat hoac khoi chay dich vu '{0}'. Loi: {1}"
    }
    EN = @{
        HeaderScan = "STARTING WINDOWS LICENSE AND CRACK DETECTION SCAN"
        AdminCheck = "CHECKING ADMINISTRATOR PRIVILEGES"
        AdminWarn = "Script is not running with Administrator privileges.`nSome scans (Services, Tasks, Registry) may be limited or inaccurate.`nRecommendation: Right-click PowerShell and choose 'Run as Administrator', then run the script again."
        AdminSuccess = "Administrator privileges confirmed. Starting deep scan..."
        OSInfo = "OPERATING SYSTEM INFORMATION"
        OSName = "OS Name"
        OSVersion = "Version"
        DomainInfo = "Domain Joined"
        Yes = "Yes"
        No = "No"
        LicenseHeader = "WINDOWS LICENSE INFORMATION ANALYSIS"
        LicenseNotInstalled = "No valid Windows license information found in SoftwareLicensingProduct."
        LicenseQueryErr = "Error querying SoftwareLicensingProduct"
        ProductName = "Product Name"
        ProductDesc = "Description"
        ProductKey = "Product Key (Last 5 characters)"
        ActivationStatus = "Activation Status"
        LicenseChannel = "License Channel Detected"
        KmsHeader = "KMS ACTIVATION SERVER ANALYSIS"
        KmsConfig = "Configured KMS Activation Server"
        KmsNoManual = "No manually configured KMS server detected."
        KmsQueryErr = "Could not query KMS configuration service"
        KmsEmulatorWarn = "The system is using a local KMS Emulator on localhost. This is a key indicator of crack tools like KMSpico or KMSAuto."
        KmsPublicWarn = "The system points to a public unauthorized KMS server ({0}). This is a network-based online KMS crack."
        KmsPrivateWarn = "The computer is not joined to a corporate Domain but has a private KMS server ({0}) configured. This may be due to crack tools setting up a local network emulator."
        KmsWorkgroupWarn = "Workgroup client is using an external KMS server ({0}). Please verify if this server belongs to your organization."
        KmsSafe = "KMS server is running normally (Likely belongs to your organization's internal infrastructure)."
        FileHeader = "CRACK TOOL FILES AND DIRECTORIES SCAN"
        FileFound = "Detected file of {0} at path: {1}"
        FolderFound = "Detected folder of {0} at path: {1}"
        NoFilesFound = "No crack-specific files or directories detected."
        ServiceHeader = "BACKGROUND SERVICES AUDIT"
        ServiceFound = "Detected suspicious activation service running: {0} ({1}) - Status: {2}"
        NoServicesFound = "No suspicious activation-related services detected."
        ServiceSkip = "Skipping Services audit due to lack of Administrator privileges."
        TaskHeader = "TASK SCHEDULER AUDIT"
        TaskFound = "Detected suspicious scheduled task: Path: {0} | Status: {1}"
        NoTasksFound = "No suspicious auto-reactivation scheduled tasks detected."
        TaskSkip = "Skipping Task Scheduler audit due to lack of Administrator privileges."
        TaskErr = "Error scanning Task Scheduler"
        HostsHeader = "HOSTS FILE AUDIT FOR ACTIVATION BLOCKS/REDIRECTS"
        HostsFound = "Detected suspicious redirect in Hosts file: {0}"
        HostsClean = "Hosts file is clean. No Microsoft activation blocks or redirects detected."
        HostsErr = "Could not read or analyze Hosts file"
        HostsNotFound = "Hosts file not found at the standard path."
        VerdictHeader = "OVERALL CONCLUSION & RISK RATING"
        VerdictTitle = "OVERALL RATING"
        VerdictSafe = "GENUINE / SAFE"
        VerdictSafeDesc = "The system is using a legitimate Windows license and running normally."
        VerdictUnactivated = "UNACTIVATED / SAFE"
        VerdictUnactivatedDesc = "The system is not officially activated but is clean of crack tools."
        VerdictWarning = "WARNING / SUSPICIOUS"
        VerdictWarningDesc = "No direct crack files found, but the system has abnormal configurations or history indicating bypass tool usage."
        VerdictHighRisk = "HIGH RISK (CRACKED / MALICIOUS ACTIVATION)"
        VerdictHighRiskDesc = "Explicit crack files, services, or KMS bypasses (like KMS Emulator or KMS38) were found on this computer."
        VerdictThreatDesc = "Potential Risks: Crack tools (KMSpico, KMSAuto, etc.) often require disabling antivirus, and have a high likelihood of carrying malware (Trojans, Ransomware, Keyloggers, CoinMiners)."
        ReportHeader = "EXPORTING REPORTS"
        ReportSuccessTxt = "Text report successfully exported to"
        ReportSuccessJson = "JSON report successfully exported to"
        ReportErr = "Could not export report files"
        ScanComplete = "Scan completed."
        ReportTitle = "WINDOWS LICENSE & CRACK DETECTION REPORT"
        ReportTime = "Scan Time"
        ReportOSInfo = "1. SYSTEM INFORMATION"
        ReportLicense = "2. LICENSE STATUS"
        ReportKms = "3. KMS CONFIGURATION"
        ReportCrack = "4. DETECTED CRACK INDICATORS"
        ReportHosts = "5. HOSTS FILE ANALYSIS"
        ReportSummary = "Summary"
        NoDetections = "No detections."
        
        # Advanced localization keys
        Kms38Detect = "DETECTED KMS38 ACTIVATION (CRACK): Remaining license time is greater than 180 days ({0} days) for Volume KMS client. This points to a KMS38 activation bypass."
        GvlkKeyWarn = "DETECTED GENERIC GVLK KEY ({0}): The system is using Microsoft's public KMS client key in a Workgroup environment. Likely activated via generic KMS script."
        OhookRegWarn = "DETECTED OHOOK FOOTPRINT (OFFICE/WIN BYPASS): Resiliency registry value '{0}' is set to a distant future date ({1}) to suppress license checks."
        AdvancedHeader = "AUDITING ADVANCED ACTIVATION BYPASSES (KMS38, OHOOK, GVLK)"
        
        # Forensic localization keys
        ForensicHeader = "FORENSIC SYSTEM AUDIT (MAS/HWID ACTIVATION HISTORY)"
        PsHistoryWarn = "DETECTED POWERSHELL EXECUTION HISTORY: The user executed a download and run command for MAS from massgrave/get.activated.win on: {0}. Command executed: '{1}'"
        EventLogWarn = "DETECTED SCRIPT EXECUTION LOGS: PowerShell Event Logs recorded script blocks containing MAS or massgrave keywords: {0} entries found."
        HwidKeyWarn = "DETECTED RETAIL GENERIC HWID KEY ({0}): The active key matches the public MAS HWID key, but does not match the hardware's native BIOS OEM key ({1})."
        HwidGenericWarn = "DETECTED RETAIL GENERIC HWID KEY ({0}): The active key matches the public MAS HWID key, and no native BIOS OEM key is embedded in hardware."
        BiosMsdmFound = "Embedded BIOS OEM key found: {0}"
        BiosMsdmNotFound = "No embedded BIOS OEM key found (This might be a custom-built computer or shipped without pre-activated Windows)."
        
        # Service status check keys
        SvcHeader = "CRITICAL SYSTEM SERVICES AUDIT"
        SvcDisabledWarn = "DETECTED THAT SERVICE '{0}' ({1}) IS DISABLED. This is a strong indicator of system tampering to bypass licensing or block security scans."
        SvcNormal = "Service '{0}' ({1}) status is normal."
        SvcNotFound = "Service '{0}' ({1}) not found on the system."
        SvcPromptEnable = "Do you want to automatically enable and start service '{0}'? (Y/N): "
        SvcEnableSuccess = "Successfully enabled and started service '{0}'."
        SvcEnableFail = "Could not enable or start service '{0}'. Error: {1}"
    }
}

# Lay ra ngon ngu hien tai
$M = $MSG[$lang]

# Hien thi ASCII Art
Write-Host @"
   ____ _  _ ____ ____ _  _    _  _ _ _  _ 
   |    |__| |___ |    |_/     |  | | |\ | 
   |___ |  | |___ |___ | \_    |\/| | | \| 
   ----------------------------------------
            [+] Code by dabeecao
"@ -ForegroundColor Cyan

# Thiet lap bien luu bao cao ket qua
$Report = @{
    ScanTime = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    OSInfo = @{}
    LicenseStatus = @{}
    KmsAnalysis = @{}
    CrackDetections = @()
    HostsFileAnalysis = @{}
    RiskRating = "SAFE" # SAFE, WARNING, HIGH_RISK
    Summary = ""
}

Write-Header $M.HeaderScan

# 2. KIEM TRA QUYEN ADMINISTRATOR
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Warn $M.AdminWarn
} else {
    Write-Success $M.AdminSuccess
}

# 2.5. KIEM TRA DICH VU HE THONG COT LOI (CRITICAL SYSTEM SERVICES AUDIT)
Write-Header $M.SvcHeader

$criticalServices = @(
    @{ Name = "winmgmt"; Desc = "Windows Management Instrumentation (WMI)"; Critical = $true }
    @{ Name = "sppsvc"; Desc = "Software Protection"; Critical = $false }
)

foreach ($svc in $criticalServices) {
    $service = Get-Service -Name $svc.Name -ErrorAction SilentlyContinue
    if ($service) {
        if ($service.StartType -eq "Disabled") {
            $msg = $M.SvcDisabledWarn -f $svc.Name, $svc.Desc
            Write-Danger $msg
            
            $resolved = $false
            if ($isAdmin) {
                $response = Read-Host ($M.SvcPromptEnable -f $svc.Name)
                if ($response -eq "Y" -or $response -eq "y" -or $response -eq "Yes" -or $response -eq "yes") {
                    try {
                        Set-Service -Name $svc.Name -StartupType Automatic -ErrorAction Stop
                        Start-Service -Name $svc.Name -ErrorAction Stop
                        Write-Success ($M.SvcEnableSuccess -f $svc.Name)
                        $resolved = $true
                    } catch {
                        Write-Danger ($M.SvcEnableFail -f $svc.Name, $_.Exception.Message)
                    }
                }
            }
            
            if (-not $resolved) {
                $Report.CrackDetections += @{ 
                    Path = "Service: $($svc.Name)"
                    Target = "$($svc.Desc) is Disabled (Bypass/Tampering Indicator)"
                    Type = "Service" 
                }
            }
        } else {
            Write-Success ($M.SvcNormal -f $svc.Name, $svc.Desc)
        }
    } else {
        Write-Danger ($M.SvcNotFound -f $svc.Name, $svc.Desc)
    }
}

# 3. THU THAP THONG TIN HE DIEU HANH
try {
    $os = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop
    $Report.OSInfo.Caption = $os.Caption
    $Report.OSInfo.Version = $os.Version
    $Report.OSInfo.OSArchitecture = $os.OSArchitecture
    
    # Kiem tra xem may tinh co tham gia Domain (Active Directory) khong
    $computerSystem = Get-CimInstance -ClassName Win32_ComputerSystem
    $partOfDomain = $computerSystem.PartOfDomain
    $Report.OSInfo.PartOfDomain = $partOfDomain
    $Report.OSInfo.Domain = $computerSystem.Domain
    
    Write-Info "$($M.OSName): $($os.Caption) ($($os.OSArchitecture))"
    Write-Info "$($M.OSVersion): $($os.Version)"
    Write-Info "$($M.DomainInfo): $(if($partOfDomain){ $M.Yes + " ($($computerSystem.Domain))" }else{ $M.No + " (Workgroup)" })"
} catch {
    Write-Danger "$($M.OSInfo) Error: $_"
}

# 4. KIEM TRA TRANG THAI BAN QUYEN (WMI / CIM)
Write-Header $M.LicenseHeader
$foundLicense = $false
$isKmsChannel = $false
$gracePeriodMin = 0
$partialKey = ""

try {
    # Windows Application ID co dinh trong SoftwareLicensingProduct
    $windowsAppId = "55c92734-d682-4d71-983e-d6ec3f16059f"
    
    # Tim san pham Windows dang hoat dong
    $products = Get-CimInstance -ClassName SoftwareLicensingProduct -Filter "ApplicationID = '$windowsAppId'" | Where-Object { $_.PartialProductKey }
    
    if ($products) {
        $foundLicense = $true
        # Uu tien lay ban ghi co trang thai Licensed (1), neu khong thi lay ban ghi dau tien
        $activeProduct = $products | Where-Object { $_.LicenseStatus -eq 1 } | Select-Object -First 1
        if (-not $activeProduct) {
            $activeProduct = $products[0]
        }
        
        $statusMap = @{
            0 = if($lang -eq "VI"){"Chua kich hoat (Unlicensed)"}else{"Unlicensed"}
            1 = if($lang -eq "VI"){"Da kich hoat hop le (Licensed)"}else{"Licensed"}
            2 = "OOB Grace"
            3 = "OOT Grace"
            4 = "Non-Genuine Grace"
            5 = "Notification"
            6 = "Extended Grace"
        }
        
        $statusText = $statusMap[[int]$activeProduct.LicenseStatus]
        if (-not $statusText) { $statusText = "Unknown ($($activeProduct.LicenseStatus))" }
        
        $Report.LicenseStatus.Name = $activeProduct.Name
        $Report.LicenseStatus.Description = $activeProduct.Description
        $Report.LicenseStatus.Status = $statusText
        $Report.LicenseStatus.PartialProductKey = $activeProduct.PartialProductKey
        
        $partialKey = $activeProduct.PartialProductKey
        $gracePeriodMin = $activeProduct.GracePeriodRemaining
        
        Write-Info "$($M.ProductName): $($activeProduct.Name)"
        Write-Info "$($M.ProductDesc): $($activeProduct.Description)"
        Write-Info "$($M.ProductKey): *****-*****-*****-****-$partialKey"
        
        if ($activeProduct.LicenseStatus -eq 1) {
            Write-Success "$($M.ActivationStatus): $statusText"
        } else {
            Write-Warn "$($M.ActivationStatus): $statusText"
        }
        
        # Xac dinh Kenh Ban Quyen (License Channel) tu Description
        $channel = "UNKNOWN"
        if ($activeProduct.Description -like "*RETAIL*") {
            $channel = "RETAIL"
        } elseif ($activeProduct.Description -like "*OEM*") {
            $channel = "OEM"
        } elseif ($activeProduct.Description -like "*VOLUME_KMSCLIENT*") {
            $channel = if($lang -eq "VI"){"VOLUME_KMS (Client kich hoat qua KMS)"}else{"VOLUME_KMS (KMS Client Activation)"}
            $isKmsChannel = $true
        } elseif ($activeProduct.Description -like "*VOLUME_MAK*") {
            $channel = if($lang -eq "VI"){"VOLUME_MAK (Volume License khoa vinh vien)"}else{"VOLUME_MAK (Permanent Volume License)"}
        }
        $Report.LicenseStatus.Channel = $channel
        Write-Info "$($M.LicenseChannel): $channel"
        
    } else {
        Write-Warn $M.LicenseNotInstalled
    }
} catch {
    Write-Danger "$($M.LicenseQueryErr): $_"
}

# 5. PHAN TICH CAC PHUONG PHAP BE KHOA NANG CAO (KMS38, OHOOK, GVLK)
Write-Header $M.AdvancedHeader

# A. Kiem tra KMS38 (KMS den nam 2038)
if ($isKmsChannel -and $gracePeriodMin -gt 259200) {
    $graceDays = [Math]::Round($gracePeriodMin / 1440, 0)
    $msg = $M.Kms38Detect -f $graceDays
    Write-Danger $msg
    $Report.CrackDetections += @{ Path = "Windows licensing: GracePeriodRemaining"; Target = "KMS38 Activation Bypass"; Type = "Exploit" }
}

# B. Kiem tra Generic GVLK Keys (KMS key cong khai cua Microsoft)
$gvlks = @{
    "T83GX" = "Windows 10/11 Pro (GVLK)"
    "3GPPG" = "Windows 10/11 Enterprise (GVLK)"
    "6F4BT" = "Windows 10/11 Pro Education (GVLK)"
    "9F84F" = "Windows 10/11 Pro for Workstations (GVLK)"
    "4VH34" = "Windows 10/11 Home (GVLK)"
    "2YT43" = "Windows 7/8 Enterprise (GVLK)"
}

if (-not $partOfDomain -and $partialKey -and $gvlks.ContainsKey($partialKey)) {
    $keyInfo = $gvlks[$partialKey]
    $msg = $M.GvlkKeyWarn -f $keyInfo
    Write-Warn $msg
    $Report.CrackDetections += @{ Path = "ProductKey: PartialKey ($partialKey)"; Target = "Generic GVLK Key ($keyInfo)"; Type = "Configuration" }
}

# C. Kiem tra Registry Ohook cho Office/Windows
$ohookRegFound = $false
$resiliencyPath = "HKCU:\Software\Microsoft\Office\16.0\Common\Licensing\Resiliency"
if (Test-Path $resiliencyPath) {
    $heartbeatVal = (Get-ItemProperty -Path $resiliencyPath -Name "TimeOfLastHeartbeatFailure" -ErrorAction SilentlyContinue).TimeOfLastHeartbeatFailure
    if ($heartbeatVal) {
        if ($heartbeatVal -like "*2038*" -or $heartbeatVal -like "*2040*" -or $heartbeatVal -like "*2050*") {
            $msg = $M.OhookRegWarn -f "TimeOfLastHeartbeatFailure", $heartbeatVal
            Write-Danger $msg
            $Report.CrackDetections += @{ Path = "$resiliencyPath\TimeOfLastHeartbeatFailure"; Target = "Ohook Heartbeat Suppressor"; Type = "Registry" }
            $ohookRegFound = $true
        }
    }
}

if (-not ($isKmsChannel -and $gracePeriodMin -gt 259200) -and -not (-not $partOfDomain -and $partialKey -and $gvlks.ContainsKey($partialKey)) -and -not $ohookRegFound) {
    Write-Success ($(if($lang -eq "VI"){"Khong phat hien dau vet kich hoat nang cao nao (KMS38, Ohook Registry)."}else{"No advanced activation bypasses detected (KMS38, Ohook Registry)."}))
}

# 6. KIEM TRA DAU VET FORENSIC (MAS / HWID ACTIVATION HISTORY)
Write-Header $M.ForensicHeader
$forensicMatches = 0

# A. Kiem tra PowerShell Console History (Lich su go lenh cua nguoi dung)
$historyPath = "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"
if (Test-Path $historyPath) {
    try {
        $historyLines = Get-Content -Path $historyPath -ErrorAction SilentlyContinue
        if ($historyLines) {
            # Tim cac lenh download online MAS quen thuoc
            $masHistory = $historyLines | Where-Object { 
                $_ -like "*get.activated.win*" -or 
                $_ -like "*massgrave*"
            }
            if ($masHistory) {
                $forensicMatches++
                $lastMatch = $masHistory[-1] # Lay lenh cuoi cung gan nhat
                # Lay thoi gian chinh sua file lam thoi gian gan nhat chay lenh
                $lastWriteTime = (Get-Item $historyPath).LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
                $msg = $M.PsHistoryWarn -f $lastWriteTime, $lastMatch
                Write-Danger $msg
                $Report.CrackDetections += @{ Path = $historyPath; Target = "MAS HWID Run History (PowerShell Console History)"; Type = "Forensic" }
            }
        }
    } catch {}
}

# B. Kiem tra Event Logs de tim dau vet chay Script block (PowerShell Event 4104)
if ($isAdmin) {
    try {
        # Tim kiem trong log PowerShell Operational (Event ID 4104) cac tu khoa cua MAS
        $masEvents = Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-PowerShell/Operational';ID=4104} -ErrorAction SilentlyContinue | 
            Where-Object { $_.Message -like "*massgrave*" -or $_.Message -like "*get.activated.win*" -or $_.Message -like "*MAS_AIO*" }
        
        if ($masEvents) {
            $forensicMatches++
            $eventCount = ($masEvents | Measure-Object).Count
            $msg = $M.EventLogWarn -f $eventCount
            Write-Danger $msg
            $Report.CrackDetections += @{ Path = "EventLog: Microsoft-Windows-PowerShell/Operational (ID 4104)"; Target = "PowerShell Execution Event Logs of MAS"; Type = "Forensic" }
        }
    } catch {}
}

# C. Kiem tra so sanh Active Product Key voi khoa OEM BIOS thuc te va Generic HWID Keys
# Lay khoa OEM trong ACPI BIOS (neu co)
$biosKey = $null
try {
    $biosMsdm = Get-CimInstance -Namespace root\wmi -ClassName MsAcpi_MsdmtblReceiver -ErrorAction SilentlyContinue
    if ($biosMsdm) {
        $rawSelData = $biosMsdm.RawSelData
        # Chuyen chuoi byte sang Text lay Product Key
        $biosKey = [System.Text.Encoding]::ASCII.GetString($rawSelData[56..84])
        if ($biosKey -match '^[A-Z0-9]{5}-[A-Z0-9]{5}-[A-Z0-9]{5}-[A-Z0-9]{5}-[A-Z0-9]{5}$') {
            Write-Info ($M.BiosMsdmFound -f $biosKey)
        } else {
            $biosKey = $null
        }
    }
} catch {}

if ($null -eq $biosKey) {
    Write-Info $M.BiosMsdmNotFound
}

# Danh sach các khoa Retail Generic HWID dung de lay ban quyen so qua MAS
$genericHwids = @{
    "DK7XB" = "Windows 10/11 Pro (Generic HWID Key)"
    "8HVX7" = "Windows 10/11 Home (Generic HWID Key)"
    "8DEC2" = "Windows 10/11 Enterprise (Generic HWID Key)"
    "QPF8P" = "Windows 10/11 Pro Education (Generic HWID Key)"
    "3V66T" = "Windows 10/11 Education (Generic HWID Key)"
}

if ($partialKey -and $genericHwids.ContainsKey($partialKey)) {
    $genericInfo = $genericHwids[$partialKey]
    $forensicMatches++
    
    if ($biosKey) {
        $msg = $M.HwidKeyWarn -f $genericInfo, $biosKey
        Write-Danger $msg
        $Report.CrackDetections += @{ Path = "Registry / WMI: Active Key ($partialKey) vs BIOS Key"; Target = "Active Key discrepancy (MAS HWID Indicator)"; Type = "Forensic" }
    } else {
        $msg = $M.HwidGenericWarn -f $genericInfo
        Write-Warn $msg
        $Report.CrackDetections += @{ Path = "Registry / WMI: Active Key ($partialKey)"; Target = "Active Generic HWID Key"; Type = "Forensic" }
    }
}

if ($forensicMatches -eq 0) {
    Write-Success ($(if($lang -eq "VI"){"Khong tim thay dau vet forensic nao ve viec chay MAS HWID."}else{"No forensic traces of MAS HWID execution found."}))
}

# 7. PHAN TICH CAU HINH MAY CHU KMS
Write-Header $M.KmsHeader

# Danh sach các KMS Host crack cong cong pho bien
$publicKmsHosts = @(
    "kms.digiboy.ir", "kms.lotro.cc", "kms8.msguides.com", "kms9.msguides.com",
    "zh.us.to", "kms.chinancce.com", "kms.cangshui.net", "kms.srv.crnet.co",
    "kms.library.hk", "kms.xspace.in", "kms.shuax.com", "kms.loli.best",
    "kms.pub", "kms.agwebs.com", "kms.bige0.com", "kms.catnet.link",
    "ukms.cc", "kms.03k.org", "kms.v0v.bid", "kms.tty.so",
    "kms.jm33.me", "kms.cx"
)

try {
    $licensingService = Get-CimInstance -ClassName SoftwareLicensingService
    $kmsHost = $licensingService.KeyManagementServiceName
    $kmsPort = $licensingService.KeyManagementServicePort
    
    # Doc them tu registry de phong ngua WMI cache cu
    $regKmsHost = $null
    $regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform"
    if (Test-Path $regPath) {
        $regKmsHost = (Get-ItemProperty -Path $regPath -Name "KeyManagementServiceName" -ErrorAction SilentlyContinue).KeyManagementServiceName
    }
    
    if (-not $kmsHost -and $regKmsHost) {
        $kmsHost = $regKmsHost
    }
    
    if ($kmsHost) {
        $Report.KmsAnalysis.Host = $kmsHost
        $Report.KmsAnalysis.Port = $kmsPort
        Write-Info "$($M.KmsConfig): $kmsHost (Port: $kmsPort)"
        
        # PHAN TICH RUI RO KMS
        $kmsRisk = "SAFE"
        $kmsReason = ""
        
        # TH1: Tro ve Localhost
        if ($kmsHost -eq "127.0.0.1" -or $kmsHost -eq "::1" -or $kmsHost.ToLower() -eq "localhost") {
            $kmsRisk = "CRACKED"
            $kmsReason = $M.KmsEmulatorWarn
            Write-Danger $kmsReason
        }
        # TH2: Tro ve KMS lau cong cong tren Internet
        else {
            foreach ($badHost in $publicKmsHosts) {
                if ($kmsHost.ToLower() -like "*$badHost*") {
                    $kmsRisk = "CRACKED"
                    $kmsReason = $M.KmsPublicWarn -f $kmsHost
                    Write-Danger $kmsReason
                    break
                }
            }
        }
        
        # TH3: IP noi bo nhung may la Workgroup
        if ($kmsRisk -ne "CRACKED" -and -not $partOfDomain) {
            if ($kmsHost -match '^(10\.\d+\.\d+\.\d+|192\.168\.\d+\.\d+|172\.(1[6-9]|2\d|3[0-1])\.\d+\.\d+)$') {
                $kmsRisk = "SUSPICIOUS"
                $kmsReason = $M.KmsPrivateWarn -f $kmsHost
                Write-Warn $kmsReason
            } else {
                $kmsRisk = "SUSPICIOUS"
                $kmsReason = $M.KmsWorkgroupWarn -f $kmsHost
                Write-Warn $kmsReason
            }
        }
        
        $Report.KmsAnalysis.Risk = $kmsRisk
        $Report.KmsAnalysis.Reason = $kmsReason
        
        if ($kmsRisk -eq "SAFE") {
            Write-Success $M.KmsSafe
        }
    } else {
        $Report.KmsAnalysis.Host = "None"
        Write-Info $M.KmsNoManual
    }
} catch {
    Write-Warn "$($M.KmsQueryErr): $_"
}

# 8. QUET FILE VÀ THU MUC CUA CAC TOOL CRACK PHO BIEN
Write-Header $M.FileHeader

$suspiciousItems = @(
    # KMSpico
    @{ Path = "$env:SystemRoot\SECOH-QAD.exe"; Tool = "KMSpico / KMSAuto (Malicious Activation Component)"; Type = "File" },
    @{ Path = "$env:SystemRoot\SECOH-QAD.dll"; Tool = "KMSpico (Malicious DLL)"; Type = "File" },
    @{ Path = "$env:SystemDrive\Program Files\KMSpico\KMSpico.exe"; Tool = "KMSpico (Main Activator)"; Type = "File" },
    @{ Path = "$env:SystemDrive\Program Files (x86)\KMSpico\KMSpico.exe"; Tool = "KMSpico (Main Activator)"; Type = "File" },
    @{ Path = "$env:SystemDrive\Program Files\KMSpico\AutoPico.exe"; Tool = "KMSpico (Auto Daemon)"; Type = "File" },
    @{ Path = "$env:SystemDrive\Program Files (x86)\KMSpico\AutoPico.exe"; Tool = "KMSpico (Auto Daemon)"; Type = "File" },
    @{ Path = "$env:SystemDrive\Program Files\KMSpico"; Tool = "KMSpico (Installation Folder)"; Type = "Folder" },
    @{ Path = "$env:SystemDrive\Program Files (x86)\KMSpico"; Tool = "KMSpico (Installation Folder)"; Type = "Folder" },
    
    # KMSAuto
    @{ Path = "$env:SystemRoot\AutoKMS\AutoKMS.exe"; Tool = "AutoKMS / KMSAuto (Background Activation Engine)"; Type = "File" },
    @{ Path = "$env:SystemRoot\AutoKMS\AutoKMS.log"; Tool = "AutoKMS (Logs)"; Type = "File" },
    @{ Path = "$env:SystemRoot\AutoKMS"; Tool = "AutoKMS (Engine Folder)"; Type = "Folder" },
    @{ Path = "$env:ProgramData\KMSAuto"; Tool = "KMSAuto (Data Folder)"; Type = "Folder" },
    @{ Path = "$env:ProgramData\KMSAutoS"; Tool = "KMSAutoS (Data Folder)"; Type = "Folder" },
    @{ Path = "$env:ProgramData\KMSAutoNet"; Tool = "KMSAuto Net (Data Folder)"; Type = "Folder" },
    
    # Microsoft Activation Scripts (MAS)
    @{ Path = "$env:SystemRoot\Setup\Scripts\SetupComplete.cmd"; Tool = "MAS / Auto-Activation Script (SetupComplete)"; Type = "File" },
    @{ Path = "$env:SystemRoot\Setup\Scripts\Activate.cmd"; Tool = "Auto-Activation Script"; Type = "File" }
)

# Quet phat hien Ohook
$officePaths = @(
    "$env:SystemDrive\Program Files\Microsoft Office\root\Office16\sppc.dll",
    "$env:SystemDrive\Program Files (x86)\Microsoft Office\root\Office16\sppc.dll",
    "$env:SystemDrive\Program Files\Microsoft Office\root\Office16\sppcs.dll",
    "$env:SystemDrive\Program Files (x86)\Microsoft Office\root\Office16\sppcs.dll",
    "$env:SystemDrive\Program Files\Microsoft Office\root\vfs\System\sppc.dll",
    "$env:SystemDrive\Program Files (x86)\Microsoft Office\root\vfs\System\sppc.dll",
    "$env:SystemDrive\Program Files\Microsoft Office\root\vfs\System\sppcs.dll",
    "$env:SystemDrive\Program Files (x86)\Microsoft Office\root\vfs\System\sppcs.dll"
)
foreach ($op in $officePaths) {
    $suspiciousItems += @{ Path = $op; Tool = "Ohook (Office/Windows License Bypass)"; Type = "File" }
}

$detectedFiles = 0
foreach ($item in $suspiciousItems) {
    $path = $item.Path
    $tool = $item.Tool
    $type = $item.Type
    
    if ($type -eq "File" -and (Test-Path $path -PathType Leaf)) {
        $detectedFiles++
        $msg = $M.FileFound -f $tool, $path
        Write-Danger $msg
        $Report.CrackDetections += @{ Path = $path; Target = $tool; Type = "File" }
    }
    elseif ($type -eq "Folder" -and (Test-Path $path -PathType Container)) {
        $detectedFiles++
        $msg = $M.FolderFound -f $tool, $path
        Write-Danger $msg
        $Report.CrackDetections += @{ Path = $path; Target = $tool; Type = "Folder" }
    }
}

if ($detectedFiles -eq 0) {
    Write-Success $M.NoFilesFound
}

# 9. KIEM TRA WINDOWS SERVICES LIEN QUAN DEN CRACK
Write-Header $M.ServiceHeader
$detectedServices = 0
if ($isAdmin) {
    $kmsServices = @("AutoKMS", "KMSpico Service", "KMSConnectionMonitor", "Service_KMS")
    foreach ($srvName in $kmsServices) {
        $srv = Get-Service -Name $srvName -ErrorAction SilentlyContinue
        if ($srv) {
            $detectedServices++
            $msg = $M.ServiceFound -f $srv.Name, $srv.DisplayName, $srv.Status
            Write-Danger $msg
            $Report.CrackDetections += @{ Path = "Service: $($srv.Name)"; Target = "KMS Emulator Service"; Type = "Service" }
        }
    }
} else {
    Write-Info $M.ServiceSkip
}

if ($detectedServices -eq 0 -and $isAdmin) {
    Write-Success $M.NoServicesFound
}

# 10. KIEM TRA TASK SCHEDULER
Write-Header $M.TaskHeader
$detectedTasks = 0
if ($isAdmin) {
    $kmsTaskNames = @("AutoKMS", "KMSAuto", "KMSAutoNet", "KMSpico", "KMSConnectionMonitor")
    try {
        $allTasks = Get-ScheduledTask -ErrorAction SilentlyContinue
        foreach ($task in $allTasks) {
            $match = $false
            foreach ($name in $kmsTaskNames) {
                if ($task.TaskName -like "*$name*") {
                    $match = $true
                    break
                }
            }
            if (-not $match) {
                foreach ($action in $task.Actions) {
                    if ($action.Execute -like "*AutoKMS*" -or $action.Execute -like "*SECOH-QAD*" -or $action.Execute -like "*AutoPico*") {
                        $match = $true
                        break
                    }
                }
            }
            
            if ($match) {
                $detectedTasks++
                $msg = $M.TaskFound -f "$($task.TaskPath)$($task.TaskName)", $task.State
                Write-Danger $msg
                $Report.CrackDetections += @{ Path = "$($task.TaskPath)$($task.TaskName)"; Target = "Scheduled Task Auto-Reactivation"; Type = "Task" }
            }
        }
    } catch {
        Write-Warn "$($M.TaskErr): $_"
    }
} else {
    Write-Info $M.TaskSkip
}

if ($detectedTasks -eq 0 -and $isAdmin) {
    Write-Success $M.NoTasksFound
}

# 11. KIEM TRA FILE HOSTS
Write-Header $M.HostsHeader
$hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
$Report.HostsFileAnalysis.Path = $hostsPath
$Report.HostsFileAnalysis.RedirectsFound = @()

if (Test-Path $hostsPath) {
    try {
        $hostsLines = Get-Content -Path $hostsPath
        $suspiciousHosts = @("microsoft", "kms.windows.com", "kms.microsoft.com", "activation.microsoft.com", "validation.microsoft.com")
        $foundRedirects = 0
        
        foreach ($line in $hostsLines) {
            $cleanLine = $line.Trim()
            if ($cleanLine -like "#*" -or $cleanLine -eq "") {
                continue
            }
            
            foreach ($sh in $suspiciousHosts) {
                if ($cleanLine -like "*$sh*") {
                    $foundRedirects++
                    Write-Danger ($M.HostsFound -f $cleanLine)
                    $Report.HostsFileAnalysis.RedirectsFound += $cleanLine
                    break
                }
            }
        }
        
        if ($foundRedirects -eq 0) {
            Write-Success $M.HostsClean
        }
    } catch {
        Write-Warn "$($M.HostsErr): $_"
    }
} else {
    Write-Warn $M.HostsNotFound
}

# 12. KET LUAN DANG GIA MUC DO RUI RO
Write-Header $M.VerdictHeader

$hasCrackArtifacts = $Report.CrackDetections.Count -gt 0
$kmsIsCracked = $Report.KmsAnalysis.Risk -eq "CRACKED"
$kmsIsSuspicious = $Report.KmsAnalysis.Risk -eq "SUSPICIOUS"
$hasHostsRedirects = $Report.HostsFileAnalysis.RedirectsFound.Count -gt 0

# Tinh toan muc do
if ($hasCrackArtifacts -or $kmsIsCracked) {
    $Report.RiskRating = "HIGH_RISK"
    $Report.Summary = $M.VerdictHighRiskDesc
    Write-Host "`n$($M.VerdictTitle): $($M.VerdictHighRisk)" -ForegroundColor Red -BackgroundColor Black
    Write-Danger $M.VerdictHighRiskDesc
    Write-Danger $M.VerdictThreatDesc
}
elseif ($kmsIsSuspicious -or $hasHostsRedirects) {
    $Report.RiskRating = "WARNING"
    $Report.Summary = $M.VerdictWarningDesc
    Write-Host "`n$($M.VerdictTitle): $($M.VerdictWarning)" -ForegroundColor Yellow -BackgroundColor Black
    Write-Warn $M.VerdictWarningDesc
}
else {
    $Report.RiskRating = "SAFE"
    if ($Report.LicenseStatus.Status -like "*Licensed*") {
        $Report.Summary = $M.VerdictSafeDesc
        Write-Host "`n$($M.VerdictTitle): $($M.VerdictSafe)" -ForegroundColor Green -BackgroundColor Black
        Write-Success $M.VerdictSafeDesc
    } else {
        $Report.Summary = $M.VerdictUnactivatedDesc
        Write-Host "`n$($M.VerdictTitle): $($M.VerdictUnactivated)" -ForegroundColor Yellow -BackgroundColor Black
        Write-Info $M.VerdictUnactivatedDesc
    }
}

# 13. XUAT FILE BAO CAO
Write-Header $M.ReportHeader
$reportDir = $PSScriptRoot
if (-not $reportDir) {
    $reportDir = $PWD.Path
}
$exportTxtPath = Join-Path $reportDir "Windows_License_Scan_Report.txt"
$exportJsonPath = Join-Path $reportDir "Windows_License_Scan_Report.json"

try {
    $txtContent = @"
==================================================
$($M.ReportTitle)
==================================================
$($M.ReportTime): $($Report.ScanTime)
$($M.VerdictTitle): $($Report.RiskRating)
$($M.ReportSummary): $($Report.Summary)

$($M.ReportOSInfo):
- $($M.OSName): $($Report.OSInfo.Caption)
- $($M.OSVersion): $($Report.OSInfo.Version)
- $($M.DomainInfo): $(if($Report.OSInfo.PartOfDomain){ $M.Yes + " ($($Report.OSInfo.Domain))" }else{ $M.No + " (Workgroup)" })

$($M.ReportLicense):
- Name: $($Report.LicenseStatus.Name)
- Description: $($Report.LicenseStatus.Description)
- Status: $($Report.LicenseStatus.Status)
- Channel: $($Report.LicenseStatus.Channel)
- Product Key (Last 5): *****-*****-*****-****-$($Report.LicenseStatus.PartialProductKey)

$($M.ReportKms):
- KMS Host: $($Report.KmsAnalysis.Host)
- Port: $($Report.KmsAnalysis.Port)
- KMS Risk Rating: $($Report.KmsAnalysis.Risk)
- Reason: $($Report.KmsAnalysis.Reason)

$($M.ReportCrack) ($($Report.CrackDetections.Count)):
$(if ($Report.CrackDetections.Count -eq 0) { $M.NoDetections } else {
    $Report.CrackDetections | ForEach-Object { "- [$($_.Type)] Path: $($_.Path) -> Target: $($_.Target)" } | Out-String
})
$($M.ReportHosts):
- Path: $($Report.HostsFileAnalysis.Path)
- Redirects: $(if($Report.HostsFileAnalysis.RedirectsFound.Count -eq 0){ $M.NoDetections }else{
    $Report.HostsFileAnalysis.RedirectsFound | Out-String
})
==================================================
Report generated automatically by check-activation.ps1
"@

    $txtContent | Out-File -FilePath $exportTxtPath -Encoding UTF8 -Force
    Write-Success "$($M.ReportSuccessTxt): $exportTxtPath"
    
    $Report | ConvertTo-Json -Depth 4 | Out-File -FilePath $exportJsonPath -Encoding UTF8 -Force
    Write-Success "$($M.ReportSuccessJson): $exportJsonPath"
} catch {
    Write-Warn "$($M.ReportErr): $_"
}

Write-Host "`n$($M.ScanComplete)" -ForegroundColor Cyan
