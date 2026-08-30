#include <windows.h>
#include <shlobj.h>
#include <shellapi.h>

#include <filesystem>
#include <fstream>
#include <string>

namespace fs = std::filesystem;

namespace {

constexpr int IDC_INSTALL = 1001;
constexpr int IDC_CANCEL = 1002;
constexpr int IDC_BROWSE = 1003;
constexpr int IDC_DESKTOP = 1004;

HWND g_installPath = nullptr;
HWND g_desktopShortcut = nullptr;

const wchar_t* kAppName = L"f.Tintia";
const wchar_t* kExecutable = L"f_tintia.exe";

std::wstring GetInstallerDirectory() {
    wchar_t path[MAX_PATH];

    GetModuleFileNameW(
        nullptr,
        path,
        MAX_PATH
    );

    fs::path installerPath(path);

    return installerPath
        .parent_path()
        .wstring();
}

std::wstring GetDefaultInstallPath() {
    wchar_t programFiles[MAX_PATH];

    if (SHGetFolderPathW(
            nullptr,
            CSIDL_PROGRAM_FILES,
            nullptr,
            SHGFP_TYPE_CURRENT,
            programFiles) == S_OK) {
        return std::wstring(programFiles)
            + L"\\f.Tintia";
    }

    return L"C:\\Program Files\\f.Tintia";
}

void SetStatus(HWND window, const std::wstring& text) {
    SetWindowTextW(
        window,
        text.c_str()
    );
}

bool CopyDirectory(
    const fs::path& source,
    const fs::path& destination
) {
    try {
        if (!fs::exists(source)) {
            return false;
        }

        fs::create_directories(destination);

        for (const auto& entry :
             fs::recursive_directory_iterator(source)) {

            const auto relative =
                fs::relative(
                    entry.path(),
                    source
                );

            const auto target =
                destination / relative;

            if (entry.is_directory()) {
                fs::create_directories(
                    target
                );
            } else if (entry.is_regular_file()) {
                fs::create_directories(
                    target.parent_path()
                );

                fs::copy_file(
                    entry.path(),
                    target,
                    fs::copy_options::overwrite_existing
                );
            }
        }

        return true;
    } catch (...) {
        return false;
    }
}

bool CreateShortcut(
    const std::wstring& target,
    const std::wstring& shortcut,
    const std::wstring& description
) {
    IShellLinkW* shellLink = nullptr;

    HRESULT result =
        CoCreateInstance(
            CLSID_ShellLink,
            nullptr,
            CLSCTX_INPROC_SERVER,
            IID_IShellLinkW,
            reinterpret_cast<void**>(
                &shellLink
            )
        );

    if (FAILED(result)) {
        return false;
    }

    shellLink->SetPath(
        target.c_str()
    );

    shellLink->SetDescription(
        description.c_str()
    );

    IPersistFile* persistFile = nullptr;

    result =
        shellLink->QueryInterface(
            IID_IPersistFile,
            reinterpret_cast<void**>(
                &persistFile
            )
        );

    if (SUCCEEDED(result)) {
        result =
            persistFile->Save(
                shortcut.c_str(),
                TRUE
            );

        persistFile->Release();
    }

    shellLink->Release();

    return SUCCEEDED(result);
}

bool CreateUninstallEntry(
    const std::wstring& installPath
) {
    HKEY key = nullptr;

    const wchar_t* subKey =
        L"Software\\Microsoft\\Windows\\CurrentVersion"
        L"\\Uninstall\\f.Tintia";

    LONG result =
        RegCreateKeyExW(
            HKEY_CURRENT_USER,
            subKey,
            0,
            nullptr,
            0,
            KEY_WRITE,
            nullptr,
            &key,
            nullptr
        );

    if (result != ERROR_SUCCESS) {
        return false;
    }

    const std::wstring uninstallPath =
        installPath +
        L"\\uninstall.exe";

    const std::wstring displayIcon =
        installPath +
        L"\\f_tintia.exe";

    RegSetValueExW(
        key,
        L"DisplayName",
        0,
        REG_SZ,
        reinterpret_cast<const BYTE*>(
            kAppName
        ),
        static_cast<DWORD>(
            (wcslen(kAppName) + 1) *
            sizeof(wchar_t)
        )
    );

    RegSetValueExW(
        key,
        L"DisplayVersion",
        0,
        REG_SZ,
        reinterpret_cast<const BYTE*>(
            L"1.0.0"
        ),
        static_cast<DWORD>(
            (wcslen(L"1.1.5") + 1) *
            sizeof(wchar_t)
        )
    );

    RegSetValueExW(
        key,
        L"InstallLocation",
        0,
        REG_SZ,
        reinterpret_cast<const BYTE*>(
            installPath.c_str()
        ),
        static_cast<DWORD>(
            (installPath.size() + 1) *
            sizeof(wchar_t)
        )
    );

    RegSetValueExW(
        key,
        L"DisplayIcon",
        0,
        REG_SZ,
        reinterpret_cast<const BYTE*>(
            displayIcon.c_str()
        ),
        static_cast<DWORD>(
            (displayIcon.size() + 1) *
            sizeof(wchar_t)
        )
    );

    RegSetValueExW(
        key,
        L"Publisher",
        0,
        REG_SZ,
        reinterpret_cast<const BYTE*>(
            L"Flakesoft"
        ),
        static_cast<DWORD>(
            (wcslen(L"Flakesoft") + 1) *
            sizeof(wchar_t)
        )
    );

    RegSetValueExW(
        key,
        L"UninstallString",
        0,
        REG_SZ,
        reinterpret_cast<const BYTE*>(
            uninstallPath.c_str()
        ),
        static_cast<DWORD>(
            (uninstallPath.size() + 1) *
            sizeof(wchar_t)
        )
    );

    RegCloseKey(key);

    return true;
}

void Install(HWND window) {
    wchar_t path[MAX_PATH];

    GetWindowTextW(
        g_installPath,
        path,
        MAX_PATH
    );

    const fs::path destination(path);

    const fs::path installerDirectory =
        GetInstallerDirectory();

    const fs::path payload =
        installerDirectory / L"payload";

    if (!fs::exists(payload)) {
        MessageBoxW(
            window,
            L"Installation files could not be found.",
            kAppName,
            MB_ICONERROR
        );

        return;
    }

    SetStatus(
        window,
        L"Installing f.Tintia..."
    );

    if (!CopyDirectory(
            payload,
            destination)) {

        MessageBoxW(
            window,
            L"f.Tintia could not be installed.",
            kAppName,
            MB_ICONERROR
        );

        SetStatus(
            window,
            L"Installation failed."
        );

        return;
    }

    const fs::path executable =
        destination / kExecutable;

    const fs::path startMenu =
        fs::path(
            _wgetenv(L"APPDATA")
        ) /
        L"Microsoft\\Windows\\Start Menu"
        L"\\Programs";

    fs::create_directories(
        startMenu
    );

    CreateShortcut(
        executable.wstring(),
        (
            startMenu /
            L"f.Tintia.lnk"
        ).wstring(),
        L"f.Tintia color picker"
    );

    if (SendMessageW(
            g_desktopShortcut,
            BM_GETCHECK,
            0,
            0
        ) == BST_CHECKED) {

        const fs::path desktop =
            fs::path(
                _wgetenv(L"USERPROFILE")
            ) /
            L"Desktop";

        CreateShortcut(
            executable.wstring(),
            (
                desktop /
                L"f.Tintia.lnk"
            ).wstring(),
            L"f.Tintia color picker"
        );
    }

    CreateUninstallEntry(
        destination.wstring()
    );

    SetStatus(
        window,
        L"Installation complete."
    );

    const int result =
        MessageBoxW(
            window,
            L"f.Tintia has been installed successfully.\n\n"
            L"Would you like to launch it now?",
            kAppName,
            MB_ICONINFORMATION |
            MB_YESNO
        );

    if (result == IDYES) {
        ShellExecuteW(
            nullptr,
            L"open",
            executable.c_str(),
            nullptr,
            nullptr,
            SW_SHOWNORMAL
        );
    }

    PostQuitMessage(0);
}

LRESULT CALLBACK WindowProc(
    HWND window,
    UINT message,
    WPARAM wParam,
    LPARAM lParam
) {
    switch (message) {

    case WM_CREATE: {
        HFONT font =
            CreateFontW(
                18,
                0,
                0,
                0,
                FW_NORMAL,
                FALSE,
                FALSE,
                FALSE,
                DEFAULT_CHARSET,
                OUT_DEFAULT_PRECIS,
                CLIP_DEFAULT_PRECIS,
                DEFAULT_QUALITY,
                DEFAULT_PITCH | FF_DONTCARE,
                L"Segoe UI"
            );

        HWND title =
            CreateWindowW(
                L"STATIC",
                L"f.Tintia",
                WS_VISIBLE |
                WS_CHILD,
                32,
                24,
                500,
                40,
                window,
                nullptr,
                nullptr,
                nullptr
            );

        SendMessageW(
            title,
            WM_SETFONT,
            reinterpret_cast<WPARAM>(font),
            TRUE
        );

        HWND description =
            CreateWindowW(
                L"STATIC",
                L"Install f.Tintia on your computer.",
                WS_VISIBLE |
                WS_CHILD,
                32,
                68,
                500,
                30,
                window,
                nullptr,
                nullptr,
                nullptr
            );

        SendMessageW(
            description,
            WM_SETFONT,
            reinterpret_cast<WPARAM>(font),
            TRUE
        );

        CreateWindowW(
            L"STATIC",
            L"Installation location:",
            WS_VISIBLE |
            WS_CHILD,
            32,
            120,
            300,
            24,
            window,
            nullptr,
            nullptr,
            nullptr
        );

        g_installPath =
            CreateWindowExW(
                WS_EX_CLIENTEDGE,
                L"EDIT",
                GetDefaultInstallPath().c_str(),
                WS_VISIBLE |
                WS_CHILD |
                ES_AUTOHSCROLL,
                32,
                150,
                470,
                30,
                window,
                nullptr,
                nullptr,
                nullptr
            );

        g_desktopShortcut =
            CreateWindowW(
                L"BUTTON",
                L"Create desktop shortcut",
                WS_VISIBLE |
                WS_CHILD |
                BS_AUTOCHECKBOX,
                32,
                200,
                260,
                30,
                window,
                reinterpret_cast<HMENU>(
                    IDC_DESKTOP
                ),
                nullptr,
                nullptr
            );

        SendMessageW(
            g_desktopShortcut,
            BM_SETCHECK,
            BST_CHECKED,
            0
        );

        CreateWindowW(
            L"BUTTON",
            L"Install",
            WS_VISIBLE |
            WS_CHILD |
            BS_DEFPUSHBUTTON,
            330,
            260,
            170,
            40,
            window,
            reinterpret_cast<HMENU>(
                IDC_INSTALL
            ),
            nullptr,
            nullptr
        );

        CreateWindowW(
            L"BUTTON",
            L"Cancel",
            WS_VISIBLE |
            WS_CHILD,
            210,
            260,
            100,
            40,
            window,
            reinterpret_cast<HMENU>(
                IDC_CANCEL
            ),
            nullptr,
            nullptr
        );

        break;
    }

    case WM_COMMAND:
        switch (LOWORD(wParam)) {

        case IDC_INSTALL:
            Install(window);
            break;

        case IDC_CANCEL:
            DestroyWindow(window);
            break;
        }

        break;

    case WM_DESTROY:
        PostQuitMessage(0);
        break;

    default:
        return DefWindowProcW(
            window,
            message,
            wParam,
            lParam
        );
    }

    return 0;
}

} // namespace

