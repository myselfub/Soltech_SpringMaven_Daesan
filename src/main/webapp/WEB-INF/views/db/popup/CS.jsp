<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>취수구 실시 설계서</title>
<script type="text/javascript">
	window.onload = function() {
		if (dataObj) {
			dataObj.isEvent = false;
			dataObj.eventTime = 10;
			dataObj.timeOutTime = 10;
			dataObj.timeOutId = null;
		} else {
			window.dataObj = {
				isEvent: false,
				eventTime: 10,
				timeOutTime: 10,
				timeOutId: null
			};
		}
		if (dataObj.url) {
			let urlLast = dataObj.url.split("/").slice(-1)[0];
			let sizeArr = dataObj.popupSize[urlLast] || dataObj.popupSize["rest"];
			self.resizeTo(sizeArr[0], sizeArr[1]);
		}
		loadData();
	};

	function ajaxImg(imgNm) {
		return new Promise((resolve, reject) => {
			$.ajax ({
				type: "GET",
				contentType: "xml; charset=UTF-8",
				url: "/resources/images/view/db/popup/" + imgNm,
				cache: true,
				success: function(res) {
					let emtSvg = res.documentElement;

					// SVG 넓이 조정
					emtSvg.setAttribute("width", "100%");
					emtSvg.setAttribute("height", "100%");
					emtSvg.setAttribute("preserveAspectRatio", "none");
					resolve(emtSvg);
				},
				error: function(e) {
					console.error(e);
				}
			});
		});
	};

	function ajaxData(tagList) {
		let newTagList = [];
		tagList.forEach(item => {
			if (item.includes(",")) {
				let splited = item.split(",");
				splited.forEach(splitedItem => {
					newTagList.push(splitedItem.trim());
				});
			} else {
				newTagList.push(item);
			}
		});
		return new Promise((resolve, reject) => {
			let obj = {
				"cmd" : "reqValues",
				"timeout" : 15 * 1000,
				"dest" : "historian",
				"param" : {
					"tagList" : Array.from(new Set(newTagList))
				}
			}

			$.ajax ({
				type: "POST",
				contentType: "application/json; charset=UTF-8",
				url: "/reqHistorian",
				dataType: "json",
				cache: true,
				data: JSON.stringify(obj),
				success: function(res) {
					let resultParam = res.param;
					let newResultParam = [];
					tagList.forEach(tagName => {
						let resultItem = null;
						if (tagName.includes(",")) {
							let splited = tagName.split(",");
							let resultName = "";
							let resultVal = "";
							splited.forEach(splitedItem => {
								resultItem = resultParam.find(paramItem => paramItem.name == splitedItem);
								if (resultItem) {
									resultName = resultName + resultItem.name + ",";
									resultVal = resultVal + resultItem.val + ",";
								}
							});
							if (resultName.endsWith(",")) {
								resultName = resultName.slice(0, -1);
							}
							if (resultVal.endsWith(",")) {
								resultVal = resultVal.slice(0, -1);
							}
							if (resultItem) {
								resultItem.name = resultName;
								resultItem.val = resultVal;
							}
						} else {
							resultItem = resultParam.find(paramItem => paramItem.name == tagName);
						}
						if (!resultItem) {
							resultItem = {
								"name" : tagName,
								"time" : null,
								"val" : null,
								"conf" : 0
							};
						}
						newResultParam.push(resultItem);
					});
					res.param = newResultParam;
					resolve(res);
				},
				error: function(e) {
					console.error(e);
				}
			});
		});
	};
	
	function timeOutData(func) {
		if (dataObj.timeOutId) {
			clearTimeout(dataObj.timeOutId);
			dataObj.timeOutId = null;
		}
		let timeOutFunc = () => {
			func();
			dataObj.timeOutId = setTimeout(timeOutFunc, dataObj.timeOutTime * 1000);
		};
		func();
		dataObj.timeOutId = setTimeout(timeOutFunc, dataObj.timeOutTime * 1000);
	};

	function setDataAtt(tagMapping, emtSvg) {
		Object.keys(tagMapping).forEach(key => {
			let emt = emtSvg.querySelector("#" + key);
			let textEmt = null;
			if (emt) {
				if (emt.tagName && emt.tagName.toLowerCase() == "text") {
					textEmt = emt.querySelector("tspan");
				} else if (emt.tagName && (emt.tagName.toLowerCase() == "tspan" || emt.tagName.toLowerCase() == "span")) {
					textEmt = emt;
				} else if (emt.tagName && emt.tagName.toLowerCase() == "img") {
					textEmt = emt;
				} else if (emt.tagName && (emt.tagName.toLowerCase() == "g" || emt.tagName.toLowerCase() == "circle")) {
					textEmt = emt;
				}
			} else if (!emt && key.endsWith("-")) {
				textEmt = emtSvg.querySelector("#" + key + "off");
			}
			if (textEmt) {
				textEmt.setAttribute("data-tag", tagMapping[key]);
			}
		});
	};

	function loadData() {
		dataObj.tagMapping = {
			"data-01-01" : "CDSWSS.LIT101A.F_CV",
			"data-01-02" : "CDSWSS.LIT101B.F_CV",
			"data-01-03" : "CDSWSS.LIT101C.F_CV",
			"data-01-04" : "CDSWSS.M116A_FO_STS.F_CV",
			"data-01-05" : "CDSWSS.M116B_FO_STS.F_CV",
			"data-01-06" : "CDSWSS.M116C_FO_STS.F_CV",
			"data-01-07" : "CDSWSS.M106A_RUN_STS.F_CV",
			"data-01-08" : "CDSWSS.M106B_RUN_STS.F_CV",
			"data-01-09" : "CDSWSS.M106C_RUN_STS.F_CV",
			"data-01-10" : "CDSWSS.PIT104.F_CV",
			"data-01-11" : "CDSWSS.FIT201.F_CV",
			"data-01-12" : "CDSWSS.LIT201A.F_CV",
			"data-01-13" : "CDSWSS.LIT201B.F_CV",
			"data-02-01" : "CDSWSS.SS101.F_CV",
			"data-02-02" : "CDSWSS.ALG101.F_CV",
			"data-02-03" : "CDSWSS.OIL101.F_CV",
			"data-02-04" : "CDSWSS.ORP101.F_CV",
			"data-02-05" : "CDSWSS.TOC101.F_CV",
			"data-02-06" : "CDSWSS.Sal101.F_CV",
			"data-02-07" : "CDSWSS.EC101.F_CV",
			"data-02-08" : "CDSWSS.Ph101.F_CV",
			"data-02-09" : "CDSWSS.TbE101.F_CV",
			"data-02-10" : "CDSWSS.Cl2101.F_CV",
			"data-03-01" : "CDSWSS.PIT101A.F_CV",
			"data-03-02" : "CDSWSS.M107A_FO_STS.F_CV",
			"data-03-03" : "CDSWSS.PIT101B.F_CV",
			"data-03-04" : "CDSWSS.M107B_FO_STS.F_CV",
			"data-03-05" : "CDSWSS.PIT101C.F_CV",
			"data-03-06" : "CDSWSS.M107C_FO_STS.F_CV",
			"data-04-01" : "CDSWSS.FIT101.F_CV",
			"data-04-02" : "CDSWSS.PIT102.F_CV",
			"data-04-03" : "CDSWSS.PIT103.F_CV",
		};

		setDataAtt(dataObj.tagMapping, document);
		// SVG
		ajaxImg("CS.svg").then((emtSvg) => {
			$("#imgContents").append(emtSvg);

			let ajaxDataFunc = () => {
				ajaxData(Object.values(dataObj.tagMapping)).then((res) => {
					if (res) {
						res.param.forEach(item => {
							let emts = document.querySelectorAll("[data-tag='" + item.name + "']");
							emts.forEach(emt => {
								if (emt.tagName && emt.tagName.toLowerCase() == "span") {
									let preText = emt.textContent;
									let itemVal = item.val;
									if (itemVal != null) {
										if (preText != itemVal.toLocaleString("ko-KR")) {
											emt.textContent = itemVal.toLocaleString("ko-KR");
										}
									} else {
										emt.textContent = itemVal;
									}
								} else if (emt.tagName && emt.tagName.toLowerCase() == "img") {
									let onOffData = Number(item.val) == 0 ? false : true;
									if (onOffData) {
										emt.classList.add("on-img");
										emt.classList.remove("off-img");
									} else {
										emt.classList.remove("on-img");
										emt.classList.add("off-img");
									}
								}
							});
						});
					}
				});
			};
			timeOutData(ajaxDataFunc);
		});
	};
