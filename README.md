# Windows License & Crack Detector (CHECK-WIN)

Bilingual / Song ngữ: [Tiếng Việt](#tiếng-việt) | [English](#english)

---

## Tiếng Việt

CHECK-WIN là một công cụ phân tích an toàn hệ thống dạng script PowerShell. Công cụ giúp kiểm tra chi tiết trạng thái bản quyền hệ điều hành Windows, đồng thời phát hiện các nguy cơ, dấu vết của các công cụ bẻ khóa (crack) phổ biến như KMSpico, KMSAuto, hoặc Microsoft Activation Scripts (MAS - bao gồm HWID, KMS38, Ohook).

### Cách chạy từ xa nhanh nhất (Khuyên dùng)
Bạn không cần tải file thủ công. Chỉ cần mở PowerShell bằng quyền Administrator (Run as Administrator) và chạy câu lệnh duy nhất sau để thực thi trực tiếp từ bộ nhớ RAM:

```powershell
irm -useb https://raw.githubusercontent.com/dabeecao/Check-Win/main/check-activation.ps1 | iex
```

---

### Các tính năng kiểm tra chi tiết

| Hạng mục quét | Phương pháp & Mục tiêu phát hiện |
| :--- | :--- |
| **Trạng thái Bản quyền** | Truy vấn lớp SoftwareLicensingProduct để lấy phiên bản OS, Activation Status và phân tích Kênh bản quyền (OEM, Retail, Volume). |
| **Phát hiện KMS38** | Đo lường thời gian hiệu lực còn lại. Nếu kênh Volume KMS nhưng hạn dùng kéo dài hàng năm (thường đến năm 2038), hệ thống sẽ cảnh báo **KMS38 Crack**. |
| **Đối chiếu Khóa GVLK** | Phát hiện các máy tính thuộc Workgroup (không tham gia AD doanh nghiệp) nhưng cài đặt khóa KMS GVLK mặc định của Microsoft. |
| **ACPI BIOS OEM Audit** | Trích xuất khóa OEM gốc nhúng trong bo mạch chủ và so sánh chéo với khóa đang chạy để phát hiện hành vi lách luật lấy bản quyền số (MAS HWID). |
| **Dấu vết Forensic** | Quét lịch sử dòng lệnh PowerShell (ConsoleHost_history.txt) và Event Logs (Event ID 4104) để tìm dấu vết chạy script bẻ khóa trực tuyến. |
| **File & Dịch vụ Hệ thống** | Phát hiện tệp tin, thư mục và dịch vụ chạy ngầm của KMSpico, KMSAuto (AutoKMS, SECOH-QAD, v.v.) và Ohook (sppc.dll lách bản quyền Office). |
| **Phân tích file Hosts** | Tìm kiếm cấu hình chặn hoặc chuyển hướng máy chủ kích hoạt bản quyền của Microsoft. |

> [!IMPORTANT]
> **Yêu cầu quyền Administrator**: Script cần được khởi chạy dưới quyền Administrator để có thể đọc các khóa Registry hệ thống, Task Scheduler và Event Logs một cách chính xác nhất.

---

### Hướng dẫn chạy Offline (Tải file cục bộ)
1. Mở PowerShell bằng quyền Administrator.
2. Cho phép thực thi script tạm thời:
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force
   ```
3. Di chuyển tới thư mục chứa file check-activation.ps1 và khởi chạy:
   ```powershell
   .\check-activation.ps1
   ```

---

### Báo cáo kết quả xuất ra
Sau khi hoàn tất quá trình quét, công cụ sẽ tự động xuất ra 2 tệp báo cáo ngay tại thư mục hiện hành:
*   Windows_License_Scan_Report.txt: Báo cáo chi tiết dạng văn bản dễ đọc dành cho kỹ thuật viên.
*   Windows_License_Scan_Report.json: Báo cáo dạng dữ liệu có cấu trúc phục vụ phân tích tự động hoặc tích hợp hệ thống giám sát.

---

## English

CHECK-WIN is a lightweight, agentless PowerShell security auditing tool. It analyzes Windows licensing status and detects footprints, indicators, or security risks associated with activation bypass tools (cracks) like KMSpico, KMSAuto, or Microsoft Activation Scripts (MAS - including HWID, KMS38, and Ohook).

### One-Line Remote Execution (Recommended)
You do not need to download any files manually. Simply open PowerShell as Administrator and execute the following command to download and run the script directly in memory:

```powershell
irm -useb https://raw.githubusercontent.com/dabeecao/Check-Win/main/check-activation.ps1 | iex
```

---

### Core Auditing Capabilities

| Audit Module | Detection Method & Target |
| :--- | :--- |
| **License Status** | Queries SoftwareLicensingProduct WMI class to get OS edition, activation state, and analyze the license channel (OEM, Retail, Volume). |
| **KMS38 Detection** | Measures remaining license duration. If a KMS client's grace period exceeds the standard 180-day limit, it flags it as **KMS38 Bypass**. |
| **GVLK Key Verification** | Detects Microsoft's public generic volume keys on non-domain (Workgroup) machines. |
| **ACPI BIOS OEM Comparison** | Reads the native motherboard OEM key and compares it against the active key to detect digital license spoofing (MAS HWID). |
| **Forensic Trace Scan** | Audits PowerShell execution history (ConsoleHost_history.txt) and Event Logs (Event ID 4104 - Script Block Logging) for indicators of remote activation scripts. |
| **File & Service Scan** | Scans for residual files, folders, and background services left by KMSpico, KMSAuto (AutoKMS, SECOH-QAD, etc.) and Ohook (modified sppc.dll). |
| **Hosts File Audit** | Inspects the hosts file for blocks or redirects targeting official Microsoft activation servers. |

> [!IMPORTANT]
> **Administrator Privileges Required**: Running as Administrator is required to access system event logs, tasks, and protected registry hives.

---

### Local Offline Execution
1. Open PowerShell as Administrator.
2. Allow script execution for the current session:
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force
   ```
3. Navigate to the script directory and run:
   ```powershell
   .\check-activation.ps1
   ```

---

### Exported Reports
Once the scan completes, the tool automatically generates 2 report files in your active working directory:
*   Windows_License_Scan_Report.txt: A detailed text report for system administrators.
*   Windows_License_Scan_Report.json: A structured JSON report suitable for SIEM ingestion or automated analysis.

---

### Author / Tác giả
*   **Code by dabeecao**
