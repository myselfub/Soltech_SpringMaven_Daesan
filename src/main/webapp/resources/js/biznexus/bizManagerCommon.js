const SELECT_CATEGORY  = { BY_NAME:"byName", BY_DESC : "byDesc",  BY_DRIVER: "byDriver", BY_AREA: "byArea" };
const s_ValueType = [ "Unknown", "Bool", "Integer", "Real", "String" ];

function getContextPath() {
	var hostIndex = location.href.indexOf( location.host ) + location.host.length;
	return location.href.substring( hostIndex, location.href.indexOf('/', hostIndex + 1) );
};

Date.prototype.format = function (f) 
{
    if (!this.valueOf()) return " ";
    var weekKorName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
    var weekKorShortName = ["일", "월", "화", "수", "목", "금", "토"];
    var weekEngName = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
    var weekEngShortName = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    var d = this;
	
    return f.replace(/(yyyy|yy|MM|dd|KS|KL|ES|EL|HH|hh|mm|ss|a\/p)/gi, function ($1) {
        switch ($1) {
            case "yyyy": return d.getFullYear(); // 년 (4자리)
            case "yy": return (d.getFullYear() % 1000).zf(2); // 년 (2자리)
            case "MM": return (d.getMonth() + 1).zf(2); // 월 (2자리)
            case "dd": return d.getDate().zf(2); // 일 (2자리)
            case "KS": return weekKorShortName[d.getDay()]; // 요일 (짧은 한글)
            case "KL": return weekKorName[d.getDay()]; // 요일 (긴 한글)
            case "ES": return weekEngShortName[d.getDay()]; // 요일 (짧은 영어)
            case "EL": return weekEngName[d.getDay()]; // 요일 (긴 영어)
            case "HH": return d.getHours().zf(2); // 시간 (24시간 기준, 2자리)
            case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2); // 시간 (12시간 기준, 2자리)
            case "mm": return d.getMinutes().zf(2); // 분 (2자리)
            case "ss": return d.getSeconds().zf(2); // 초 (2자리)
            case "a/p": return d.getHours() < 12 ? "오전" : "오후"; // 오전/오후 구분
            default: return $1;
        }
    });
};

String.prototype.string = function (len) { var s = '', i = 0; while (i++ < len) { s += this; } return s; };
String.prototype.zf = function (len) { return "0".string(len - this.length) + this; };
Number.prototype.zf = function (len) { return this.toString().zf(len); };
	
Loading = {
	start: function() {
   		if (document.getElementById('loading')) {
   			return;
   		}
   		var ele = document.createElement('div');
   		ele.setAttribute('id', 'loading');

		var image = document.createElement('img');
		image.setAttribute('id', 'loading-image');
		image.setAttribute('src', getContextPath() + "/resources/images/biznexus/Wait.gif");
		image.setAttribute('alt', "Loading...");

   		ele.appendChild(image);
   		document.body.append(ele);
	},
	stop: function() {
   		var ele = document.getElementById('loading');
   		if (ele) {
   			ele.remove();
   		}
	}
}

Number.prototype.pad = function(size) 
{
   	var s = String(this);
   	while (s.length < (size || 2)) {s = "0" + s;}
   	return s;
}	
	
Number.prototype.withCommas = function() {
    var reg = /(^[+-]?\d+)(\d{3})/;
    var n = (this + '');
	 
    while (reg.test(n)) n = n.replace(reg, '$1' + ',' + '$2');
	 
    return n;
}

let numberFormat = function(nVal, nDec, bComma) 	{
	if(typeof nVal == 'undefined')
		return nVal;
	else {
		nVal = nVal.toFixed(nDec);

		var strVal = nVal.toString();
			
		var decPart = strVal.split(".");
		if(bComma == true)
			strVal = decPart[0].replace(/\B(?=(\d{3})+(?!\d))/g,",") + (decPart[1] ? "." + decPart[1] : "");
			
		return strVal;
	}
}
	
function setDarkTheme() {
	var element = document.body;
	var content = document.getElementById("DarkModetext");
	element.className = "dark-mode";
	//content.innerText = "Dark Mode is ON";
}

function MsgBox(txtHeader,txtContent) {
	Sexy.alert('<h1>'+txtHeader+'</h1><p>'+txtContent+'</p>');
}

function ConfirmBox(title, message, func) {
	Sexy.confirm('<h1>' + title + '</h1><p>' + message + '</p>', {
		textBoxBtnOk: 'Ok',
		textBoxBtnCancel: 'Cancel',
		onComplete: function(retCode) {
			func(retCode);
		}
	});
}

OnMessage = function(title, info) {
	!!info.msg ?
	MsgBox(title, info.msg)
	:
	MsgBox(title, info);
}

OnNop = function(title, info) {
	deleteTagCount(title, info);//2023-07-28 heewon 체크박스를 사용한 삭제 진행상황 확인
}

function getItems(url) {
	var obj = new Object();
	obj.cmd = "getItems";
	obj.param = "";
	
	req(url, JSON.stringify(obj));
}

function postMessage(url, req, func) {
	return new Promise((resolve, reject) => {
		$.ajax ({
		    type: 'POST',
		    contentType: 'application/json; charset=UTF-8',
		    url: url,
		    dataType: 'json',
		    cache : false,
		    data: JSON.stringify(req),
		    success: function (obj){
				var nretry = 0;
				if(obj.cmd == req.cmd) 
				{
					if(typeof(func) == 'undefined')
						OnMessage(obj.cmd, obj.param);
					else
						func(obj.param);
				}
				else if(req.cmd == "selectTags" && obj.cmd == "error"){
						postMessage(url, req, func);
				}else if(req.cmd == "fetchValues" && obj.cmd == "error"){
					func(obj.param);
				}
				resolve();
			},
			error: function (request, status, error) 
			{	
				console.log("Error" +  "[" + status + "]" + error);
				reject();
			}
		});
	});
}


function CreateContextmenu(id) {
	
	// contextmenu.js
	createContextmenu(document.body, [
		{
			'text' : 'Clear Selection',
			'onclick' : e=>clearSelection(id)
		},
		'divider',
		{
			'text' : 'Open Trend Manager',
			'onclick' : e=>openTrend(id, 'trendmanager1')
		}
	]);
}


function clearSelection(id) {
	$(id).bizRender("clearSelection");
	hideContextmenu();
}


function hideContextmenu(){
	$(".contextmenu-container").hide();
}

var obj = {};
function openTrend(id, title) {
	obj = {};
	$(id).bizRender("selectedTags", obj);
	
	if(obj.tagList.length > 0) {
		window.open('trendView', 'Trend', 'width=1500; height=900; top: 200;', true);
	}
}
