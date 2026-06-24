// 태그 값 가져오기
const getQueryParameter = (name) => {
	let urlParams = new URLSearchParams(window.location.search);
	return tagValue = urlParams.get(name);
};


// 조회기간 설정
const setDateTime = (dateElement, timeElement, time) => {
	let date = new Date(time);
	let dateOnly = date.getFullYear() + "-" 
		+ String(date.getMonth() + 1).padStart(2, "0") + "-" 
		+ String(date.getDate()).padStart(2, "0");
	let timeOnly = String(date.getHours()).padStart(2, "0") + ":00:00";

	dateElement.val(dateOnly);
	dateElement.attr("max", dateOnly)
	
	// timeElement가 undefined가 아닌 경우에만 값을 설정
	if (timeElement) {
		timeElement.val(timeOnly);
	}
};


//조회기간 설정
const setDateTimeNoLimit = (dateElement, timeElement, time, displayTime) => {
	if (!displayTime) {
		displayTime = "h";
	}
	let date = new Date(time);
	let dateOnly = date.getFullYear() + "-" 
		+ String(date.getMonth() + 1).padStart(2, "0") + "-" 
		+ String(date.getDate()).padStart(2, "0");
	let timeOnly = String(date.getHours()).padStart(2, "0") + ":"
		+ String(date.getMinutes()).padStart(2, "0") + ":"
		+ String(date.getSeconds()).padStart(2, "0");
	if (String(displayTime).startsWith("h")) {
		timeOnly = String(date.getHours()).padStart(2, "0") + ":00:00";
	} else if (String(displayTime).startsWith("m")) {
		timeOnly = String(date.getHours()).padStart(2, "0") + ":"
			+ String(date.getMinutes()).padStart(2, "0") + ":00";
	}

	dateElement.val(dateOnly);

	// timeElement가 undefined가 아닌 경우에만 값을 설정
	if (timeElement) {
		timeElement.val(timeOnly);
	}
};

// 공정 목록 셀렉트 박스 만들기
function getProcInfoList(sel_id, type, etc_yn){
	if(sel_id == undefined || sel_id == null) { sel_id = "sel_proc";}

	return new Promise((resolve, reject) => {
		$.ajax ({
			type: "POST",
			contentType: "application/json; charset=utf-8",
			cache : false, 
			url: "getProcInfoList",
			dataType: "json",
			data: JSON.stringify({proc_id: "*", etc: etc_yn}),
			success: function(data) {
				if(type == "data") {
					resolve(data);
				} else {
					$("#"+sel_id+" option").remove();
					$("#"+sel_id).append("<option value='*'>전체</option>");
					for (let obj of data) {
						$("#"+sel_id).append("<option value='"+obj.PROCS_ID+"'>"+obj.PROCS_NM+"</option>");
					}
					resolve();
				}
			}, error: function(e) {
				reject();
			}
		});
	});
};

// 데이터소스 조회
function getDataSourceList(sel_id, success_func) {
	if(sel_id == undefined || sel_id == null) {
		sel_id = "sel_dataSource";
	}
	return new Promise((resolve, reject) => {
		$.ajax ({
			type: "POST",
			contentType: "application/json; charset=UTF-8",
			cache : false,
			url: "getDataSourceInfoList",
			data: JSON.stringify({}),
			dataType: "json",
			success: function(data) {
				if (success_func) {
					success_func(data);
				} else {
					$("#" + sel_id + " option").remove();
					for (let obj of data) {
						$("#" + sel_id).append(`<option value='${obj.CD_ID}'>${obj.CD_NM}</option>`);
					}
				}
				resolve();
			},
			error: function(e) {
				MsgBox("Info", "데이터소스 목록 조회에 실패하였습니다.");
				reject();
			}
		});
	});
};

