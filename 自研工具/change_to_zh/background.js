// chrome.storage.local.clear();

// let color1 = '#1aa757';
// let color2 = '#3aa757';
// let color3 = '#e8453c';

// chrome.storage.local.set({ color1 });
// chrome.storage.local.set({ "k1": color2 });
// chrome.storage.local.set({ ["k2"]: color3 });
// console.log('Default background color set to %cgreen', `color: ${color2}`);

// chrome.storage.local.get("color1", ({ color1 }) => {
//   console.log('Value currently is ', color1);
// });

// chrome.storage.local.get('k1', ({ k1 }) => {
//   console.log('Value currently is ', k1);
// });

// chrome.storage.local.get(['k2'], (res) => {
//   console.log('Value currently is ', res, res.k2);
// });

// chrome.storage.local.set({ g_color: my_color });

// chrome.storage.local.get(['g_color'], function (result) {
//   console.log('Value is set to ' + result.key + result.value);
// });

// chrome.runtime.onInstalled.addListener(() => {
//   console.log('Default background color set to %cgreen', `color: ${my_color}`);
// });

// // let value = 123;

// // chrome.storage.local.set({key: value}, function() {
// //   console.log('Value is set to ' + value);
// // });

// // chrome.storage.local.get(['key'], function(result) {
// //   console.log('Value currently is ' + result.key);
// // });

chrome.tabs.onUpdated.addListener(function (tabId, changeInfo, tab) {
  // "unloaded", "loading", or "complete"
  var enabled = ""
  chrome.storage.local.get('enable_trans_to_zh', function (result) {
    enabled = result.enable_trans_to_zh;

    if (enabled == true) {
      if (/\/en-us\//i.test(tab.url)) {
        tab.url = tab.url.replace(/en-us/i, 'zh-cn');
        chrome.tabs.update(tabId, { url: tab.url });
      }
    } else {
      if (/\/zh-cn\//i.test(tab.url)) {
        tab.url = tab.url.replace(/zh-cn/i, 'en-us');
        chrome.tabs.update(tabId, { url: tab.url });
      }
    }
  });

  // if (changeInfo.status == 'loading' && ) {
  //   console.log('unloaded', tabId, changeInfo, tab.url);
  //   console.log('newUrl', newUrl);
  //   chrome.tabs.update(tabId, { url: newUrl });
  // }
});

// https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/access-modifiers