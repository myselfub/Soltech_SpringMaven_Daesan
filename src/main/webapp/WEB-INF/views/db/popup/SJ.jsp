<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>생산수조 실시 설계서</title>
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
			"data-01-01" : "CDSWSS.Cl481.F_CV",
			"data-01-02" : "CDSWSS.CE481.F_CV",
			"data-01-03" : "CDSWSS.SAL481.F_CV",
			"data-01-04" : "CDSWSS.PH481.F_CV",
			"data-02-01" : "CDSWSS.Cl482.F_CV",
			"data-02-02" : "CDSWSS.TDS482.F_CV",
			"data-02-03" : "CDSWSS.HAD482.F_CV",
			"data-02-04" : "CDSWSS.CE482.F_CV",
			"data-02-05" : "CDSWSS.TbE482.F_CV",
			"data-02-06" : "CDSWSS.PH482.F_CV",
			"data-03-01" : "CDSWSS.FIT481.F_CV",
			"data-03-02" : "CDSWSS.PIT481.F_CV",
			"data-03-03" : "CDSWSS.LIT481A_PER.F_CV",
			"data-03-04" : "CDSWSS.TODO.F_CV",
			"data-03-05" : "CDSWSS.LIT481B_PER.F_CV",
			"data-03-06" : "CDSWSS.TODO.F_CV",
			"data-04-01" : "CDSWSS.FIT482.F_CV",
			"data-04-02" : "CDSWSS.PIT482.F_CV",
			"data-04-03" : "CDSWSS.FIT701A.F_CV",
			"data-04-04" : "CDSWSS.PIT701A.F_CV",
			"data-04-05" : "CDSWSS.FIT701B.F_CV",
			"data-04-06" : "CDSWSS.PIT701B.F_CV",
			"data-04-07" : "CDSWSS.FIT701C.F_CV",
			"data-04-08" : "CDSWSS.PIT701C.F_CV",
			"data-04-09" : "CDSWSS.FIT701D.F_CV",
			"data-04-10" : "CDSWSS.PIT701D.F_CV",
			"data-05-01" : "CDSWSS.FIT541B.F_CV",
			"data-05-02" : "CDSWSS.M511A_RUN_STS.F_CV",
			"data-05-03" : "CDSWSS.M511B_RUN_STS.F_CV",
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
				<div class="data-box" style="flex: 18%;">
					<div class="title">생산수 유입</div>
					<div class="values">
						<div class="value">
							<p class="tit">염소이온농도</p>
							<div class="value-datas">
								<span id="data-01-01" class="val">-</span>
								<p class="unit">Ph</p>
							</div>
						</div>
						<div class="value">
							<p class="tit">전기전도도</p>
							<div class="value-datas">
								<span id="data-01-02" class="val">-</span>
								<p class="unit">㎲/㎝</p>
							</div>
						</div>
						<div class="value">
							<p class="tit">염분도계</p>
							<div class="value-datas">
								<span id="data-01-03" class="val">-</span>
								<p class="unit">Ph</p>
							</div>
						</div>
						<div class="value">
							<p class="tit">수소이온농도</p>
							<div class="value-datas">
								<span id="data-01-04" class="val">-</span>
								<p class="unit">Ph</p>
							</div>
						</div>
					</div>
				</div>
				<div class="data-box" style="flex: 20%;">
					<div class="title">생산수 유출</div>
					<div class="values">
						<div class="value">
							<p class="tit">염소이온농도</p>
							<div class="value-datas">
								<span id="data-02-01" class="val">-</span>
								<p class="unit">Ph</p>
							</div>
						</div>
						<div class="value">
							<p class="tit">총용존고형물계</p>
							<div class="value-datas">
								<span id="data-02-02" class="val">-</span>
								<p class="unit">㎎/L</p>
							</div>
						</div>
						<div class="value">
							<p class="tit">총경도</p>
							<div class="value-datas">
								<span id="data-02-03" class="val">-</span>
								<p class="unit">㎎/L</p>
							</div>
						</div>
						<div class="value">
							<p class="tit">전기전도도</p>
							<div class="value-datas">
								<span id="data-02-04" class="val">-</span>
								<p class="unit">㎲/㎝</p>
							</div>
						</div>
						<div class="value">
							<p class="tit">탁도</p>
							<div class="value-datas">
								<span id="data-02-05" class="val">-</span>
								<p class="unit">NTU</p>
							</div>
						</div>
						<div class="value">
							<p class="tit">수소이온농도</p>
							<div class="value-datas">
								<span id="data-02-06" class="val">-</span>
								<p class="unit">Ph</p>
							</div>
						</div>
					</div>
				</div>
				<div class="data-box" style="flex: 21%;">
					<div class="title">생산수</div>
					<div class="values">
						<div class="value">
							<p class="tit">유입유량</p>
							<div class="value-datas">
								<span id="data-03-01" class="val">-</span>
								<p class="unit">㎥/h</p>
							</div>
						</div>
						<div class="value">
							<p class="tit">유입압력</p>
							<div class="value-datas">
								<span id="data-03-02" class="val">-</span>
								<p class="unit">㎏/㎠</p>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1;"></p>
							<p class="tit"
								style="display: flex; flex: 1; text-align: center;">수위</p>
							<p class="tit"
								style="display: flex; flex: 1; text-align: center;">수량</p>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1;">수조 A</p>
							<div class="value-datas" style="flex: 1;">
								<span id="data-03-03" class="val">-</span>
								<p class="unit">%</p>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span id="data-03-04" class="val">-</span>
								<p class="unit">㎥</p>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1;">수조 B</p>
							<div class="value-datas" style="flex: 1;">
								<span id="data-03-05" class="val">-</span>
								<p class="unit">%</p>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span id="data-03-06" class="val">-</span>
								<p class="unit">㎥</p>
							</div>
						</div>
					</div>
				</div>
				<div class="data-box" style="flex: 26%;">
					<div class="title">유출 유량/압력</div>
					<div class="values">
						<div class="value">
							<p class="tit" style="flex: 1;">생산수</p>
							<div class="value-datas" style="flex: 3;">
								<div class="value-datas" style="flex: 1;">
									<span id="data-04-01" class="val">-</span>
									<p class="unit">㎥/h</p>
								</div>
								<div class="value-datas" style="flex: 1;">
									<span id="data-04-02" class="val">-</span>
									<p class="unit">㎏/㎠</p>
								</div>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1;">현대오일뱅크</p>
							<div class="value-datas" style="flex: 3;">
								<div class="value-datas" style="flex: 1;">
									<span id="data-04-03" class="val">-</span>
									<p class="unit">㎥/h</p>
								</div>
								<div class="value-datas" style="flex: 1;">
									<span id="data-04-04" class="val">-</span>
									<p class="unit">㎏/㎠</p>
								</div>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1;">LG 화학</p>
							<div class="value-datas" style="flex: 3;">
								<div class="value-datas" style="flex: 1;">
									<span id="data-04-05" class="val">-</span>
									<p class="unit">㎥/h</p>
								</div>
								<div class="value-datas" style="flex: 1;">
									<span id="data-04-06" class="val">-</span>
									<p class="unit">㎏/㎠</p>
								</div>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1;">현대 OCI</p>
							<div class="value-datas" style="flex: 3;">
								<div class="value-datas" style="flex: 1;">
									<span id="data-04-07" class="val">-</span>
									<p class="unit">㎥/h</p>
								</div>
								<div class="value-datas" style="flex: 1;">
									<span id="data-04-08" class="val">-</span>
									<p class="unit">㎏/㎠</p>
								</div>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1;">한화 토탈</p>
							<div class="value-datas" style="flex: 3;">
								<div class="value-datas" style="flex: 1;">
									<span id="data-04-09" class="val">-</span>
									<p class="unit">㎥/h</p>
								</div>
								<div class="value-datas" style="flex: 1;">
									<span id="data-04-10" class="val">-</span>
									<p class="unit">㎏/㎠</p>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="data-box" style="flex: 18%;">
					<div class="title">가성소다 투입현황</div>
					<div class="values" style="align-content: flex-start;">
						<div class="value">
							<p class="tit">통합 유출유량</p>
							<div class="value-datas">
								<div class="value-datas">
									<span id="data-05-01" class="val">-</span>
									<p class="unit">㎥/h</p>
								</div>
							</div>
						</div>
						<div class="value">
							<p class="tit">주입펌프A</p>
							<div class="value-datas">
								<div class="value-datas">
									<span class="val"><img id="data-05-02" class="off-img"></span>
								</div>
							</div>
						</div>
						<div class="value">
							<p class="tit">주입펌프B</p>
							<div class="value-datas">
								<div class="value-datas">
									<span class="val"><img id="data-05-03" class="off-img"></span>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

</body>
</html>