// 룰 조회
function getRuleList(datalist_id, success_func) {
	if(datalist_id == undefined || datalist_id == null) {
		datalist_id = "datas_rule";
	}
	return new Promise((resolve, reject) => {
		$.ajax ({
			type: "POST",
			contentType: "application/json; charset=UTF-8",
			cache : false,
			url: "getRuleList",
			data: JSON.stringify({}),
			dataType: "json",
			success: function(data) {
				if (success_func) {
					success_func(data);
				} else {
					$("#" + datalist_id + " option").remove();
					for (let obj of data) {
						$("#" + datalist_id).append(`<option value='${obj.rule_nm}' data-id='${obj.rule_id}'>${obj.rule_desc}</option>`);
					}
				}
				resolve(data);
			},
			error: function(e) {
				MsgBox("Info", "룰 목록 조회에 실패하였습니다.");
				reject();
			}
		});
	});
};

// 이벤트 기록 내용별 분류 조회
function getEvntInfoList(){

	return new Promise((resolve, reject) => {
		$.ajax ({
			type: "POST",
			contentType: "application/json; charset=utf-8",
			cache : false, 
			url: "getEvntInfoList",
			dataType: "json",
			data: JSON.stringify({}),
			success: function(data) {
				resolve(data);
			}, error: function(e) {
				reject();
			}
		});
	});
};

// 설비 분류 조회
function getFcltInfoList(){

	return new Promise((resolve, reject) => {
		$.ajax ({
			type: "POST",
			contentType: "application/json; charset=utf-8",
			cache : false, 
			url: "getFcltInfoList",
			dataType: "json",
			data: JSON.stringify({}),
			success: function(data) {
				resolve(data);
			}, error: function(e) {
				reject();
			}
		});
	});
};

// 설비 상세 분류 조회
function getFcltDeatilInfoList(fclt_id){
	return new Promise((resolve, reject) => {
		if(!!!fclt_id) fclt_id = "*";
		$.ajax ({
			type: "POST",
			contentType: "application/json; charset=utf-8",
			cache : false, 
			url: "getFcltDeatilInfoList",
			dataType: "json",
			data: JSON.stringify({fclt_id: fclt_id}),
			success: function(data) {
				resolve(data);
			}, error: function(e) {
				reject();
			}
		});
	});
};

// 알람창
function ConfirmBox(title, message, func) {
	Sexy.confirm("<h1>" + title + "</h1><p>" + message + "</p>", {
		textBoxBtnOk: "확인",
		textBoxBtnCancel: "취소",
		onComplete: function(retCode) {
			func(retCode);
		}
	});
};

// 보정 화면 이동
function goCorrection(proc_cd, tag_nm) {
	if (tag_nm != undefined && tag_nm != null && tag_nm != "") {
		window.location.href = "dataCorrection?procCd="+encodeURIComponent(proc_cd)+"&tagNm=" + encodeURIComponent(tag_nm);
	} else {
		alert("먼저 태그를 선택해 주세요.");
	}
};

// jsGrid 선택된 row 데이터 가져오기
function getJsGridSelectedRow(id){
	let fields = $("#"+id).jsGrid("option", "fields");
	let selectedTr = $("#"+id).find("table tr.jsgrid-highlight-row");
	let obj = {};
	for(let idx in fields){
		let data = "";
		if(fields[idx].type == "image"){
			data = selectedTr.find('td:eq('+idx+')').find('img')[0].currentSrc;
		} else{
			data = selectedTr.find('td:eq('+idx+')').text();
		}
		obj[fields[idx].name] = data;
	}
	
	return obj;
};

function addJsGridField(type){
	if(type == "image"){
		var ImageField = function(config){
			jsGrid.Field.call(this, config);
		};
		
		ImageField.prototype = new jsGrid.Field({
			itemTemplate: function(value, item) {
				if(value === null){
					return "<img src=''>";	
				}else{
					return "<img class='fclt-jsgrid-field-img' src='data:image/png;base64,"+value+"'>";
				}
			}
		});
		
		jsGrid.fields.image = ImageField;
	}
};

