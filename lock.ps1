# Helper functions for building the class
$script:nativeMethods = @();
function Register-NativeMethod([string]$dll, [string]$methodSignature) {
    $script:nativeMethods += [PSCustomObject]@{ Dll = $dll; Signature = $methodSignature; }
}
function Add-NativeMethods() {
    $nativeMethodsCode = $script:nativeMethods | % { "
        [DllImport(`"$($_.Dll)`")]
        public static extern $($_.Signature);
    " }
 
    Add-Type @"
        using System;
        using System.Runtime.InteropServices;
        public static class NativeMethods {
            $nativeMethodsCode
        }
"@
}
 
 
# Add methods here
 
Register-NativeMethod "user32.dll" "bool LockWorkStation()"
Register-NativeMethod "user32.dll" "bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight)"
# This builds the class and registers them (you can only do this one-per-session, as the type cannot be unloaded?)
Add-NativeMethods
 
#Calling the method
[NativeMethods]::LockWorkStation()