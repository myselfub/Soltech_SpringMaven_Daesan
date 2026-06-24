<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>원수저류조 실시 설계서</title>
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
			"data-01-01" : "CDSWSS.LIT201A.F_CV",
			"data-01-02" : "CDSWSS.LIT201B.F_CV",
			"data-01-03" : "CDSWSS.FIT202.F_CV",
			"data-01-04" : "CDSWSS.PIT201.F_CV",
			"data-01-05" : "CDSWSS.M111A_FO_STS.F_CV",
			"data-01-06" : "CDSWSS.M111B_FO_STS.F_CV",
			"data-02-01" : "CDSWSS.SS101.F_CV",
			"data-02-02" : "CDSWSS.ALG101.F_CV",
			"data-02-03" : "CDSWSS.OIL101.F_CV",
			"data-02-04" : "CDSWSS.ORP101.F_CV",
			"data-02-05" : "CDSWSS.TOC101.F_CV",
			"data-02-06" : "CDSWSS.Sal101.F_CV",
			"data-02-07" : "CDSWSS.CE101.F_CV",
			"data-02-08" : "CDSWSS.Ph101.F_CV",
			"data-02-09" : "CDSWSS.TbE101.F_CV",
			"data-02-10" : "CDSWSS.Cl2101.F_CV",
			"data-03-01" : "CDSWSS.M208_FO_STS.F_CV",
			"data-03-02" : "CDSWSS.LIT202.F_CV",
			"data-03-03" : "CDSWSS.M204A_FO_STS.F_CV",
			"data-03-04" : "CDSWSS.M204B_FO_STS.F_CV",
			"data-03-05" : "CDSWSS.M204C_FO_STS.F_CV",
			"data-03-06" : "CDSWSS.M204D_FO_STS.F_CV",
			"data-03-07" : "CDSWSS.M204E_FO_STS.F_CV",
			"data-03-08" : "CDSWSS.M205A_RUN_STS.F_CV",
			"data-03-09" : "CDSWSS.M205B_RUN_STS.F_CV",
			"data-03-10" : "CDSWSS.M205C_RUN_STS.F_CV",
			"data-03-11" : "CDSWSS.M205D_RUN_STS.F_CV",
			"data-03-12" : "CDSWSS.M205E_RUN_STS.F_CV",
			"data-03-13" : "CDSWSS.M206A_RUN_STS.F_CV",
			"data-03-14" : "CDSWSS.M206C_RUN_STS.F_CV",
			"data-03-15" : "CDSWSS.M206E_RUN_STS.F_CV",
			"data-03-16" : "CDSWSS.M206G_RUN_STS.F_CV",
			"data-03-17" : "CDSWSS.M206I_RUN_STS.F_CV",
			"data-03-18" : "CDSWSS.M206B_RUN_STS.F_CV",
			"data-03-19" : "CDSWSS.M206D_RUN_STS.F_CV",
			"data-03-20" : "CDSWSS.M206F_RUN_STS.F_CV",
			"data-03-21" : "CDSWSS.M206H_RUN_STS.F_CV",
			"data-03-22" : "CDSWSS.M206J_RUN_STS.F_CV",
			"data-03-23" : "CDSWSS.M207A_RUN_STS.F_CV",
			"data-03-24" : "CDSWSS.M207B_RUN_STS.F_CV",
			"data-03-25" : "CDSWSS.M207C_RUN_STS.F_CV",
			"data-03-26" : "CDSWSS.M207D_RUN_STS.F_CV",
			"data-03-27" : "CDSWSS.M207E_RUN_STS.F_CV",
		};

		setDataAtt(dataObj.tagMapping, document);

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
	};
</script>
</head>
<body>
	<div class="scrollBox">
		<div class="area">
			<p class="area-title">데이터</p>
			<div class="real-data-box">
				<div class="data-box">
					<div class="title">취수펌프장</div>
					<div class="values">
						<div class="value">
							<p class="tit">원수저류조 수위 A</p>
							<div class="value-datas">
								<span id="data-01-01" class="val">-</span>
								<p class="unit">m</p>
							</div>
						</div>
						<div class="value">
							<p class="tit">원수저류조 수위 B</p>
							<div class="value-datas">
								<span id="data-01-02" class="val">-</span>
								<p class="unit">m</p>
							</div>
						</div>
						<div class="value">
							<p class="tit">원수저류조 유출유량</p>
							<div class="value-datas">
								<span id="data-01-03" class="val">-</span>
								<p class="unit">㎥/h</p>
							</div>
						</div>
						<div class="value">
							<p class="tit">DAF 유입압력</p>
							<div class="value-datas">
								<span id="data-01-04" class="val">-</span>
								<p class="unit">㎏/㎤</p>
							</div>
						</div>
						<div class="value img-item">
							<p class="tit">원수저류조 유출밸브</p>
							<div class="value-datas">
								<span class="val"><img id="data-01-05" class="off-img"></span>
								<span class="val"><img id="data-01-06" class="off-img"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="data-box">
					<div class="title">원수 수질</div>
					<div style="display: flex; width: 100%; flex: 1 1 0;">
						<div class="values"
							style="border-right: 1px dotted #233664; border-bottom-right-radius: unset; flex-basis: 50%;">
							<div class="value">
								<p class="tit">부유물 농도계</p>
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
									<p class="unit">㎍/㎝</p>
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
				<div class="data-box">
					<div class="title">DAF 운영현황</div>
					<div class="values">
						<div class="value img-item">
							<p class="tit" style="width: 120px; flex: none;">바이패스 수문</p>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-03-01" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1.1;"></div>
							<p class="tit" style="flex: 1.7;">바이패스 수로 수위</p>
							<div class="value-datas" style="flex: 1;">
								<span id="data-03-02" class="val">-</span>
								<p class="unit">m</p>
							</div>
							<div class="value-datas" style="flex: 0.2;"></div>
						</div>
						<div class="value img-item">
							<p class="tit" style="flex: 2;">유입 수문</p>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-03-03" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-03-04" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-03-05" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-03-06" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-03-07" class="off-img"></span>
							</div>
						</div>
						<div class="value img-item">
							<p class="tit" style="flex: 2;">교반기(혼화조)</p>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-03-08" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-03-09" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-03-10" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-03-11" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-03-12" class="off-img"></span>
							</div>
						</div>
						<div class="value img-item">
							<p class="tit" style="flex: 2;">교반기(응집조A)</p>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-03-13" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-03-14" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-03-15" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-03-16" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-03-17" class="off-img"></span>
							</div>
						</div>
						<div class="value img-item">
							<p class="tit" style="flex: 2;">교반기(응집조B)</p>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-03-18" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-03-19" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-03-20" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-03-21" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-03-22" class="off-img"></span>
							</div>
						</div>
						<div class="value img-item">
							<p class="tit" style="flex: 2;">부상분리조</p>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-03-23" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-03-24" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-03-25" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-03-26" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-03-27" class="off-img"></span>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>