function checkFromToInvaildate(from, to){
	// 날짜 유효성 검사
	// true : 정상, false 비정상
	
	if(moment(from).isAfter(to)){
		return false;
	}
	
	return true;
};

// 메시지 박스
function MsgBox(txtHeader,txtContent) {
	Sexy.alert("<h1>"+txtHeader+"</h1><p>"+txtContent+"</p>");
};

function getFontSizeByMedia() {
	let fontSize = 16;
	if (document.readyState == "complete") {
		if (window.matchMedia("(max-width: 1450px)").matches) {
			fontSize = 13;
		} else if (window.matchMedia("(max-width: 1550px)").matches) {
			fontSize = 14;
		} else if (window.matchMedia("(max-width: 1650px)").matches) {
			fontSize = 15;
		}
	} else {
		if (window.innerWidth <= 1450) {
			fontSize = 13;
		} else if (window.innerWidth <= 1550) {
			fontSize = 14;
		} else if (window.innerWidth <= 1650) {
			fontSize = 15;
		}
	}
	return fontSize;
};

function getWidthByElementSize(width, emtMaxWidth, emt) {
	let ratio = width / emtMaxWidth;
	let screenSize = emt.clientWidth;
	return Math.floor(ratio * screenSize * 10) / 10;
	/*
	let ratio = width / 1920;
	let screenSize = window.innerWidth;
	if (screenSize <= 1450) {
		screenSize = 1450;
	}
	return ratio * screenSize;
	*/
};

// HEX to RGB
function hexToRgb(hex) {
	hex = hex.replace("#", "");
	let r = parseInt(hex.slice(0, 2), 16);
	let g = parseInt(hex.slice(2, 4), 16);
	let b = parseInt(hex.slice(4, 6), 16);
	return { r, g, b };
};

// RGB to HEX
function rgbToHex(r, g, b) {
	return "#" + [r, g, b].map(value => {
		let hex = value.toString(16);
		return hex.length == 1 ? "0" + hex : hex;
	}).join("");
};

// 16진수 평균을 구함
function blendColors(hex1, hex2, ratio = 0.5) {
	let rgb1 = hexToRgb(hex1);
	let rgb2 = hexToRgb(hex2);

	let r = Math.round(rgb1.r * (1 - ratio) + rgb2.r * ratio);
	let g = Math.round(rgb1.g * (1 - ratio) + rgb2.g * ratio);
	let b = Math.round(rgb1.b * (1 - ratio) + rgb2.b * ratio);

	return rgbToHex(r, g, b);
};

function gridColumnResizeEvent(grid, tableWidth, columnMinWidth) {
	if (!tableWidth) {
		tableWidth = 520;
	}
	if (!columnMinWidth) {
		columnMinWidth = 40;
	}
	grid.on("columnResize", function(ev) {
		let columns = grid.getColumns().filter(column => !column.hidden);
		const columnsLen = columns.length;
		const columnMaxWidth = tableWidth - columnMinWidth * (columnsLen - 1);
		let widthList = columns.flatMap(column => column.baseWidth);
		let totalWidth = columns.reduce((totalWidth, column) => totalWidth + column.baseWidth, 0);
		let diffWidth = tableWidth - totalWidth;
		let columnIdx = columns.findIndex(column => column.name == ev.resizedColumns[0].columnName)
		if (columnsLen - 1 < columnIdx + 1) {
			columnIdx = columnIdx - 1;
		} else {
			columnIdx = columnIdx + 1;
		}
		widthList[columnIdx] = widthList[columnIdx] + diffWidth;
		let isChnage = false;
		for (let idx in widthList) {
			if (widthList[idx] > columnMaxWidth) {
				widthList[idx] = columnMaxWidth;
				isChnage = true;
			}
			if (widthList[idx] < columnMinWidth) {
				widthList[idx] = columnMinWidth;
				isChnage = true;
			}
		}
		if (isChnage) {
			setTimeout(() => grid.resetColumnWidths(widthList), 10);
		} else {
			grid.resetColumnWidths(widthList);
		}
	});
};