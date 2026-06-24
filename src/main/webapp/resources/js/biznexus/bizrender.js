/*
수정이력
    2023-03-15  v1.00   moonbsun	Weaver와 의 텍스트 좌표 일치하도록 수정
									텍스트 값 표시하도록 수정
	2023-04-19	v1.01	moonbsun	ontimer 이중 동작 방지 					
	2023-04-20  v1.01	jgs			testEffectByColorlist - undefined 예외처리
	2023-04-24  v1.01	jgs			flash(점멸) 함수 추가
    2023-04-25  v1.10   moonbsun    blink 속성 및 기능 추가, flash원복
    2023-05-08  v1.20   moonbsun    EffectByFill의 배경색 추가
                        moonbsun    COUNTER함수 추가 
                        moonbsun    ImageList 버그 수정
	2023-05-12	v1.21   jgs			calcTag - undefined 예외처리
    2023-06-12  v1.30   moonbsun    checkRedraw : 배경이 변경될 경우 겹쳐져 있는 모든 Shape를 다시그릴수 있도록 수정
                                    Effect에 의한 다시그리기 검사를 CheckRedraw함수로 이동
                                    Blink검사를 CheckRedraw함수로 이동
 	2024-05-22  v1.31   whs    		트렌드 조회를 위한 태그 더블 클릭시 그려지는 체크 아이콘 위치 수정(위치: whs_240522 검색)
                                    
*/
String.prototype.string = function (len) { var s = '', i = 0; while (i++ < len) { s += this; } return s; };
String.prototype.zf = function (len) { return "0".string(len - this.length) + this; };
Number.prototype.zf = function (len) { return this.toString().zf(len); };
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

Date.prototype.format = function (f) {
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
			case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2); // 시간(12 시간 기준, 2자리)
			case "mm": return d.getMinutes().zf(2); // 분 (2자리)
			case "ss": return d.getSeconds().zf(2); // 초 (2자리)
			case "a/p": return d.getHours() < 12 ? "오전" : "오후"; // 오전/오후 구분
			default: return $1;
		}
	});
};

