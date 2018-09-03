<script language="javascript">

// 以下是固定写法，你自己的JS文件中必须包含如下代码
function setupWebViewJavascriptBridge(callback) {
    if (window.WebViewJavascriptBridge) { return callback(WebViewJavascriptBridge); }
    if (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }
    window.WVJBCallbacks = [callback];
    var WVJBIframe = document.createElement('iframe');
    WVJBIframe.style.display = 'none';
    WVJBIframe.src = 'https://__bridge_loaded__';
    document.documentElement.appendChild(WVJBIframe);
    setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)
}

// 注册相关的回调
setupWebViewJavascriptBridge(function(bridge) {
                             
                             /* Initialize your app here */
                             
                             //这句代码是注册一个名为'JS Echo'的方法,data是参数,responseCallback是返回,相当于return,供APP端调用
                             bridge.registerHandler('JS Echo', function(data, responseCallback) {
                                                    console.log("JS Echo called with:", data)
                                                    responseCallback(data)
                                                    })
                             
                             bridge.registerHandler('imagesDownloadCompleteHandler', function(data,responseCallback) {
                                                    
                                                    
                                                    var imgName = data[0];
                                                    var imgPath = data[1];
                                                    //读取未替换的图片
                                                    var imgs = document.getElementsByTagName('img');
                                                    if (imgs) {
                                                    for (var i = 0, j = imgs.length; i < j; i++) {
                                                    if (imgs[i].src.indexOf(imgName) >= 0) {
                                                    imgs[i].src = imgPath;
                                                    }
                                                    }
                                                    }
                                                    })
                             //调用APP端原生的方法,方法名为'ObjC Echo',responseData是JS端接收到的返回值.
                             bridge.callHandler('ObjC Echo', 传入的参数 , function responseCallback(responseData) {
                                                console.log("JS received response:", responseData)
                                                })
                             
                             })

</script>