int WINAPI wWinMain(
    HINSTANCE instance,
    HINSTANCE,
    PWSTR,
    int showCommand
) {
    if (FAILED(
            CoInitializeEx(
                nullptr,
                COINIT_APARTMENTTHREADED
            )
        )) {
        return 1;
    }

    const wchar_t className[] =
        L"fTintiaInstallerWindow";

    WNDCLASSW windowClass{};

    windowClass.lpfnWndProc =
        WindowProc;

    windowClass.hInstance =
        instance;

    windowClass.lpszClassName =
        className;

    windowClass.hCursor =
        LoadCursor(
            nullptr,
            IDC_ARROW
        );

    windowClass.hbrBackground =
        reinterpret_cast<HBRUSH>(
            COLOR_WINDOW + 1
        );

    RegisterClassW(
        &windowClass
    );

    HWND window =
        CreateWindowExW(
            0,
            className,
            L"f.Tintia Setup",
            WS_OVERLAPPED |
            WS_CAPTION |
            WS_SYSMENU |
            WS_MINIMIZEBOX,
            CW_USEDEFAULT,
            CW_USEDEFAULT,
            560,
            360,
            nullptr,
            nullptr,
            instance,
            nullptr
        );

    if (!window) {
        CoUninitialize();
        return 1;
    }

    ShowWindow(
        window,
        showCommand
    );

    UpdateWindow(window);

    MSG message{};

    while (
        GetMessageW(
            &message,
            nullptr,
            0,
            0
        ) > 0
    ) {
        TranslateMessage(
            &message
        );

        DispatchMessageW(
            &message
        );
    }

    CoUninitialize();

    return static_cast<int>(
        message.wParam
    );
}