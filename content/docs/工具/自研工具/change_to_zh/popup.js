chrome.storage.local.get('enable_trans_to_zh', function (result) {
    var enabled = ""
    enabled = result.enable_trans_to_zh;
    document.getElementById("toggleButton").checked = enabled;
});

document.getElementById("toggleButton").addEventListener("click", function () {
    var button = document.getElementById("toggleButton");
    console.log('button', button.checked);
    chrome.storage.local.set({ "enable_trans_to_zh": button.checked });
});