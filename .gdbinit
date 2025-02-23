# enable pretty printing and load system-provided pretty printing scripts
set print pretty on
set disassembly-flavor intel
add-auto-load-safe-path /usr/share/gdb/auto-load
add-auto-load-scripts-directory /usr/share/gdb/auto-load

# load pretty printers for Qt
python
import sys, os, urllib.request, zipfile
system_path = '/usr/share/kdevgdb/printers'
custom_path = os.path.expanduser("~/gdb-printers/")
has_system_path = os.path.exists(system_path)
has_custom_path = os.path.exists(custom_path)
if has_system_path and not has_custom_path:
    sys.path.insert(0, system_path)
else:
    kdevelop_url = 'https://invent.kde.org/kdevelop/kdevelop/-/archive/master/kdevelop-master.zip'
    kdevelop_zip = custom_path + 'kdevelop.zip'
    kdevelop_dir = custom_path + 'kdevelop-master'
    kdevelop_printers = kdevelop_dir + '/plugins/gdb/printers'
    if not os.path.exists(kdevelop_printers):
        if not has_custom_path:
            os.makedirs(custom_path)
        if not os.path.exists(kdevelop_zip):
            urllib.request.urlretrieve(kdevelop_url, kdevelop_zip)
        with zipfile.ZipFile(kdevelop_zip) as a:
            a.extractall(custom_path)
    sys.path.insert(0, kdevelop_printers)
import qt
qt.register_qt_printers(None)
end