(function(window, $, undefined) {
	let BIZRENDER_DATA_KEY = "BizRender";
	let workspaceCollection  = new Array();
	
	function getVal(tagName) {
		let val = {};
		
		for(let name in workspaceCollection) {
			let workspace = workspaceCollection[name];
			if(typeof(workspace) == 'undefined') continue;
			let tag = workspace.tagList[tagName];
			if(typeof(tag) != 'undefined'){ 
				val = tag.val;
				break;
			}
			else {
				tag = {};
				tag.name = tagName;
				workspace.tagList[tagName] = tag;
			}
		}

		return val;
	}
	
	function setVal(tagName, value) {
		for(let name in workspaceCollection) {
			let workspace = workspaceCollection[name];
			if(typeof(workspace) == 'undefined') continue;
			
			let tag = workspace.tagList[tagName];
			if(typeof(tag) == 'undefined') {
				tag = {};
				tag.name = tagName;
				tag.time = new Date();
			}
			
			tag.val = value;
			workspace.tagList[tagName] = tag;
		}
		
		return 0;
	} 
	
	function addTags(workspace, tagList) {
		if(typeof(workspace.tagList) == 'undefined' || workspace.tagList == null) {
			workspace.tagList = new Array();
		}
		for(let tagName of tagList) {
			// 쉼표로 구분된 여러 태그 지원
			if(tagName.indexOf(',') > -1) {
				let tags = tagName.split(',');
				for(let t of tags) {
					let trimmedTag = t.trim();
					if(trimmedTag != "" && typeof(workspace.tagList[trimmedTag]) == 'undefined') {
						let tag = {};
						tag.name = trimmedTag;
						workspace.tagList[trimmedTag] = tag;
					}
				}
			} else {
				if(typeof(workspace.tagList[tagName]) == 'undefined') {
					let tag = {};
					tag.name = tagName;
					workspace.tagList[tagName] = tag;
				}
			}
		}
	}
		
	function workspace(element, config) {
		let self = this;
		
		var $element = $(element);
		$element.data(BIZRENDER_DATA_KEY, this);
		this._container = $element;
		this.data = [];
		this.config = config;
		
		// callback members
		this.onTimeChanged = $.noop;
		this.onItemClick = $.noop;
		this.onItemDblClick = $.noop;
		this.onValueChanged = $.noop;
		this.onSizeChanged = $.noop;
		
		this.canvas = element[0];
		this.canvas.style.position = "absolute";
		this.canvas.style.zIndex = 1;
		this.context = this.canvas.getContext("2d");
		this.context.imageSmoothingEnable = true;
		this.canvas.ondblclick = function(e) { self.ondblclick(e) };
		this.canvas.onclick = function(e) { self.onClick(e) };
		this.canvas.onmousemove = function(e) { self.onMouseMove(e) };

		this.createBackCanvas();

		this.shapeNames = new Array();
		this.uxList.shapes = new Array();
		this.jsScript = "";
		this.urlPrefix = "";
		this.imagesPath = "";
				
		this.canvasWidth = this.canvas.clientWidth;
		this.canvasHeight = this.canvas.clientHeight;
		
		this.interval = 1000;
		this.dest = "biznexus";
		//this.request = new Date();
				
		if(typeof(config.onSizeChanged) != 'undefined') this.onSizeChanged  = config.onSizeChanged;
		if(typeof(config.onTimeChanged) != 'undefined') this.onTimeChanged  = config.onTimeChanged;
		if(typeof(config.onItemClick) != 'undefined') this.onItemClick = config.onItemClick;
		if(typeof(config.onItemDblClick) != 'undefined') this.onItemDblClick = config.onItemDblClick;
		if(typeof(config.onValueChanged) != 'undefined') this.onValueChanged = config.onValueChanged;
		
		if(typeof(config.initValue) != 'undefined') this.initValue = config.initValue;
		if(typeof(config.width) != 'undefined') this.canvasWidth = config.width;
		if(typeof(config.height) != 'undefined') this.canvasHeight = config.height;
		if(typeof(config.interval) != 'undefined') this.interval = config.interval;
		if(typeof(config.dest) != 'undefined') this.dest = config.dest;
		if(typeof(config.layoutPath) != 'undefined') this.layoutPath = config.layoutPath;
		if(typeof(config.urlPrefix) != 'undefined') this.urlPrefix = config.urlPrefix;
		if(typeof(config.imagesPath) != 'undefined') this.imagesPath = config.imagesPath;
		if(typeof(config.tagList) != 'undefined') addTags(this, config.tagList);
		this.drawBack = false;
		this.timerID = null;
		
		// load images
		this.ckIcon = new Image();
		this.ckIcon.src = this.imagesPath + "check_on.png"
		
		bizRender.loader.load(config.fileName, this);
	}

	function setAttrRotate(shapeName, value ) {
		for(let name in workspaceCollection) {
			let workspace = workspaceCollection[name];
			if(typeof(workspace) == 'undefined') continue;

			let shape = workspace.shapeNames[shapeName];
			if(typeof(shape) != 'undefined') {
				if(shape.rotate != value) shape.bDraw = true;
				shape.rotate = value;
				shape.rotateRect();
			}
		}
	}
    
  	function setAttrBlink(shapeName, value ) {
		for(let name in workspaceCollection) {
			let workspace = workspaceCollection[name];
			if(typeof(workspace) == 'undefined') continue;

			let shape = workspace.shapeNames[shapeName];
			if(typeof(shape) != 'undefined') {
				if(shape.blink != value) shape.bDraw = true;
				shape.blink = value;
			}
		}
	}

	function setAttrFillText(shapeName, value ) {
		debugger;
		for(let name in workspaceCollection) {
			let workspace = workspaceCollection[name];
			if(typeof(workspace) == 'undefined') continue;
	
			let shape = workspace.shapeNames[shapeName];
			if(typeof(shape) != 'undefined') {
				if(shape.fill.text != value) shape.bDraw = true;
				shape.fill.text = value;
			}
		}
	}
	
	function setAttrFillColor(shapeName, value ) {
		for(let name in workspaceCollection) {
			let workspace = workspaceCollection[name];
			if(typeof(workspace) == 'undefined') continue;

			let shape = workspace.shapeNames[shapeName];
			if(typeof(shape) != 'undefined') {
				let fillRGB = parseInt(value.substring(1), 16);
				let fillColor = getRGBA(fillRGB, 1.0);
				if(fillColor != shape.fill.color ) shape.bDraw = true;
				shape.fill.color = fillColor;
			}
		}
	}
	
	function setAttrShow(shapeName, value ) {
		for(let name in workspaceCollection) {
			let workspace = workspaceCollection[name];
			if(typeof(workspace) == 'undefined') continue;

			let shape = workspace.shapeNames[shapeName];
			if(typeof(shape) != 'undefined') {
				let bShow = value == 0 ? false : true;
				if(shape.show != bShow) shape.bDraw = true; 
				shape.show = bShow;
			}
		}
	}

	function setAttr(shapeName, field, value) {
		switch(field) {
			case "SHOW" : setAttrShow(shapeName, value); break;
			case "FILLCOLOR" : setAttrFillColor(shapeName, value); break;
			case "FILLTEXT" :  setAttrFillText(shapeName, value); break;
			case "ROTATE" :  setAttrRotate(shapeName, value); break;
			case "BLINK" :  setAttrBlink(shapeName, value); break;
		}
		return 0;
	} 
	
	workspace.prototype = {
		uxList : new Object(),
		tagList : new Array(),
		tick :  0,
		
		createBackCanvas : function() {
			this.backCanvas = document.createElement('canvas');
			this.backCanvas.id = this.canvas.id + "_back";
			this.backCanvas.width = this.canvas.width;
			this.backCanvas.height = this.canvas.height;
			
			this.backCanvas.style.position = "absolute"; //"fixed";  // 20240927 dsan khr
			this.backCanvas.style.zIndex= 0;
			
			$("#" + this.canvas.id).after(this.backCanvas);
		},
	
		onSuccess : function() {
			// 기존 tagList 유지 (JSP에서 추가한 태그 보존)
			if(typeof(this.tagList) == 'undefined' || this.tagList == null) {
				this.tagList = new Array();
			}
			let tagList = getTagList(this.uxList);
			for(let tagName of tagList) {
				if(typeof(this.tagList[tagName]) == 'undefined') {
					let tag = {};
					tag.name = tagName;
					this.tagList[tagName] = tag;
				}
			}
            
			if(typeof(this.initValue) != 'undefined') 
				initializeValues(this);
			
			let self = this;
			if(self.timerID == null) {
				self.onTimer();
				self.timerID = setInterval(function() {
					self.onTimer();
				}, self.interval);
			}
			
			if(this.jsScript.length > 0) eval(this.jsScript);
			this.reqValues();
			this.drawBack = false;
		},
		
		selectedTags : function() {
			let tagList = new Array();
			for(let shape of this.uxList.shapes) {
				if(shape.select == false) continue;
				tagList.push(shape.effectByValue.tagName);
			}
			
			return tagList;
		},
		
		clearSelection : function() {
			for(let shape of this.uxList.shapes) {
				if(shape.select == false) continue;
				shape.select = false;
				shape.bDraw = true;
			}
		},
		
		reqValues : function() {				 
			let tagList = new Array();
			for(let tag in this.tagList) {
                if(tag.substr(0,1) == '$') continue;
				tagList.push(tag);
			}
			
			return bizRender.valueManager.reqValues(tagList, this);
		},
		
		onTimer : function() {
			let now = new Date();
			let reqTime = now.setSeconds(now.getSeconds() + bizRender.valueManager.lagTime);
			
			if(this.tick == 0) window.dispatchEvent(new Event('resize'));
			
			if(this.drawBack == false && typeof(this.backCanvas) != 'undefined') this.drawBack = bizRender.render.drawBack(this);
			
			bizRender.render.draw(this, this.tick);
			
			if(this.tick % 10 == 0) {
				bizRender.valueManager.calcSystemTags(this);
				this.onTimeChanged(new Date(reqTime));
				
				if(this.jsScript.length > 0) eval(this.jsScript);
				this.reqValues();
			}

			
			
			this.tick++;
			
		},
		
		//onFullScreen : function() {
		//	let width = this.canvas.offsetWidth;
		//	let height = this.canvas.offsetHeight;
		//},
		
		
		 onSize : function() {
	//		let isFullscreen = Math.abs(screen.height - window.outerHeight) <= 20; 
	//		this.onSizeChanged(isFullscreen);
			
			let width = this.canvas.offsetWidth; // 20240927 dsan khr
			let height = this.canvas.offsetHeight;
			
			this.setSize(width, height);
//			this.refresh();
		},
		
		setSize : function(width, height) {
			this.canvas.clientWidth = width;
			this.canvas.clientHeight = height;
			this.canvas.width = width;
			this.canvas.height = height;

			this.canvas.style.width = width;
			this.canvas.style.height = height;
			if(typeof(this.backCanvas) != 'undefined') {
				this.backCanvas.offsetWidth = width;
				this.backCanvas.offsetHeight = height;
				this.backCanvas.width = width;
				this.backCanvas.height = height;
			}
			
			this.drawBack = false;

			for(let shape of this.uxList.shapes)
				shape.bDraw = true;
		},

		ondblclick : function(e) {
		
			let nLen = this.uxList.shapes.length - 1;
			for(let i = nLen; i >= 0; i--) {
				if(i < 0) break;
				let shape = this.uxList.shapes[i];

				
				if(e.offsetX >= shape.left  && e.offsetX <= shape.left + shape.width &&
					e.offsetY >= shape.top && e.offsetY <= shape.top + shape.height) {
					if(typeof(shape.effectByValue) == 'undefined') continue;
					shape.select = shape.select  == true ? false : true; 	
					shape.bDraw = true;
					break;
				}
			}
		},
		
		onClick : function(e) {
			
			
			let nLen = this.uxList.shapes.length - 1;
			for(let i = nLen; i >= 0; i--) {
				if(i < 0) break;
				let shape = this.uxList.shapes[i];

				if(e.offsetX >= shape.left  && e.offsetX <= shape.left + shape.width &&
						e.offsetY >= shape.top && e.offsetY <= shape.top + shape.height) {
					this.canvas.style.cursor = 'pointer'; 
						
					this.onItemClick(shape.name);
						
					if(typeof(shape.effectByLink) != 'undefined') 
						bizRender.loader.load(shape.effectByLink.link, this);
						break;
				}
			}		
		},
		
		onMouseMove : function(e) {
			let bFlag = false;
			let nLen = this.uxList.shapes.length - 1;
			for(let i = nLen; i >= 0; i--) {
				if(i < 0) break;
				let shape = this.uxList.shapes[i];

				if(e.offsetX >= shape.left  && e.offsetX <= shape.left + shape.width &&
					e.offsetY >= shape.top && e.offsetY <= shape.top + shape.height) {
					if(typeof(shape.effectByLink) != 'undefined') {
						bFlag = true;	
						break;
					}
				}
			}	
			this.canvas.style.cursor = bFlag == true ? 'pointer' : 'default'; 	
		},
		
		onValues : function(values) {
			let tagValues = new Array();
			
			for(let val1 of values) {
				let val2 =  this.tagList[val1.name];
				if(typeof(val2) == 'undefined') {
					let tag = val1;
                    
                    if(tag.val.quality == 192) {
                        tag.val = Number(tag.val);
                    } 
                    else {
                        delete tag.val;
                    }
                        
					this.tagList[val1.name] = tag;
					
					let tagPrefix = val1.name.substring(0,1);
					if(tagPrefix != "$"){
						tagValues[val1.tagName] = val1;
					}
				} 
				else {
					if(val1.val != val2.val) {
						//if(val1.quality == 192) {
                            if(isNaN(val1.val) == true) {
                                this.tagList[val1.name].val = val1.val;
                            }
                            else
                                this.tagList[val1.name].val = Number(val1.val);
                            this.tagList[val1.name].time = val1.time;
						//}
						//else {
							//delete this.tagList[val1.name].val;
						//}

						let tagPrefix = val1.name.substring(0,1);
							
						if(tagPrefix != "$"){
                            tagValues[val1.name] = val1;
						}
					}
				}
			}
            
			if(Object.keys(tagValues).length > 0){
				this.onValueChanged(tagValues);
				
				if(this.jsScript.length > 0) {
					eval(this.jsScript);
				}
			}
			this.setValues(this.uxList);
		},

		// 태그 값 매핑_값이 중복 표시되는 현상으로 인해 코드 수정_241002_whs
		setValues: function(uxList) {
		    for (let shape of uxList.shapes) {
		        if (typeof(shape.effectByValue) === 'undefined') continue;

		        let val = this.tagList[shape.effectByValue.tagName];
		        let strVal = "-";  // 기본 값은 "-"로 설정

		        // val 있을 때 값 매핑
		        if (typeof(val) !== 'undefined') {
		            strVal = NumbericFormat(val.val, shape.effectByValue.decPos, shape.effectByValue.commaDelimeted);
		        }

		        // val 없을 때 "-" 표시
		        if (typeof(shape.fill.text) === 'undefined' || shape.fill.text !== strVal) {
		            shape.bDraw = true;
		            shape.fill.text = strVal;
		        }
		    }
		}
	}

	let initializeValues = function(workspace) {
		for(let shape of workspace.uxList.shapes) {
			if(typeof(shape.effectByValue) == 'undefined') continue;
			if(typeof(shape.effectByImagelist) != 'undefined') continue;
			if(typeof(shape.effectByColorlist) != 'undefined') continue;
			shape.fill.text = workspace.initValue;
		}
	}
	
	let getTagList = function(uxList) {
		let tagList = new Array();
		for(let shape of uxList.shapes) {
			let tagName = "";
			if(typeof(shape.effectByValue) != 'undefined') tagName = shape.effectByValue.tagName;
			if(typeof(shape.effectByImagelist) != 'undefined') tagName = shape.effectByImagelist.tagName;
			if(typeof(shape.effectByColorlist) != 'undefined') tagName = shape.effectByColorlist.tagName;

			if(tagName == "") continue;
			if(typeof(tagName) == 'undefined') continue;
			if(tagName.substring(0,1) == '$') continue;

			// 쉼표로 구분된 여러 태그 지원
			if(tagName.indexOf(',') > -1) {
				let tags = tagName.split(',');
				for(let tag of tags) {
					let trimmedTag = tag.trim();
					if(trimmedTag != "") tagList.push(trimmedTag);
				}
			} else {
				tagList.push(tagName);
			}
		}

		return tagList;
	}

	function addServer(workspace, serverType, conn) {
		let reqData = {};
		reqData.cmd = "addServer";
		reqData.param = {};
		reqData.param.type = serverType;
		reqData.param.conn = conn;

		return new Promise((resolve, reject) => {
			$.ajax ( {
				type: 'POST',
				contentType: 'application/json; charset=UTF-8',
				url: workspace.urlPrefix + 'setConfig',
				dataType: 'json',
				cache : false,
				data: JSON.stringify(reqData),
				success: function (obj)  {
					switch(obj.cmd) {
						case "addServer" : break;
						default:
							// console.log(obj);
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

	function addSeconds(workspace, secs) {
		if(secs == 0) 
			bizRender.valueManager.lagTime = 0;
		else {
			bizRender.valueManager.lagTime += secs;
			if(bizRender.valueManager.lagTime > 0) bizRender.valueManager.lagTime = 0;
		}
		
		let now = new Date();
		let reqTime = now.setSeconds(now.getSeconds() + bizRender.valueManager.lagTime);
		workspace.onTimeChanged(new Date(reqTime));
		workspace.reqValues();
	}
	
	function selectedTags(workspace, param) {
		param.tagList = workspace.selectedTags();	
	}
	
	function clearSelection(workspace) {
		workspace.clearSelection();	
	}
	
	function clearRequestInterval(workspace) {
		clearTimeout(workspace.timerID);
	}
	
	$.fn.bizRender = function(config, param, val1, val2) {
		this.each(function() {
			var $element = $(this),
				instance = $element.data(BIZRENDER_DATA_KEY);
 
			if(typeof(instance) == 'undefined') {
				let obj = new workspace($element, config);
				workspaceCollection[$element[0].id] = obj;
				window.addEventListener("resize", function() { obj.onSize(); } );
			} 
			else {
				switch(config) {
					case "setVal" : setVal(param, val1); break;
					case "setAttr" : setAttr(param, val1, val2); break;
					case "addServer" : addServer(instance, param, val1); break;
					case "addSeconds" : addSeconds(instance, param); break;
					case "selectedTags" : selectedTags(instance, param); break;
					case "clearSelection" : clearSelection(instance); break;
					case "clearRequestInterval" : clearRequestInterval(instance); break;
				}
			}
		});

		return this;
	};

	window.bizRender = {
		version: '1.0.0'
	};
}(window, jQuery));

(function(bizRender, $, undefined) {
	function onValues(workspace, cmd, values) {
		workspace.onValues(values);	
	}
 
	var bReq = false;
	function reqValues(cmd, reqData, workspace) {
		return new Promise((resolve, reject) => {
		//bReq = true;
			if(bReq == false) {
				bReq = true;
				$.ajax ( {
					type: 'POST',
					contentType: 'application/json; charset=UTF-8',
					url: 'reqHistorian',
					dataType: 'json',
					cache : false,
					// async:false,
					data: reqData,
					success: function (obj)  {
						bReq = false;
						switch(obj.cmd) {
							case "reqValues" : 
                                onValues(workspace, cmd, obj.param); 
                                break;
							case "fetchValues" :  // 트렌드 용도
                            break; 
							default:
								// console.log(obj);
						}
						resolve();
						
					},
					error: function (request, status, error) 
					{
						console.log("Error" +  "[" + status + "]" + error);
						reject();
						
						bReq = false;
					}
				});
			}
		});
	}

	function valueManager() {
		this.lagTime = 0;
		//this.tagValues = new Array();	
		//this.shapeNames = new Array();
	}
	
	valueManager.prototype = {
		reqValues : async function(tagList, workspace) {
			if(tagList.length > 0) {
				let now = new Date();
				
				let obj = new Object();
				obj.cmd = "reqValues";
				obj.dest = workspace.dest;
				obj.timeout = 30000;
				obj.param = {};
				obj.param.tagList = tagList;

				reqValues(obj.cmd, JSON.stringify(obj), workspace);
			}
		},

		fetchValues : async function(tagList, workspace) {
			if(tagList.length > 0) {
				let now = new Date();
				let reqTime = new Date(now.setSeconds(now.getSeconds() + this.lagTime)); 
				
				let obj = new Object();
				obj.cmd = "fetchValues";
				obj.dest = workspace.dest;
				obj.param = {};
				obj.param.start = reqTime.format('yyyy-MM-dd HH:mm:ss');
				obj.param.end = reqTime.format('yyyy-MM-dd HH:mm:ss');
			//	obj.param.fit = true;
				obj.param.tagList = tagList;

				reqValues(obj.cmd, JSON.stringify(obj), workspace);
			}
		},
		
		calcSystemTags : function(workspace) {
			let now = new Date();
			
			let tagValues = new Array();
			
			for(let tagName of [ "$SECOND",  "$SECONDS", "$HOUR", "$MINUTE"] ) {
				let	tag = new Object();
				tag.name = tagName;
				tag.time = now.format('yyyy-MM-dd HH:mm:ss');
                tag.quality = 192;
				
				switch(tagName) {
					case "$HOUR" : tag.val = now.getHours().pad(2); break; 
					case "$MINUTE" : tag.val = now.getMinutes().pad(2); break;
					case "$SECOND" : tag.val = now.getSeconds().pad(2); break; 
					case "$SECONDS" : tag.val = parseInt(now.getTime() / 1000); break; 
				}	
					
				tagValues.push(tag);
			}
            
           // console.log(tagValues);
			
			workspace.onValues(tagValues);
		}
	}
	
	bizRender.valueManager = new valueManager();
}(bizRender, jQuery));

(function(bizRender, $, undefined) {
	CanvasRenderingContext2D.prototype.drawEllipse = function (x, y, w, h, lineWidth, fillmode) {
		var kappa = .5522848,
		ox = (w / 2) * kappa, // control point offset horizontal
		oy = (h / 2) * kappa, // control point offset vertical
		xe = x + w, // x-end
		ye = y + h, // y-end
		xm = x + w / 2, // x-middle
		ym = y + h / 2; // y-middle
	
		this.beginPath();
		this.moveTo(x, ym);
		this.bezierCurveTo(x, ym - oy, xm - ox, y, xm, y);
		this.bezierCurveTo(xm + ox, y, xe, ym - oy, xe, ym);
		this.bezierCurveTo(xe, ym + oy, xm + ox, ye, xm, ye);
		this.bezierCurveTo(xm - ox, ye, x, ym + oy, x, ym);

		this.closePath();
		
		if(lineWidth > 0) this.stroke();
	
		if (fillmode != true) 
			this.fill();
		else
			this.clip();
	
	}
	
	CanvasRenderingContext2D.prototype.drawRoundRect = function (x, y, w, h, r, fillmode, mode) {
		this.beginPath();
		if (mode == "full") {
			this.moveTo(x, y + r);
			this.lineTo(x, y + h - r);
			this.arcTo(x, y + h, x + r, y + h, r);
			this.lineTo(x + w - r, y + h);
			this.arcTo(x + w, y + h, x + w, y + h-r, r);
			this.lineTo(x + w, y + r);
			this.arcTo(x + w, y, x + w - r, y, r);
			this.lineTo(x + r, y);
			this.arcTo(x, y, x, y + r, r);
		}
		else if (mode == "upper") {
			this.moveTo(x, y + r);
			this.lineTo(x, y + h);
			this.lineTo(x + w, y + h);
			this.lineTo(x + w, y + r);
			this.arcTo(x + w, y, x + w - r, y, r);
			this.lineTo(x + r, y);
			this.arcTo(x, y, x, y + r, r);
		}
		else if (mode == "lower") {
			this.moveTo(x, y + r);
			this.lineTo(x, y + h - r);
			this.arcTo(x, y + h, x + r, y + h, r);
			this.lineTo(x + w - r, y + h);
			this.arcTo(x + w, y + h, x + w, y + h-r, r);
			this.lineTo(x + w, y);
			this.lineTo(x, y);
			this.lineTo(x, y + r);
		}
		else {
			console.log("is not mode!!");
		}
		
		if (fillmode != true)	this.fill();
		else					this.clip();
		
		this.stroke();
	}
	
	CanvasRenderingContext2D.prototype.drawTriangle = function (x, y, w, h, fillmode, mode) {
		this.beginPath();
		if (mode == "full") {
			this.moveTo(x+(w/2), y);
			this.lineTo(x+w, y+h);
			this.lineTo(x, y+h);
			this.lineTo(x+(w/2), y);
		}
		else if (mode == "right") {
			this.moveTo(x, y);
			this.lineTo(x+w, y+h);
			this.lineTo(x, y+h);
			this.lineTo(x, y);
		}
		else {
			console.log("is not mode!!");
		}
		
		if (fillmode != true)	this.fill();
		else					this.clip();
		
		this.stroke();
	}
	
	CanvasRenderingContext2D.prototype.drawParallelogram = function (x, y, w, h, ofs, fillmode) {
		this.beginPath();
		this.moveTo(x + ofs, y);
		this.lineTo(x + w, y);
		this.lineTo(x + w - ofs, y + h);
		this.lineTo(x, y + h);
		this.lineTo(x + ofs, y);
		
		if (fillmode != true)	this.fill();
		else					this.clip();
		
		this.stroke();
	}
	
	CanvasRenderingContext2D.prototype.drawTrapezoid = function (x, y, w, h, ofs, fillmode) {
		this.beginPath();
		this.moveTo(x + ofs, y);
		this.lineTo(x + w - ofs, y);
		this.lineTo(x + w, y + h);
		this.lineTo(x, y + h);
		this.lineTo(x + ofs, y);
		
		if (fillmode != true)	this.fill();
		else					this.clip();
		
		this.stroke();
	}
	
	CanvasRenderingContext2D.prototype.drawRhombus = function (x, y, w, h, fillmode) {
		this.beginPath();
		this.moveTo(x + w/2, y);
		this.lineTo(x, y + h/2);
		this.lineTo(x + w/2, y + h);
		this.lineTo(x + w, y + h/2);
		this.lineTo(x + w/2, y);
		
		if (fillmode != true)	this.fill();
		else					this.clip();
		
		this.stroke();
	}
		
	CanvasRenderingContext2D.prototype.drawPentagon = function (x, y, w, h, fillmode) {
		this.beginPath();
		this.moveTo(x+w/2, y);
		this.lineTo(x+w, y+h*2/5);
		this.lineTo(x+w*3/4, y+h);
		this.lineTo(x+w*1/4, y+h);
		this.lineTo(x, y+h*2/5);
		this.lineTo(x+w/2, y);
			
		if (fillmode != true)	this.fill();
		else					this.clip();
		
		this.stroke();
	}

//(function(bizRender, $, undefined) {
	TextAlign = { "Left" : 0, "Center" : 1, "Right" : 2};
	LineStyles = {"solid" : 0, "dot" : 1, "dash" : 2, "dashdot" : 3, "dashdotdot" : 4 }; 
	TextDirection = { "LeftToRight":0, "RightToLeft":1, "Vertical" : 2 };
	ShadowDirection = { "SouthEast": 1, "SouthWest" : 2, "NorthEast" : 3, "NorthWest" : 4 };
	
	uxBase = function() {
		this.show = true;
		this.select = false;
		this.name = "";
		this.bDraw = true;

		this.left = 0;
		this.top = 0;
		this.width = 0;
		this.height = 0;
		//this.rotate = 0;
		this.flipVert = 0;
		this.flipHorz = 0;
        this.blink = false;
        this.border = { x:0, y:0, cx:0, cy:0 };
		
		this.clearRect = {};
	}
	
	uxBase.prototype = {
		drawShape : function(context) {
			if(this.line.width > 0) {
				context.beginPath();
				context.lineWidth = this.line.width;
				context.strokeStyle = this.line.color;
		
				switch(this.line.style) {
					case LineStyles.sold : break;
					case LineStyles.dot: context.setLineDash([1]); break;
					case LineStyles.dash : context.setLineDash([1, 2]); break;
					case LineStyles.dashdot: context.setLineDash([1, 2, 1]); break;
					case LineStyles.dashdotdot : context.setLineDash([1, 2, 1, 1]);break;
				}
				
				if(this.type == "line") {
					context.moveTo(this.left, this.top);
					context.lineTo(this.left + this.width, this.top + this.height);
					context.stroke();
				}
				else {
					if(this.line.width > 0) {
						switch(this.type) {
							case "rectangle" : 	context.strokeRect( this.left, this.top, this.width, this.height); break;
							case "ellipse" : context.drawEllipse( this.left, this.top, this.width, this.height, this.line.width, this.image != null); break;
						}
					}
				}
				
				context.closePath();
			}
		},
        
        clearBackground : function(context, backColor) {
			context.fillStyle = backColor;
            context.fillRect(this.left, this.top, this.width, this.height); 
        },
		

		fillBack : function(context, zoomRatio) {
			if(typeof(this.effectByFill) != 'undefined') {
                if(this.effectByFill.backEnable == true) {
                    context.fillStyle = this.effectByFill.backColor;
                    let x = this.border.x * zoomRatio;
                    let y = this.border.y * zoomRatio;
                    let cx = this.border.cx * zoomRatio;
                    let cy = this.border.cy * zoomRatio;
                    switch(this.type) {
                        case "rectangle" : context.fillRect(x, y, cx, cy); break;
                        case "ellipse" : context.drawEllipse(x, y, cx, cy); break;
                    }
                }
			}
		},
		
		fillShape : function(context) {
			if(typeof(this.fill.image) == 'undefined') {
				context.fillStyle = this.fill.color;
				switch(this.type) {
					case "rectangle" : context.fillRect(this.left, this.top, this.width, this.height); break;
					case "ellipse" : context.drawEllipse( this.left, this.top, this.width, this.height, this.line.width,this.image != null); break;
				}
			}
		},
		
		fillImage : function(context) {
			if(typeof(this.fill.image) != 'undefined') {
				if(this.fill.bGIF == false) {
					context.drawImage(this.fill.image, this.left, this.top, this.width, this.height);
				}
				else if(this.fill.image.image != null) {
					context.clearRect(this.left, this.top , this.width, this.height);
					context.drawImage(this.fill.image.image, this.left, this.top, this.width, this.height);
				}
			}
		},
		
		fillText : function(context, ratio) {
			if(typeof(this.fill.text) != 'undefined') {
				context.fillStyle = this.font.textColor;
			
				//let x = this.left + 4, y = this.top + 4;
				let x = this.left, y = this.top;
				let text = this.fill.text + (!!this.effectByValue ? (!!this.effectByValue.unitName ? " "+this.effectByValue.unitName : "") : "");
				let metrics = context.measureText(text);

				switch(this.font.textAlignHorz) {
					case TextAlign.Center : 
						x = this.left + (this.width - metrics.width) / 2; 
						break;
					case TextAlign.Right : 
						x = this.left + this.width - metrics.width; 
						break;
				}
				metrics = context.measureText("M");
				switch(this.font.textAlignVert) {
					case TextAlign.Left : 
						y = this.top + metrics.width;
						break;
					case TextAlign.Center : 
						y = this.top + (this.height - metrics.width) / 2 + metrics.width; 
						break;
					case TextAlign.Right : 
						y = this.top + this.height; 
						break;
				}
				
				context.fillText(text, x, y);
				if (this.fill.bUnderline) {
					metrics = context.measureText(this.m_Text);
				}
			}
		},
		
		recalcRect : function(zoomRatio) {
			this.left = zoomRatio.zoomX * this.x;
			this.top = zoomRatio.zoomY * this.y;
			this.width = zoomRatio.zoom * this.cx;
			this.height = zoomRatio.zoom * this.cy;
			
			if(typeof(this.rotate) != 'undefined') {
				this.rotateRect();
			}
		},
		
		rotateRect : function() {
			let offset = Math.max(this.width, this.height) * 1.2;
		
			this.left -= offset;
			this.top -= offset;
			this.width = offset * 2;
			this.height = offset * 2;
		} 
	}
		
	clearBackground = function(context, uxList, zoom) {
		context.clearRect(0, 0, uxList.width * zoom.zoom, uxList.height * zoom.zoom);
	}
	
	clearShapeBackground = function(context, uxList) {
		context.fillStyle = uxList.backColor;
		for(let shape of uxList.shapes) {
			if(shape.bDraw == false) continue;
			context.clearRect(shape.clearRect.left, shape.clearRect.top, shape.clearRect.width, shape.clearRect.height);
            checkCollision(uxList, shape);
		}
	}

	recalcRect = function(uxList, zoomRatio) {
		for(let shape of uxList.shapes) {
			if(shape.bDraw == false) continue;
			shape.recalcRect(zoomRatio); 
		}
	}
	
	testEffectByColorlist = function(workspace, shape) {
		if(typeof(shape.effectByColorlist) != 'undefined') {
			var effectColor = shape.effectByColorlist.orgColor;
			let tag = workspace.tagList[shape.effectByColorlist.tagName];
         
			if(typeof(tag?.val) != 'undefined') {
				var val = tag.val;
				for(var i = 0; i < shape.effectByColorlist.colorList.length; i++) {
					var item  = shape.effectByColorlist.colorList[i];
					let operSymbol = item.operSymbol.trim();
					if( ( ( operSymbol == "="  ) &&	( val == item.operValue ) ) ||
						( ( operSymbol == "<>" ) &&	( val != item.operValue ) ) ||
						( ( operSymbol == ">"  ) &&	( val >  item.operValue ) ) ||
						( ( operSymbol == "<"  ) &&	( val <  item.operValue ) ) ||
						( ( operSymbol == ">=" ) &&	( val >= item.operValue ) ) ||
						( ( operSymbol == "<=" ) &&	( val <= item.operValue ) ) ) 	{
						effectColor = item.color;
						break;
					}
				}
			}
	
			switch(shape.effectByColorlist.category) {
				case 0 :
					if(effectColor != shape.fill.color) shape.bDraw = true;
					shape.fill.color = effectColor; 
					break;
				case 1 : 
					if(effectColor != shape.line.color) shape.bDraw = true;
					shape.line.color = effectColor; 
					break;
				case 2 : 
					if(effectColor != shape.font.textColor) shape.bDraw = true;
					shape.font.textColor = effectColor;
					break;
			}
		}
	}
	
	
	testEffectByImagelist = function(workspace, shape) {
		if(typeof(shape.effectByImagelist) != 'undefined') {
			var img = shape.effectByImagelist.orgImage;
			let tagName = shape.effectByImagelist.tagName;

			// 쉼표로 구분된 여러 태그 지원 (OR 조건: 하나라도 1이면 On)
			let val = 0;
			if(tagName.indexOf(',') > -1) {
				let tags = tagName.split(',');
				console.log("[effectByImagelist] 다중태그:", tagName);
				for(let t of tags) {
					let trimmedTag = t.trim();
					let tag = workspace.tagList[trimmedTag];
					console.log("  - " + trimmedTag + " =", tag ? tag.val : "(없음)");
					if(typeof(tag) != 'undefined' && tag.val == 1) {
						val = 1;
						break;
					}
				}
				console.log("  => 최종 val:", val);
			} else {
				let tag = workspace.tagList[tagName];
				if(typeof(tag) != 'undefined') {
					val = tag.val;
				}
			}

			for(var i = 0; i < shape.effectByImagelist.imageList.length; i++) {
				var imageItem  = shape.effectByImagelist.imageList[i];
				let operSymbol = imageItem.operSymbol.trim();

				if( ( ( operSymbol == "=" ) &&	( val == Number(imageItem.operValue) ) ) ||
					( ( operSymbol == "<>" ) &&	( val != Number(imageItem.operValue) ) ) ||
					( ( operSymbol == ">" )	 &&	( val >  Number(imageItem.operValue) ) ) ||
					( ( operSymbol == "<" )	 &&	( val <  Number(imageItem.operValue) ) ) ||
					( ( operSymbol == ">=" ) &&	( val >= Number(imageItem.operValue) ) ) ||
					( ( operSymbol == "<=" ) &&	( val <= Number(imageItem.operValue) ) ) ) 	{
					img = imageItem.image;
				}
			}

			if(typeof(img) != 'undefined') {
				if(img != shape.fill.image) shape.bDraw = true;
				shape.fill.image = img;
			}
		}
	}
	
	testEffectByFill = function(workspace, shape) {
		if(typeof(shape.effectByFill) != 'undefined') {
			let tag = workspace.tagList[shape.effectByFill.tagName];
			
			if(typeof(tag) != 'undefined') {
				var ratio = (Number(tag.val) - shape.effectByFill.min) / (shape.effectByFill.max - shape.effectByFill.min);
				ratio = Math.max(ratio, 0);
				ratio = Math.min(ratio, 1);
				
				if(shape.effectByFill.ratio != ratio) {
					shape.effectByFill.ratio = ratio;
                    shape.bDraw = true;
					shape.x = shape.effectByFill.rect.x;
					shape.y = shape.effectByFill.rect.y;
					shape.cx = shape.effectByFill.rect.cx;
					shape.cy = shape.effectByFill.rect.cy;
					
					switch(shape.effectByFill.direction) {
						case 0 : 
							shape.x = (shape.effectByFill.rect.x + shape.effectByFill.rect.cx);
							shape.cx = ratio * shape.effectByFill.rect.cx;
							shape.x -= shape.cx;
							break;
						case 1 : 
							shape.cx = ratio * shape.effectByFill.rect.cx;
							break;
						case 2 : 
							shape.y = (shape.effectByFill.rect.y + shape.effectByFill.rect.cy);
							shape.cy = ratio * shape.effectByFill.rect.cy;
							shape.y -= shape.cy;
							break;
						case 3 :
							shape.cy = ratio * shape.effectByFill.rect.cy;
							break;
					}
				}
			}
		}
	}
	

	drawUxList = function(workspace, zoomRatio, tick) {
		let context = workspace.context;
		let uxList = workspace.uxList;
		for(let shape of uxList.shapes) {
 			
			if(shape.bDraw == false) continue;
			if(shape.show == false) continue;

			shape.left = zoomRatio.zoomX * shape.x;
			shape.top = zoomRatio.zoomY * shape.y;
			shape.width = zoomRatio.zoomX * shape.cx;
			shape.height = zoomRatio.zoomY * shape.cy;
			
			let centerX = shape.left + shape.width * 0.5;
			let centerY = shape.top + shape.height * 0.5;

			context.save();
			
			if(shape.rotate > 0) {
				context.translate(centerX, centerY);
				context.rotate(shape.rotate * Math.PI / 180);

				shape.left = -0.5 * shape.width; 
				shape.top = -0.5 * shape.height; 
			}
			
			
			
			if(typeof(shape.fill) != 'undefined') {
				if(shape.type != "line") {
					context.font = shape.font.fontStyle + " " + (shape.font.fontSize * zoomRatio.zoom).toString() + "px " + shape.font.fontFamily;
                    shape.fillBack(context, zoomRatio.zoom);
                    shape.fillShape(context);
                    shape.fillImage(context);
                    shape.fillText(context);
				}
			}

			shape.drawShape(context);

			

			shape.recalcRect(zoomRatio);
			
			// 트렌드 조회를 위한 태그 더블 클릭시 체크 아이콘 그리기 
			if(shape.select == true) {
				// shape.top -> shape.top + 10 으로 위치 조정함_whs_240522
				context.drawImage(workspace.ckIcon, shape.left, shape.top + 5, 17, 17);
			}

			shape.clearRect.left = shape.border.x * zoomRatio.zoomX - 2 * Math.max(shape.line.width, 1);
			shape.clearRect.top = shape.border.y * zoomRatio.zoomY - 2 * Math.max(shape.line.width, 1);;
			shape.clearRect.width = shape.border.cx *  zoomRatio.zoomX + 4 * Math.max(shape.line.width, 1);
			shape.clearRect.height = shape.border.cy * zoomRatio.zoomY + 4 * Math.max(shape.line.width, 1 );

			shape.bDraw = false;

			context.restore();
		}
        
	}

	isRedrawAll = function(uxList) {
		let bRet = true;
		for(let shape of uxList.shapes) {
			if(shape.bDraw == true) continue;
			bRet = false;
			break;
		}

		return bRet;
	}
	
	checkCollisionPoint = function(shape, x, y) {
		let bRet = false;
		
		if(shape.left <= x && shape.left + shape.width >= x &&
			shape.top <= y && shape.top + shape.height >= y)
			bRet = true;
		
		return bRet;
	}

	checkCollision = function(uxList, shape) {
        let p1 = { x1 : shape.left, y1:shape.top, x2: shape.left + shape.width, y2:shape.top + shape.height};

		for(let obj of uxList.shapes) {
			if(obj.bDraw == true) continue;

            let p2 = { x1 : obj.left, y1:obj.top, x2: obj.left + obj.width, y2:obj.top + obj.height};
			
            if( ((p1.x1 <= p2.x1 && p1.x2 >= p2.x1) || (p1.x1 <= p2.x2 && p1.x2 >= p2.x2)) &&
                ((p1.y1 <= p2.y1 && p1.y2 >= p2.y1) || (p1.y1 <= p2.y2 && p1.y2 >= p2.y2)) ) {
				obj.bDraw = true;	
				checkCollision(uxList, obj);
            }
		}
	}
    
    calcTagValue = function(workspace, tagName, tick) {
        if(tagName.substr(0, 8) == '$COUNTER') {
            let tag = tagName.replace('$COUNTER', '').replace('(', '').replace(')', '');
            let val = tick % Number(tag);

            workspace.tagList[tagName] = { name:tagName, quality:192, val:val };
        }
    }
    
   	calcTag = function(workspace, tick) {
		for(let shape of workspace.uxList.shapes) {
            if(typeof(shape.effectByValue) != 'undefined') { 
                if(shape.effectByValue.tagName?.substr(0, 8) == '$COUNTER')  calcTagValue(workspace, shape.effectByValue.tagName, tick);
            }
            if(typeof(shape.effectByImagelist) != 'undefined') {
                if(shape.effectByImagelist.tagName?.substr(0, 8) == '$COUNTER')  calcTagValue(workspace, shape.effectByImagelist.tagName, tick);
            }
            
            if(typeof(shape.effectByColorlist) != 'undefined') { 
                if(shape.effectByColorlist.tagName?.substr(0, 8) == '$COUNTER')  calcTagValue(workspace, shape.effectByColorlist.tagName, tick);
            }
		}
	}

    invalidateShape = function(base, uxList) {
        let x1 = base.x;
        let y1 = base.y;
        let x2 = base.x + Math.max(base.cx, 0);
        let y2 = base.y + Math.max(base.cy, 0);
   
		for(let shape of uxList.shapes) {
            if(shape.bDraw == true) continue;
            let left = shape.x;
            let right = shape.x + Math.max(shape.cx, 0);
            let top = shape.y;
            let bottom = shape.y + Math.max(shape.cy, 0);
            
            let bVert = (left <= x1 && right >= x1) || (left <= x2 && right >= x2) || (left <= x1 && right <= x2);
            let bHorz = (top <= y1 && bottom >= y1) || (top <= y2 && bottom >= y2) || (top <= y1 && bottom <= y2);
                    
            if(bVert == true && bHorz == true) {
                shape.bDraw = true;
                invalidateShape(shape, uxList);
            }
        }
    }
    
	checkRedraw = function(workspace, uxList, tick) {
		for(let shape of uxList.shapes) {
			if(typeof(shape.fill.image) != 'undefined' && shape.fill.bGIF == true) { 
				shape.bDraw = true;
			}
            
            testEffectByColorlist(workspace, shape);
			testEffectByImagelist(workspace, shape);
			testEffectByFill(workspace, shape);
            
            // Blink 처리
            if(shape.blink == true) {
                shape.show = tick % 6 > 3; 
                shape.bDraw = true;
            }

            
            if(shape.bDraw == false) continue;
            invalidateShape(shape, uxList);
		}
	}

	function render() {}
	render.prototype = {
		calcZoomRate : function(workspace) {
			let width = workspace.canvas.offsetWidth;
			let height = workspace.canvas.offsetHeight;
			
			let zoomRatioX = width / workspace.uxList.width;
			let zoomRatioY = height / workspace.uxList.height;
			
			return {zoomX: zoomRatioX, zoomY: zoomRatioY, zoom: Math.min(zoomRatioX, zoomRatioY)}; //Math.min(zoomRatioX, zoomRatioY);
		},
		
		draw : function(workspace, tick) {
			let zoomRatio = this.calcZoomRate(workspace);
			
			recalcRect(workspace.uxList, zoomRatio);
			checkRedraw(workspace, workspace.uxList, tick);
			calcTag(workspace, tick);
		
			if(isRedrawAll(workspace.uxList) == true){
				clearBackground(workspace.context, workspace.uxList, zoomRatio);
			
			}
			else
				clearShapeBackground(workspace.context, workspace.uxList);
				
			drawUxList(workspace, zoomRatio, tick);
		},
		
		drawBack : function(workspace) {
			let bRet = false;
			let zoomRatio = this.calcZoomRate(workspace);

			let context = workspace.backCanvas.getContext("2d");
			
			if(typeof(workspace.uxList.backImage) != 'undefined') {
				bRet = true;
			//	context.drawImage(workspace.uxList.backImage, 0, 0, workspace.uxList.width * zoomRatio, workspace.uxList.height * zoomRatio);
				context.drawImage(workspace.uxList.backImage, 0, 0, workspace.canvas.width, workspace.canvas.height);  // 20240927 dsan khr
			}
			else {
				bRet = true;
				context.fillStyle = workspace.uxList.backColor;
				context.fillRect(0, 0, workspace.uxList.width * zoomRatio.zoom, workspace.uxList.height * zoomRatio.zoom);
			}
			
			return bRet;
		},
		
		uxBase : uxBase
	}
	
	bizRender.render = new render();
}(bizRender, jQuery));

(function(bizRender, $, undefined) {
	let m_strResourcePath = "";
	Preloader = function(workspace) {
		// Create events
		let LoadCompleteEvent = document.createEvent("Event");
		let LoadErrorEvent = document.createEvent("Event");

		let m_nRequested = 0, m_nCompleted = 0;

		this.init = function() {
			m_nRequested = 0, m_nCompleted = 0;
			// Initialize events
			LoadCompleteEvent.initEvent("LoadComplete", true, false);
			LoadErrorEvent.initEvent("LoadError", true, false);
		
			document.addEventListener("LoadComplete", this.OnLoadComplete);
			document.addEventListener("LoadError", this.OnLoadError);
		}
		
		this.loadImage = function(imgSrc) {
			m_nRequested++;
			
			let image = new Image();
			image.onload = function() {
				m_nCompleted++;
				if (m_nRequested == m_nCompleted) {
					document.dispatchEvent(LoadCompleteEvent);
					for(let shape of workspace.uxList.shapes) {
						shape.bDraw = true;
					}
				}
			}
			
			image.onerror = function() 	{
				m_nCompleted++;
				document.dispatchEvent(LoadErrorEvent);
			}
			
			image.src = imgSrc;
			
			return image;
		}
		
		this.clearLoadComplete = function() {
			document.removeEventListener("LoadComplete", this.OnLoadComplete);
		}
	}
	
	getRGBA = function(rrggbb, opacity) {
		let A = opacity;
		let R = rrggbb & 255;
		let G = rrggbb >> 8 & 255;
		let B = rrggbb >> 16 & 255;

		let colhexa = "rgba(" + R.toString() + "," + G.toString() + "," + B.toString() + "," + A.toString() + ")";
		
		return colhexa;
	}

	onFontAttribute = function(xmlNode, shape) {
		shape.font = new Object();
		shape.font.bUnderline = false;
		
		shape.font.fontFamily = "";
		shape.font.fontSize = 10;
		shape.font.fontStyle = "";
		
		for(let childNode of xmlNode.childNodes)  {
			if(childNode.firstChild == null) continue;
			switch(childNode.nodeName) {
				case "fontFamily": shape.font.fontFamily = childNode.firstChild.data; break;
				case "fontSize":  shape.font.fontSize = Number(childNode.firstChild.data) * 1.5; break;
				case "textColor": shape.font.textColor = getRGBA(Number(childNode.firstChild.data), 1.0); break;
				case "fontStyle": 
					switch(Number(childNode.firstChild.data)) {
						case 1 : shape.font.fontStyle = "bold"; break;
						case 2 : shape.font.fontStyle = "italic"; break;
						case 4 : shape.font.bUnderline = true; break;
					}
					break;
				case "textAlignVert": shape.font.textAlignVert = Number(childNode.firstChild.data); break;
				case "textAlignHorz": shape.font.textAlignHorz = Number(childNode.firstChild.data); break;
				case "textDirection": shape.font.textDirection = Number(childNode.firstChild.data); break;
			}
		}	
	}	
	
	onLineAttribute = function(xmlNode, shape) {
		shape.line = new Object();
		let lineRGB = 0, lineOpacity = 0;
		for(let childNode of xmlNode.childNodes) {
			if(childNode.firstChild == null) continue;
			switch(childNode.nodeName) {
				case "lineColor": lineRGB = Number(childNode.firstChild.data); break;
				case "lineOpacity": lineOpacity = Number(childNode.firstChild.data); break;
				case "lineWidth": shape.line.width = Number(childNode.firstChild.data);  break;
				case "lineStyle": shape.line.style = Number(childNode.firstChild.data); break;
				case "lineRadius": shape.line.radius = Number(childNode.firstChild.data);  break;
				case "lineStartCap": break;
				case "lineEndCap": break;
			}
		}	
		
		shape.line.color = getRGBA(lineRGB, lineOpacity / 255);
	}
	
	onFillAttribute = function(xmlNode, shape, preLoader) {
		let fillRGB = 0, fillOpacity = 0;
		let strImagePath = m_strResourcePath + "/";
		
		shape.fill = new Object();
		shape.fill.text ="";
				
		for(let childNode of xmlNode.childNodes) {
			if(childNode.firstChild == null) continue;
			switch(childNode.nodeName)
			{
				case "fillColor": fillRGB = Number(childNode.firstChild.data); 	break;
				case "fillOpacity":  fillOpacity = Number(childNode.firstChild.data); break;
				case "text": 
					if(childNode.firstChild != null) shape.fill.text = childNode.firstChild.data; 
					break;
				case "image": 
					if(childNode.firstChild != null) {
						strImagePath = strImagePath + childNode.firstChild.data;
						shape.fill.bGIF = false;
						if(strImagePath.substr(-3).toLowerCase() == 'gif') 	{
							shape.fill.bGIF = true;
							shape.fill.image = new GIF();
							shape.fill.image.load(strImagePath);
						}
						else
							shape.fill.image = preLoader.loadImage(strImagePath);
					}
					break;
			}
		}	
		
		shape.fill.color = getRGBA(fillRGB, fillOpacity / 255);
	}
	
	onShadowAttribute = function(xmlNode, shape) {
		shape.shadow = new Object();
		for (let childNode of xmlNode.childNodes)  {
			if(childNode.firstChild == null) continue;
			switch(childNode.nodeName) {
				case "shadowDirection": shape.shadow.diection = Number(childNode.firstChild.data); break;
				case "shadowColor": shape.shadow.color = getRGBA(Number(childNode.firstChild.data), 1.0); break;
				case "shadowOffset": shape.shadow.offset = Number(childNode.firstChild.data); break;
			}
		}	
	}
	
	onEffectByValue = function(xmlNode, shape)  {
		shape.effectByValue = new  Object();
		shape.effectByValue.orgText = shape.fill.text;
		for (let childNode of xmlNode.childNodes) {
			if(childNode.firstChild == null) continue;
			switch(childNode.nodeName) {
				case "tagName": shape.effectByValue.tagName = childNode.firstChild.data; break;
				case "unit":  shape.effectByValue.unitName = childNode.firstChild.data;	break;
				case "decPos": shape.effectByValue.decPos = Number(childNode.firstChild.data); break;
				case "commaDelimited" : shape.effectByValue.commaDelimeted = childNode.firstChild.data == "1" ? true : false; break;
				case "length" :	shape.effectByValue.length = Number(childNode.firstChild.data);	break;
			}
		}	
	}
	
	onEffectByFill = function(xmlNode, shape) {
		shape.effectByFill = new  Object();
		for (let childNode of xmlNode.childNodes) {
			if(childNode.firstChild == null) continue;
			shape.effectByFill.rect = { x:shape.x, y:shape.y, cx:shape.cx, cy:shape.cy };
			shape.effectByFill.ratio = 0.000001;
			switch(childNode.nodeName) {
				case "tagName": shape.effectByFill.tagName = childNode.firstChild.data; break;
				case "direction": shape.effectByFill.direction = Number(childNode.firstChild.data); break;
				case "minValue": shape.effectByFill.min = Number(childNode.firstChild.data); break;
				case "maxValue" : shape.effectByFill.max = Number(childNode.firstChild.data); break;
				case "backColor" : shape.effectByFill.backColor = getRGBA(Number(childNode.firstChild.data), 1.0); break;
				case "backEnable" : shape.effectByFill.backEnable = Number(childNode.firstChild.data) == 0 ? false : true; break;
			}
		}	
	}
	
	onEffectByOpaque = function(xmlNode, shape) {
		shape.effectByOpaque = new  Object();
		for (let childNode of xmlNode.childNodes) {
		if(childNode.firstChild == null) continue;
		switch(childNode.nodeName) {
				case "tagName": shape.effectByOpaque.tagName = childNode.firstChild.data; break;
				case "minValue": shape.effectByOpaque.min = Number(childNode.firstChild.data); break;
				case "maxValue" : shape.effectByOpaque.max = Number(childNode.firstChild.data);	break;
			}
		}	
	}
	
	onEffectByColorlist = function(xmlNode, shape) {
		shape.effectByColorlist = new  Object();
		shape.effectByColorlist.colorList = new Array();
		for (let childNode of xmlNode.childNodes) {
			if(childNode.firstChild == null) continue;
			switch(childNode.nodeName){
				case "tagName": shape.effectByColorlist.tagName = childNode.firstChild.data;
				case "category": shape.effectByColorlist.category = Number(childNode.firstChild.data);break;
				case "color" : {
					let colorAttr = { color : null, from : 0, to : 0 };
					colorAttr.color = getRGBA(Number(childNode.firstChild.data), 1.0);
					colorAttr.operValue = childNode.getAttribute('operValue');
					colorAttr.operSymbol = childNode.getAttribute('operSymbol');
						
					shape.effectByColorlist.colorList.push(colorAttr);
				}
				break;
			}
		}

		switch(shape.effectByColorlist.category) {
			case 0 : shape.effectByColorlist.orgColor = shape.fill.color; break;
			case 1 : shape.effectByColorlist.orgColor = shape.line.color; break;
			case 2 : shape.effectByColorlist.orgColor = shape.font.textColor; break;
		}
	}
	
	onEffectByImagelist = function(xmlNode, shape, preLoader) {
		shape.effectByImagelist = new Object();
		shape.effectByImagelist.orgImage = shape.fill.image;
		shape.effectByImagelist.imageList = new Array();
		for (let childNode of xmlNode.childNodes) {
			if(childNode.firstChild == null) continue;
			switch(childNode.nodeName){
				case "tagName": shape.effectByImagelist.tagName = childNode.firstChild.data; break;
				case "image" : {
					shape.fill.bGIF = false;
											
					var strImagePath = m_strResourcePath + "/" + childNode.firstChild.data;
					var imageAttr = { image : null, operValue : 0, operSymbol : "" };
					imageAttr.image = preLoader.loadImage(strImagePath);
					imageAttr.operValue = childNode.getAttribute('operValue');
					imageAttr.operSymbol = childNode.getAttribute('operSymbol');
					
					shape.effectByImagelist.imageList.push(imageAttr);
				}
				break;
			}
		}
	}
	
	onEffectByLink = function(xmlNode, shape) {
		shape.effectByLink = new Object();
		for (let childNode of xmlNode.childNodes) {
			if(childNode.firstChild == null) continue;
			switch(childNode.nodeName) {
				case "link": shape.effectByLink.link = childNode.firstChild.data; break;
			}
		}
	}
    
   	onEffectByBlink = function(xmlNode, shape) {
		for (let childNode of xmlNode.childNodes) {
			if(childNode.firstChild == null) continue;
			switch(childNode.nodeName) {
				case "blink": shape.blink = childNode.firstChild.data == "1" ? true : false; break;
			}
		}
	}

	onGaugeProperties = function(xmlNode, shape) {
		shape.gaugeProperties = new Object();
		for (let childNode of xmlNode.childNodes) {
			if(childNode.firstChild == null) continue;
			switch(childNode.nodeName) {
				case "niddleColor": shape.gaugeProperties.niddleColor = getRGBA(Number(childNode.firstChild.data), 1.0); break;
				case "baseColor" : shape.gaugeProperties.baseColor = getRGBA(Number(childNode.firstChild.data), 1.0); break;
				case "GradientColor" : shape.gaugeProperties.gradientColor = getRGBA(Number(childNode.firstChild.data), 1.0); break;
			}
		}
	}
	
	onTagList = function(xmlNode, shape) {
		shape.chartProperties.tagList = new Array();
		for (let childNode of xmlNode.childNodes) {
			if(childNode.firstChild == null) continue;
			if(childNode.nodeName == "tagAttr")	{
				var tagAttr = { tagName : "", color : null, method : 0, lastValue : "", displayText : "", refreshTime : null };

				tagAttr.tagName = childNode.firstChild.data;
				tagAttr.color = GetRGBA(Number(childNode.getAttribute('color')), 1.0);
				tagAttr.method = Number(childNode.getAttribute('method'));
				tagAttr.displayText = childNode.getAttribute('displayText');
				
				shape.chartProperties.tagList.push(tagAttr);
			}
		}
	}
	
	onChartProperties = function(xmlNode, shape) {
		shape.chartProperties = new Object();
		
		for (let childNode of xmlNode.childNodes) {
			if(childNode.firstChild == null) continue;
			switch(childNode.nodeName) {
				case "timeBase": shape.chartProperties.timeBase = Number(childNode.firstChild.data); break;
				case "timeType": shape.chartProperties.timeType = Number(childNode.firstChild.data); break;
				case "from" : shape.chartProperties.from = Number(childNode.firstChild.data); break;
				case "to" : shape.chartProperties.to = Number(childNode.firstChild.data); break;
				case "step" : shape.chartProperties.step = Number(childNode.firstChild.data);	break;
				case "span" : shape.chartProperties.span = Number(childNode.firstChild.data); break;
				case "min" :  shape.chartProperties.min = Number(childNode.firstChild.data); break;
				case "max" : shape.chartProperties.max = Number(childNode.firstChild.data); break;
				case "tagList":  onTagList(childNode, UxElement); break;
			}
		}
	}
	
	onAttributes = function(workspace, xmlNode, shape, preLoader)	{
		let strName 	= xmlNode.getAttribute('name');
		let strLeft 	= xmlNode.getAttribute('left');
		let strTop 		= xmlNode.getAttribute('top');
		let strWidth 	= xmlNode.getAttribute('width');
		let strHeight 	= xmlNode.getAttribute('height');
		let rotate 		= xmlNode.getAttribute('rotateAngle');
		let flipVert 	= xmlNode.getAttribute('flipVert');
		let flipHorz 	= xmlNode.getAttribute('flipHorz');

		if(strName != null && strName != "") {
			shape.name = strName;
			workspace.shapeNames[strName] = shape;
		}
		if(strLeft != null) shape.x = shape.border.x = Number(strLeft);
		if(strTop != null) shape.y = shape.border.y = Number(strTop);
		if(strWidth != null) shape.cx = shape.border.cx = Number(strWidth);
		if(strHeight != null) shape.cy = shape.border.cy = Number(strHeight);

		if(rotate != null && rotate > 0) shape.rotate = Number(rotate);
		if(flipVert != null) shape.flipVert = Number(flipVert);
		if(flipHorz != null) shape.flipHorz = Number(flipHorz);

		for(let childNode of xmlNode.childNodes) {
			switch(childNode.nodeName) {
				case "font": onFontAttribute(childNode, shape); break;
				case "line": onLineAttribute(childNode, shape); break;
				case "fill": onFillAttribute(childNode, shape, preLoader); break;
				case "shadow": onShadowAttribute(childNode, shape); break;
				case "effectByValue": onEffectByValue(childNode, shape); break;
				case "effectByFill" : onEffectByFill(childNode, shape); break;
				case "effectByOpacity" : onEffectByOpaque(childNode, shape); break;
				case "effectByColorlist" : onEffectByColorlist(childNode, shape); break;
				case "effectByImagelist" : onEffectByImagelist(childNode, shape, preLoader); break;
				case "effectByLink" : onEffectByLink(childNode, shape); break;
				case "effectByBlink" : onEffectByBlink(childNode, shape); break;
				case "gaugeProperties" : onGaugeProperties(childNode, shape); break;
				case "chartAttributes" : onChartProperties(childNode, shape); break;
			}
		}
	}
	
	onShape = function(xmlNode, workspace, preLoader) {
		let shapes = workspace.uxList.shapes;
		let shape = new bizRender.render.uxBase();

		shape.type = xmlNode.nodeName;
		onAttributes(workspace, xmlNode, shape, preLoader);
		shapes.push(shape)
	}	
	
	let onParseComplete = function(workspace, preLoader) {
		workspace.clearBack = false;
		workspace.onSuccess();
	}
	
	function loader() {}
	
	loader.prototype = {
		self : this,
		load : function (fileName, workspace) {
			fileName = workspace.layoutPath + fileName + ".xml";

			let preLoader = new Preloader(workspace);
					
			preLoader.OnLoadComplete = function()  { 
				onParseComplete(workspace, preLoader);
				preLoader.clearLoadComplete();
			}
			
			preLoader.init();
	
			this.loadLayout(fileName, workspace, preLoader);
		
			let idx = fileName.lastIndexOf(".");
			if(idx != -1)
				m_strResourcePath = fileName.substr(0, idx) + ".resources";
		},
		loadLayout : function(url, workspace, preLoader) {
			let d = this;
			let xmlHttp = new XMLHttpRequest();
			
			xmlHttp.open("GET", url, true);
		
			xmlHttp.onreadystatechange = function (aEvt) {
				if(xmlHttp.readyState == 4) {
					if(xmlHttp.status  = 200) {
						bErr = false;
						
						if(xmlHttp.responseXML != null) {
							workspace.uxList = new Object();
							workspace.uxList.shapes = new Array();
							parseXml(xmlHttp.responseXML, workspace, preLoader);
						}else{
							alert('layout file not found!. url:' + url );
							location.href = "db0101";
						}
					}
				}
			}
			xmlHttp.send(null);
		}
	}
	let	parseRoot = function(xmlNode, preLoader, uxList) {
		uxList.width = Number(xmlNode.getAttribute('width'));
		uxList.height = Number(xmlNode.getAttribute('height'));
		uxList.backColor = getRGBA(Number(xmlNode.getAttribute('backColor')), 1);
		let backImage = xmlNode.getAttribute('backImage');
		
		if(backImage != null && backImage.length > 0) {
			var strImagePath = m_strResourcePath + "/" + backImage;
			uxList.backImage = preLoader.loadImage(strImagePath);
		}
	}
	
	let	parseXml = function(dom, workspace, preLoader) {
		let root = dom.documentElement;
		parseRoot(root, preLoader, workspace.uxList);
		
		for(let xmlNode of root.childNodes) {
			if(xmlNode.nodeName == "#text") continue;
			if(xmlNode.nodeName == "sql") continue;
			if(xmlNode.nodeName == "jsScript") {
				workspace.jsScript = xmlNode.firstChild.data;
				continue;
			}

			if(xmlNode.nodeName == "group") {
				for(let childNode of xmlNode.childNodes) {
					if(childNode.nodeName == "#text") continue;
					onShape(childNode, workspace, preLoader);
					//onShape(childNode, workspace.uxList.shapes, preLoader);
				}
			}
			else
				onShape(xmlNode, workspace, preLoader);
		}
	}
	
	bizRender.loader = new loader();
}(bizRender, jQuery));

const GIF = function () {
	// **NOT** for commercial use.
	var timerID;						  // timer handle for set time out
											// usage
	var st;							   // holds the stream object when
											// loading.
	var interlaceOffsets  = [0, 4, 2, 1]; // used in de-interlacing.
	var interlaceSteps	= [8, 8, 4, 2];
	var interlacedBufSize;  // this holds a buffer to de interlace. Created on
							// the first frame and when size changed
	var deinterlaceBuf;
	var pixelBufSize;	// this holds a buffer for pixels. Created on the
							// first frame and when size changed
	var pixelBuf;
	const GIF_FILE = { // gif file data headers
		GCExt   : 0xF9,
		COMMENT : 0xFE,
		APPExt  : 0xFF,
		UNKNOWN : 0x01, // not sure what this is but need to skip it in parser
		IMAGE   : 0x2C,
		EOF	 : 59,   // This is entered as decimal
		EXT	 : 0x21,
	};	  
	// simple buffered stream used to read from the file
	var Stream = function (data) { 
		this.data = new Uint8ClampedArray(data);
		this.pos  = 0;
		var len   = this.data.length;
		this.getString = function (count) { // returns a string from current pos
											// of len count
			var s = "";
			while (count--) { s += String.fromCharCode(this.data[this.pos++]) }
			return s;
		};
		this.readSubBlocks = function () { // reads a set of blocks as a string
			var size, count, data  = "";
			do {
				count = size = this.data[this.pos++];
				while (count--) { data += String.fromCharCode(this.data[this.pos++]) }
			} while (size !== 0 && this.pos < len);
			return data;
		}
		this.readSubBlocksB = function () { // reads a set of blocks as binary
			var size, count, data = [];
			do {
				count = size = this.data[this.pos++];
				while (count--) { data.push(this.data[this.pos++]);}
			} while (size !== 0 && this.pos < len);
			return data;
		}
	};
	// LZW decoder uncompressed each frames pixels
	// this needs to be optimised.
	// minSize is the min dictionary as powers of two
	// size and data is the compressed pixels
	function lzwDecode(minSize, data) {
		var i, pixelPos, pos, clear, eod, size, done, dic, code, last, d, len;
		pos = pixelPos = 0;
		dic	  = [];
		clear	= 1 << minSize;
		eod	  = clear + 1;
		size	 = minSize + 1;
		done	 = false;
		while (!done) { // JavaScript optimisers like a clear exit though I
						// never use 'done' apart from fooling the optimiser
			last = code;
			code = 0;
			for (i = 0; i < size; i++) {
				if (data[pos >> 3] & (1 << (pos & 7))) { code |= 1 << i }
				pos++;
			}
			if (code === clear) { // clear and reset the dictionary
				dic = [];
				size = minSize + 1;
				for (i = 0; i < clear; i++) { dic[i] = [i] }
				dic[clear] = [];
				dic[eod] = null;
			} else {
				if (code === eod) {  done = true; return }
				if (code >= dic.length) { dic.push(dic[last].concat(dic[last][0])) }
				else if (last !== clear) { dic.push(dic[last].concat(dic[code][0])) }
				d = dic[code];
				len = d.length;
				for (i = 0; i < len; i++) { pixelBuf[pixelPos++] = d[i] }
				if (dic.length === (1 << size) && size < 12) { size++ }
			}
		}
	};
	function parseColourTable(count) { // get a colour table of length count
										// Each entry is 3 bytes, for RGB.
		var colours = [];
		for (var i = 0; i < count; i++) { colours.push([st.data[st.pos++], st.data[st.pos++], st.data[st.pos++]]) }
		return colours;
	}
	function parse (){		// read the header. This is the starting point
								// of the decode and async calls parseBlock
		var bitField;
		st.pos				+= 6;  
		gif.width			 = (st.data[st.pos++]) + ((st.data[st.pos++]) << 8);
		gif.height			= (st.data[st.pos++]) + ((st.data[st.pos++]) << 8);
		bitField			  = st.data[st.pos++];
		gif.colorRes		  = (bitField & 0b1110000) >> 4;
		gif.globalColourCount = 1 << ((bitField & 0b111) + 1);
		gif.bgColourIndex	 = st.data[st.pos++];
		st.pos++;					// ignoring pixel aspect ratio. if not
										// 0, aspectRatio = (pixelAspectRatio +
										// 15) / 64
		if (bitField & 0b10000000) { gif.globalColourTable = parseColourTable(gif.globalColourCount) } // global
																										// colour
																										// flag
		setTimeout(parseBlock, 0);
	}
	function parseAppExt() { // get application specific data. Netscape added
								// iterations and terminator. Ignoring that
		st.pos += 1;
		if ('NETSCAPE' === st.getString(8)) { st.pos += 8 }  // ignoring this
																// data.
																// iterations
																// (word) and
																// terminator
																// (byte)
		else {
			st.pos += 3;			// 3 bytes of string usually "2.0" when
									// identifier is NETSCAPE
			st.readSubBlocks();	 // unknown app extension
		}
	};
	function parseGCExt() { // get GC data
		var bitField;
		st.pos++;
		bitField			  = st.data[st.pos++];
		gif.disposalMethod	= (bitField & 0b11100) >> 2;
		gif.transparencyGiven = bitField & 0b1 ? true : false; // ignoring bit
																// two that is
																// marked as
																// userInput???
		gif.delayTime		 = (st.data[st.pos++]) + ((st.data[st.pos++]) << 8);
		gif.transparencyIndex = st.data[st.pos++];
		st.pos++;
	};
	function parseImg() {						   // decodes image data to
													// create the indexed pixel
													// image
		var deinterlace, frame, bitField;
		deinterlace = function (width) {				   // de interlace
															// pixel data if
															// needed
			var lines, fromLine, pass, toline;
			lines = pixelBufSize / width;
			fromLine = 0;
			if (interlacedBufSize !== pixelBufSize) {	  // create the buffer
															// if size changed
															// or undefined.
				deinterlaceBuf = new Uint8Array(pixelBufSize);
				interlacedBufSize = pixelBufSize;
			}
			for (pass = 0; pass < 4; pass++) {
				for (toLine = interlaceOffsets[pass]; toLine < lines; toLine += interlaceSteps[pass]) {
					deinterlaceBuf.set(pixelBuf.subArray(fromLine, fromLine + width), toLine * width);
					fromLine += width;
				}
			}
		};
		frame				= {}
		gif.frames.push(frame);
		frame.disposalMethod = gif.disposalMethod;
		frame.time		   = gif.length;
		frame.delay		  = gif.delayTime * 10;
		gif.length		  += frame.delay;
		if (gif.transparencyGiven) { frame.transparencyIndex = gif.transparencyIndex }
		else { frame.transparencyIndex = undefined }
		frame.leftPos = (st.data[st.pos++]) + ((st.data[st.pos++]) << 8);
		frame.topPos  = (st.data[st.pos++]) + ((st.data[st.pos++]) << 8);
		frame.width   = (st.data[st.pos++]) + ((st.data[st.pos++]) << 8);
		frame.height  = (st.data[st.pos++]) + ((st.data[st.pos++]) << 8);
		bitField	  = st.data[st.pos++];
		frame.localColourTableFlag = bitField & 0b10000000 ? true : false; 
		if (frame.localColourTableFlag) { frame.localColourTable = parseColourTable(1 << ((bitField & 0b111) + 1)) }
		if (pixelBufSize !== frame.width * frame.height) { // create a pixel
															// buffer if not yet
															// created or if
															// current frame
															// size is different
															// from previous
			pixelBuf	 = new Uint8Array(frame.width * frame.height);
			pixelBufSize = frame.width * frame.height;
		}
		lzwDecode(st.data[st.pos++], st.readSubBlocksB()); // decode the pixels
		if (bitField & 0b1000000) {						// de interlace if
															// needed
			frame.interlaced = true;
			deinterlace(frame.width);
		} else { frame.interlaced = false }
		processFrame(frame);							   // convert to canvas
															// image
	};
	function processFrame(frame) { // creates a RGBA canvas image from the
									// indexed pixel data.
		var ct, cData, dat, pixCount, ind, useT, i, pixel, pDat, col, frame, ti;
		frame.image		= document.createElement('canvas');
		frame.image.width  = gif.width;
		frame.image.height = gif.height;
		frame.image.ctx	= frame.image.getContext("2d");
		ct = frame.localColourTableFlag ? frame.localColourTable : gif.globalColourTable;
		if (gif.lastFrame === null) { gif.lastFrame = frame }
		useT = (gif.lastFrame.disposalMethod === 2 || gif.lastFrame.disposalMethod === 3) ? true : false;
		if (!useT) { frame.image.ctx.drawImage(gif.lastFrame.image, 0, 0, gif.width, gif.height) }
		cData = frame.image.ctx.getImageData(frame.leftPos, frame.topPos, frame.width, frame.height);
		ti  = frame.transparencyIndex;
		dat = cData.data;
		if (frame.interlaced) { pDat = deinterlaceBuf }
		else { pDat = pixelBuf }
		pixCount = pDat.length;
		ind = 0;
		for (i = 0; i < pixCount; i++) {
			pixel = pDat[i];
			col   = ct[pixel];
			if (ti !== pixel) {
				dat[ind++] = col[0];
				dat[ind++] = col[1];
				dat[ind++] = col[2];
				dat[ind++] = 255;	  // Opaque.
			} else
				if (useT) {
					dat[ind + 3] = 0; // Transparent.
					ind += 4;
				} else { ind += 4 }
		}
		frame.image.ctx.putImageData(cData, frame.leftPos, frame.topPos);
		gif.lastFrame = frame;
		if (!gif.waitTillDone && typeof gif.onload === "function") { doOnloadEvent() }// if !waitTillDone the call onload now after first frame is loaded
	};
	// **NOT** for commercial use.
	function finnished() { // called when the load has completed
		gif.loading		   = false;
		gif.frameCount		= gif.frames.length;
		gif.lastFrame		 = null;
		st					= undefined;
		gif.complete		  = true;
		gif.disposalMethod	= undefined;
		gif.transparencyGiven = undefined;
		gif.delayTime		 = undefined;
		gif.transparencyIndex = undefined;
		gif.waitTillDone	  = undefined;
		pixelBuf			  = undefined; // dereference pixel buffer
		deinterlaceBuf		= undefined; // dereference interlace buff (may or may not be used);
		pixelBufSize		  = undefined;
		deinterlaceBuf		= undefined;
		gif.currentFrame	  = 0;
		if (gif.frames.length > 0) { gif.image = gif.frames[0].image }
		doOnloadEvent();
		if (typeof gif.onloadall === "function") {
			(gif.onloadall.bind(gif))({   type : 'loadall', path : [gif] });
		}
		if (gif.playOnLoad) { gif.play() }
	}
	function canceled () { // called if the load has been cancelled
		finnished();
		if (typeof gif.cancelCallback === "function") { (gif.cancelCallback.bind(gif))({ type : 'canceled', path : [gif] }) }
	}
	function parseExt() {			  // parse extended blocks
		const blockID = st.data[st.pos++];
		if(blockID === GIF_FILE.GCExt) { parseGCExt() }
		else if(blockID === GIF_FILE.COMMENT) { gif.comment += st.readSubBlocks() }
		else if(blockID === GIF_FILE.APPExt) { parseAppExt() }
		else {
			if(blockID === GIF_FILE.UNKNOWN) { st.pos += 13; } // skip unknow block
			st.readSubBlocks();
		}

	}
	function parseBlock() { // parsing the blocks
		if (gif.cancel !== undefined && gif.cancel === true) { canceled(); return }

		const blockId = st.data[st.pos++];
		if(blockId === GIF_FILE.IMAGE ){ // image block
			parseImg();
			if (gif.firstFrameOnly) { finnished(); return }
		}else if(blockId === GIF_FILE.EOF) { finnished(); return }
		else { parseExt() }
		if (typeof gif.onprogress === "function") {
			gif.onprogress({ bytesRead  : st.pos, totalBytes : st.data.length, frame : gif.frames.length });
		}
		setTimeout(parseBlock, 0); // parsing frame async so processes can get some time in.
	};
	function cancelLoad(callback) { // cancels the loading. This will cancel the load before the next frame is decoded
		if (gif.complete) { return false }
		gif.cancelCallback = callback;
		gif.cancel		 = true;
		return true;
	}
	function error(type) {
		if (typeof gif.onerror === "function") { (gif.onerror.bind(this))({ type : type, path : [this] }) }
		gif.onload  = gif.onerror = undefined;
		gif.loading = false;
	}
	function doOnloadEvent() { // fire onload event if set
		gif.currentFrame = 0;
		gif.nextFrameAt  = gif.lastFrameAt  = new Date().valueOf(); // just sets the time now
		if (typeof gif.onload === "function") { (gif.onload.bind(gif))({ type : 'load', path : [gif] }) }
		gif.onerror = gif.onload  = undefined;
	}
	function dataLoaded(data) { // Data loaded create stream and parse
		st = new Stream(data);
		parse();
	}
	function loadGif(filename) { // starts the load
		var ajax = new XMLHttpRequest();
		ajax.responseType = "arraybuffer";
		ajax.onload = function (e) {
			if (e.target.status === 404) { error("File not found") }
			else if(e.target.status >= 200 && e.target.status < 300 ) { dataLoaded(ajax.response) }
			else { error("Loading error : " + e.target.status) }
		};
		ajax.open('GET', filename, true);
		ajax.send();
		ajax.onerror = function (e) { error("File error") };
		this.src = filename;
		this.loading = true;
	}
	function play() { // starts play if paused
		if (!gif.playing) {
			gif.paused  = false;
			gif.playing = true;
			playing();
		}
	}
	function pause() { // stops play
		gif.paused  = true;
		gif.playing = false;
		clearTimeout(timerID);
	}
	function togglePlay(){
		if(gif.paused || !gif.playing){ gif.play() }
		else{ gif.pause() }
	}
	function seekFrame(frame) { // seeks to frame number.
		clearTimeout(timerID);
		gif.currentFrame = frame % gif.frames.length;
		if (gif.playing) { playing() }
		else { gif.image = gif.frames[gif.currentFrame].image }
	}
	function seek(time) { // time in Seconds // seek to frame that would be displayed at time
		clearTimeout(timerID);
		if (time < 0) { time = 0 }
		time *= 1000; // in ms
		time %= gif.length;
		var frame = 0;
		while (time > gif.frames[frame].time + gif.frames[frame].delay && frame < gif.frames.length) {  frame += 1 }
		gif.currentFrame = frame;
		if (gif.playing) { playing() }
		else { gif.image = gif.frames[gif.currentFrame].image}
	}
	function playing() {
		var delay;
		var frame;
		if (gif.playSpeed === 0) {
			gif.pause();
			return;
		} else {
			if (gif.playSpeed < 0) {
				gif.currentFrame -= 1;
				if (gif.currentFrame < 0) {gif.currentFrame = gif.frames.length - 1 }
				frame = gif.currentFrame;
				frame -= 1;
				if (frame < 0) {  frame = gif.frames.length - 1 }
				delay = -gif.frames[frame].delay * 1 / gif.playSpeed;
			} else {
				gif.currentFrame += 1;
				gif.currentFrame %= gif.frames.length;
				delay = gif.frames[gif.currentFrame].delay * 1 / gif.playSpeed;
			}
			gif.image = gif.frames[gif.currentFrame].image;
			timerID = setTimeout(playing, delay);
		}
	}
	var gif = {					  // the gif image object
		onload		 : null,	   // fire on load. Use waitTillDone = true to have load fire at end or false to fire on first frame
		onerror		: null,	   // fires on error
		onprogress	 : null,	   // fires a load progress event
		onloadall	  : null,	   // event fires when all frames have loaded and gif is ready
		paused		 : false,	  // true if paused
		playing		: false,	  // true if playing
		waitTillDone   : true,	   // If true onload will fire when all frames loaded, if false, onload will fire when first frame has loaded
		loading		: false,	  // true if still loading
		firstFrameOnly : false,	  // if true only load the first frame
		width		  : null,	   // width in pixels
		height		 : null,	   // height in pixels
		frames		 : [],		 // array of frames
		comment		: "",		 // comments if found in file. Note I remember that some gifs have comments per frame if so this will be all comment concatenated
		length		 : 0,		  // gif length in ms (1/1000 second)
		currentFrame   : 0,		  // current frame.
		frameCount	 : 0,		  // number of frames
		playSpeed	  : 1,		  // play speed 1 normal, 2 twice 0.5 half, -1 reverse etc...
		lastFrame	  : null,	   // temp hold last frame loaded so you can display the gif as it loads
		image		  : null,	   // the current image at the currentFrame
		playOnLoad	 : true,	   // if true starts playback when loaded
		// functions
		load		   : loadGif,	// call this to load a file
		cancel		 : cancelLoad, // call to stop loading
		play		   : play,	   // call to start play
		pause		  : pause,	  // call to pause
		seek		   : seek,	   // call to seek to time
		seekFrame	  : seekFrame,  // call to seek to frame
		togglePlay	 : togglePlay, // call to toggle play and pause state
	};
	return gif;
}

function NumbericFormat(nVal, nDec, bComma) {
	if(typeof nVal == 'undefined')
		return nVal;
	else {
		var strVal = "";
		if(typeof(nVal) == 'number') {
			nVal = nVal.toFixed(nDec);

			var strVal = nVal.toString();
			
			var decPart = strVal.split(".");
			if(bComma == true)
				strVal = decPart[0].replace(/\B(?=(\d{3})+(?!\d))/g,",") + (decPart[1] ? "." + decPart[1] : "");
		}
		else
			strVal = nVal;
		
		return strVal;
	}
}
