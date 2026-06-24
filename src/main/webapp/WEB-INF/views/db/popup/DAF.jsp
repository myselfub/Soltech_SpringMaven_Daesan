<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>전전처리(DAF) 실시 설계서</title>
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
			"data-01-01" : "CDSWSS.M111A_FO_STS.F_CV",
			"data-01-02" : "CDSWSS.M111B_FO_STS.F_CV",
			"data-01-03" : "CDSWSS.LIT201A.F_CV",
			"data-01-04" : "CDSWSS.LIT201B.F_CV",
			"data-01-05" : "CDSWSS.M502A_RUN_STS.F_CV",
			"data-01-06" : "CDSWSS.M502B_RUN_STS.F_CV",
			"data-01-07" : "CDSWSS.PIT503.F_CV",
			"data-01-08" : "CDSWSS.FIT501.F_CV",
			"data-01-09" : "CDSWSS.M519A_RUN_STS.F_CV",
			"data-01-10" : "CDSWSS.M519B_RUN_STS.F_CV",
			"data-01-11" : "CDSWSS.PIT523.F_CV",
			"data-01-12" : "CDSWSS.FIT521.F_CV",
			"data-01-13" : "CDSWSS.M505A_RUN_STS.F_CV",
			"data-01-14" : "CDSWSS.M505B_RUN_STS.F_CV",
			"data-01-15" : "CDSWSS.PIT513.F_CV",
			"data-01-16" : "CDSWSS.FIT511.F_CV",
			"data-02-01" : "CDSWSS.M208_FO_STS.F_CV",
			"data-02-02" : "CDSWSS.LIT202.F_CV",
			"data-02-03" : "CDSWSS.M204A_FO_STS.F_CV",
			"data-02-04" : "CDSWSS.M204B_FO_STS.F_CV",
			"data-02-05" : "CDSWSS.M204C_FO_STS.F_CV",
			"data-02-06" : "CDSWSS.M204D_FO_STS.F_CV",
			"data-02-07" : "CDSWSS.M204E_FO_STS.F_CV",
			"data-02-08" : "CDSWSS.M205A_RUN_STS.F_CV",
			"data-02-09" : "CDSWSS.M205B_RUN_STS.F_CV",
			"data-02-10" : "CDSWSS.M205C_RUN_STS.F_CV",
			"data-02-11" : "CDSWSS.M205D_RUN_STS.F_CV",
			"data-02-12" : "CDSWSS.M205E_RUN_STS.F_CV",
			"data-02-13" : "CDSWSS.M206A_RUN_STS.F_CV",
			"data-02-14" : "CDSWSS.M206C_RUN_STS.F_CV",
			"data-02-15" : "CDSWSS.M206E_RUN_STS.F_CV",
			"data-02-16" : "CDSWSS.M206G_RUN_STS.F_CV",
			"data-02-17" : "CDSWSS.M206I_RUN_STS.F_CV",
			"data-02-18" : "CDSWSS.M206B_RUN_STS.F_CV",
			"data-02-19" : "CDSWSS.M206D_RUN_STS.F_CV",
			"data-02-20" : "CDSWSS.M206F_RUN_STS.F_CV",
			"data-02-21" : "CDSWSS.M206H_RUN_STS.F_CV",
			"data-02-22" : "CDSWSS.M206J_RUN_STS.F_CV",
			"data-02-23" : "CDSWSS.M207A_RUN_STS.F_CV",
			"data-02-24" : "CDSWSS.M207B_RUN_STS.F_CV",
			"data-02-25" : "CDSWSS.M207C_RUN_STS.F_CV",
			"data-02-26" : "CDSWSS.M207D_RUN_STS.F_CV",
			"data-02-27" : "CDSWSS.M207E_RUN_STS.F_CV",
		};

		setDataAtt(dataObj.tagMapping, document);

		// SVG
		ajaxImg("DAF.svg").then((emtSvg) => {
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
				<div class="data-box" style="flex: 1.3;">
					<div class="title">DAF</div>
					<div style="display: flex; width: 100%; flex: 1 1 0;">
						<div class="values"
							style="border-right: 1px dotted #233664; border-bottom-right-radius: unset; flex-basis: 50%;">
							<div class="value-ttl">원수 저류조</div>
							<div class="value img-item">
								<p class="tit">원수 저류조 유출 밸브</p>
								<div class="value-datas">
									<span class="val"><img id="data-01-01" class="off-img"></span>
									<span class="val"><img id="data-01-02" class="off-img"></span>
								</div>
							</div>
							<div class="value">
								<p class="tit">원수저류조 수위 A</p>
								<div class="value-datas">
									<span id="data-01-03" class="val">-</span>
									<p class="unit">m</p>
								</div>
							</div>
							<div class="value">
								<p class="tit">원수저류조 수위 B</p>
								<div class="value-datas">
									<span id="data-01-04" class="val">-</span>
									<p class="unit">m</p>
								</div>
							</div>
							<div class="value-ttl">H2SO4</div>
							<div class="value img-item">
								<p class="tit">주입펌프</p>
								<div class="value-datas">
									<span class="val"><img id="data-01-05" class="off-img"></span>
									<span class="val"><img id="data-01-06" class="off-img"></span>
								</div>
							</div>
							<div class="value">
								<p class="tit">유출압력</p>
								<div class="value-datas">
									<span id="data-01-07" class="val">-</span>
									<p class="unit">㎏/㎤</p>
								</div>
							</div>
							<div class="value">
								<p class="tit">유출유량</p>
								<div class="value-datas">
									<span id="data-01-08" class="val">-</span>
									<p class="unit">㎥/h</p>
								</div>
							</div>
						</div>
						<div class="values"
							style="border-left: none; border-bottom-left-radius: unset; flex-basis: 50%;">
							<div class="value-ttl">NaOCl</div>
							<div class="value img-item">
								<p class="tit">주입펌프</p>
								<div class="value-datas">
									<span class="val"><img id="data-01-09" class="off-img"></span>
									<span class="val"><img id="data-01-10" class="off-img"></span>
								</div>
							</div>
							<div class="value">
								<p class="tit">유출압력</p>
								<div class="value-datas">
									<span id="data-01-11" class="val">-</span>
									<p class="unit">㎏/㎤</p>
								</div>
							</div>
							<div class="value">
								<p class="tit">유출유량</p>
								<div class="value-datas">
									<span id="data-01-12" class="val">-</span>
									<p class="unit">㎥/h</p>
								</div>
							</div>
							<div class="value-ttl">FeCl</div>
							<div class="value img-item">
								<p class="tit">주입펌프</p>
								<div class="value-datas">
									<span class="val"><img id="data-01-13" class="off-img"></span>
									<span class="val"><img id="data-01-14" class="off-img"></span>
								</div>
							</div>
							<div class="value">
								<p class="tit">유출 압력</p>
								<div class="value-datas">
									<span id="data-01-15" class="val">-</span>
									<p class="unit">㎏/㎤</p>
								</div>
							</div>
							<div class="value">
								<p class="tit">유출 유량</p>
								<div class="value-datas">
									<span id="data-01-16" class="val">-</span>
									<p class="unit">㎥/h</p>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="data-box" style="flex: 1;">
					<div class="title">운전 현황</div>
					<div class="values">
						<div class="value img-item">
							<p class="tit" style="flex: 2;">바이패스 수문</p>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-01" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1.1;"></div>
							<p class="tit" style="flex: 1.7;">바이패스 수로 수위</p>
							<div class="value-datas" style="flex: 1;">
								<span id="data-02-02" class="val">-</span>
								<p class="unit">m</p>
							</div>
							<div class="value-datas" style="flex: 0.2;"></div>
						</div>
						<div class="value img-item">
							<p class="tit" style="flex: 2;">유입 수문</p>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-03" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-04" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-05" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-06" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-07" class="off-img"></span>
							</div>
						</div>
						<div class="value img-item">
							<p class="tit" style="flex: 2;">교반기(혼화조)</p>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-08" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-09" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-10" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-11" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-12" class="off-img"></span>
							</div>
						</div>
						<div class="value img-item">
							<p class="tit" style="flex: 2;">교반기(응집조A)</p>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-13" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-14" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-15" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-16" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-17" class="off-img"></span>
							</div>
						</div>
						<div class="value img-item">
							<p class="tit" style="flex: 2;">교반기(응집조B)</p>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-18" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-19" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-20" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-21" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-22" class="off-img"></span>
							</div>
						</div>
						<div class="value img-item">
							<p class="tit" style="flex: 2;">부상분리조</p>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-23" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-24" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-25" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-26" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-27" class="off-img"></span>
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