</script>
</head>
<body>
	<div class="scrollBox">
		<div class="area">
			<p class="area-title">데이터</p>
			<div class="real-data-box">
				<div class="data-box" style="flex:0.2">
					<div class="title">주요 현황</div>
					<div class="values">
						<div class="value" style="justify-content: flex-start;">
							<p class="tit" style="flex: 1.5;">취수 펌프장 수위</p>
							<div class="value-datas" style="flex: 1;">
								<span id="data-01-01" class="val">-</span>
								<p class="unit">m</p>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span id="data-01-02" class="val">-</span>
								<p class="unit">m</p>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span id="data-01-03" class="val">-</span>
								<p class="unit">m</p>
							</div>
						</div>
						<div class="value" style="justify-content: flex-start;">
							<p class="tit" style="flex: 1.5;">흡수정 유입밸브</p>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-01-04" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-01-05" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-01-06" class="off-img"></span>
							</div>
						</div>
						<div class="value" style="justify-content: flex-start;">
							<p class="tit" style="flex: 1.5;">취수 펌프</p>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-01-07" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-01-08" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-01-09" class="off-img"></span>
							</div>
						</div>
						<div class="value" style="justify-content: flex-start;">
							<p class="tit" style="flex: 1.5;">원수저류조 유입 압력</p>
							<div class="value-datas" style="flex: 1;">
								<span id="data-01-10" class="val">-</span>
								<p class="unit">㎏/㎠</p>
							</div>
						</div>
						<div class="value" style="justify-content: flex-start;">
							<p class="tit" style="flex: 1.5;">원수저류조 유입 유량</p>
							<div class="value-datas" style="flex: 1;">
								<span id="data-01-11" class="val">-</span>
								<p class="unit">㎥/h</p>
							</div>
						</div>
						<div class="value" style="justify-content: flex-start;">
							<p class="tit" style="flex: 1.5;">원수저류조 수위</p>
							<div class="value-datas" style="flex: 1;">
								<span id="data-01-12" class="val">-</span>
								<p class="unit">m</p>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span id="data-01-13" class="val">-</span>
								<p class="unit">m</p>
							</div>
						</div>
					</div>
				</div>
				<div class="data-box" style="flex:0.3">
					<div class="title">원수 수질</div>
					<div style="display: flex; width: 100%; flex: 1 1 0;">
						<div class="values"
							style="border-right: 1px dotted #233664; border-bottom-right-radius: unset; flex-basis: 50%;">
							<div class="value">
								<p class="tit">부유물농도</p>
								<div class="value-datas">
									<span id="data-02-01" class="val">-</span>
									<p class="unit">㎎/L</p>
								</div>
							</div>
							<div class="value">
								<p class="tit">조류분석기</p>
								<div class="value-datas">
									<span id="data-02-02" class="val">-</span>
									<p class="unit">㎍/L</p>
								</div>
							</div>
							<div class="value">
								<p class="tit">오일감지기</p>
								<div class="value-datas">
									<span id="data-02-03" class="val">-</span>
									<p class="unit">㎎/L</p>
								</div>
							</div>
							<div class="value">
								<p class="tit">ORP</p>
								<div class="value-datas">
									<span id="data-02-04" class="val">-</span>
									<p class="unit">㎷</p>
								</div>
							</div>
							<div class="value">
								<p class="tit">총 유기 탄소</p>
								<div class="value-datas">
									<span id="data-02-05" class="val">-</span>
									<p class="unit">㎎/L</p>
								</div>
							</div>
						</div>
						<div class="values"
							style="border-left: none; border-bottom-left-radius: unset; flex-basis: 50%;">
							<div class="value">
								<p class="tit">염분도계</p>
								<div class="value-datas">
									<span id="data-02-06" class="val">-</span>
									<p class="unit">psu</p>
								</div>

							</div>
							<div class="value">
								<p class="tit">전기전도도</p>
								<div class="value-datas">
									<span id="data-02-07" class="val">-</span>
									<p class="unit">㎲/㎝</p>
								</div>
							</div>
							<div class="value">
								<p class="tit">수소이온농도</p>
								<div class="value-datas">
									<span id="data-02-08" class="val">-</span>
									<p class="unit">Ph</p>
								</div>
							</div>
							<div class="value">
								<p class="tit">탁도</p>
								<div class="value-datas">
									<span id="data-02-09" class="val">-</span>
									<p class="unit">NTU</p>
								</div>
							</div>
							<div class="value">
								<p class="tit">잔류염소</p>
								<div class="value-datas">
									<span id="data-02-10" class="val">-</span>
									<p class="unit">㎎/L</p>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="data-box" style="flex:0.25">
					<div class="title">세부 현황</div>
					<div class="values">
						<div class="value">
							<p class="tit">취수펌프 유입압력A</p>
							<div class="value-datas">
								<span id="data-03-01" class="val">-</span>
								<p class="unit">㎏/㎠</p>
							</div>
						</div>
						<div class="value">
							<p class="tit">취수펌프 토출밸브A</p>
							<div class="value-datas">
								<span class="val"><img id="data-03-02" class="off-img"></span>
							</div>
						</div>
						<div class="value">
							<p class="tit">취수펌프 유입압력B</p>
							<div class="value-datas">
								<span id="data-03-03" class="val">-</span>
								<p class="unit">㎏/㎠</p>
							</div>
						</div>
						<div class="value">
							<p class="tit">취수펌프 토출밸브B</p>
							<div class="value-datas">
								<span class="val"><img id="data-03-04" class="off-img"></span>
							</div>
						</div>
						<div class="value">
							<p class="tit">취수펌프 유입압력C</p>
							<div class="value-datas">
								<span id="data-03-05" class="val">-</span>
								<p class="unit">㎏/㎠</p>
							</div>
						</div>
						<div class="value">
							<p class="tit">취수펌프 토출밸브C</p>
							<div class="value-datas">
								<span class="val"><img id="data-03-06" class="off-img"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="data-box" style="flex:0.25">
					<div class="title">세부 현황</div>
					<div class="values" style="align-content: flex-start;">
						<div class="value">
							<p class="tit">NaOCI 통합 유량</p>
							<div class="value-datas">
								<span id="data-04-01" class="val">-</span>
								<p class="unit">㎥/h</p>
							</div>
						</div>
						<div class="value">
							<p class="tit">NaOCI 통합 유출 압력</p>
							<div class="value-datas">
								<span id="data-04-02" class="val">-</span>
								<p class="unit">㎏/㎠</p>
							</div>
						</div>
						<div class="value">
							<p class="tit">NaOCI 저장탱크 유출 압력</p>
							<div class="value-datas">
								<span id="data-04-03" class="val">-</span>
								<p class="unit">㎏/㎠</p>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div id="imgContents" class="area">
			<p class="area-title">공정 상세</p>
		</div>
	</div>
</body>
</html>